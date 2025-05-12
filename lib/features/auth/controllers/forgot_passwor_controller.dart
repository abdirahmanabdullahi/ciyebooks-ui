import 'dart:io';

import 'package:ciyebooks/data/repositories/auth/auth_repo.dart';
import 'package:ciyebooks/features/auth/screens/password_config/reset_password.dar/resend_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/error_dialog.dart';


class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  ///Variables
  final isLoading = false.obs;
  final email = TextEditingController();
  GlobalKey<FormState> forgotPasswordFormKey2 = GlobalKey<FormState>();

  /// Send password reset email
validateField(BuildContext context){
  isLoading.value = true;

  if (!forgotPasswordFormKey2.currentState!.validate()) {
    isLoading.value = false;
    return;
  }
  checkInternetConnection(context);
}
  /// Check internet connection
  checkInternetConnection(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (context.mounted) {
          sendPasswordResetLink();
        }
      }
    } on SocketException catch (_) {
      isLoading.value = false;

      if (context.mounted) {
        showErrorDialog(context: context, errorTitle: 'Connection error!', errorText: 'Please check your network connection and try again.');
      }
      return;
    }
  }

  void sendPasswordResetLink() async {
    try {



      /// Send password reset link
      await AuthRepo.instance.sendPasswordResetLink(email.text.trim());
      isLoading.value = false;
      Get.snackbar(
          "Email sent", "Reset password link has been sent to your email",
          icon: Icon(
            Icons.task_alt,
            color: Colors.white,
          ),
          backgroundColor: Colors.green,
          colorText: Colors.white);
      Get.to(() => ResendPassword());
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error!", e.toString(),
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          backgroundColor: Color(0xffFF0033),
          colorText: Colors.white);
    }
  }
    ///Resend password reset link
    void resendPasswordResetLink() async {
      try {
        await AuthRepo.instance.resendPasswordResetLink(email.text.trim());

        ///Show success message
        Get.snackbar("Reset link has been sent", 'Please check your inbox for the reset password link',
            icon: Icon(
              Icons.task_alt,
              color: Colors.white,
            ),
            backgroundColor: Colors.green,
            colorText: Colors.white);

      } catch (e) {
        Get.snackbar("There was an error", e.toString(),
            icon: Icon(
              Icons.error,
              color: Colors.white,
            ),
            backgroundColor: Color(0xffFF0033),
            colorText: Colors.white);
      }
    }
  }

