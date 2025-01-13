import 'package:ciyebooks/data/repositories/auth/auth_repo.dart';
import 'package:ciyebooks/features/auth/screens/password_config/reset_password.dar/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/network_manager.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  ///Variables
  final isLoading = false.obs;
  final email = TextEditingController();
  GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();

  /// Send password reset email

  void sendPasswordResetLink() async {
    try {
      isLoading.value = true;

      ///Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        isLoading.value = false;
        Get.snackbar("Oh snap! No internet connection.",
            "Please check your internet connection and try again",
            icon: Icon(
              Icons.cloud_off,
              color: Colors.white,
            ),
            backgroundColor: Color(0xffFF0033),
            colorText: Colors.white);
        return;
      }

      /// Validate form
      if (!forgotPasswordFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

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
      Get.to(() => ResetPassword());
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
        Get.snackbar("Email has been sent", 'Please check your inbox for the reset password link',
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

