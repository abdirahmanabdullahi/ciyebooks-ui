import 'dart:async';

import 'package:ciyebooks/common/success_screens/success_screen.dart';
import 'package:ciyebooks/utils/constants/image_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/repositories/auth/auth_repo.dart';
import '../../../../../utils/constants/text_strings.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  ///Create a timer for auto check if email is verified
  @override
  void onInit() {
    super.onInit();
    setTimerForAutoRedirect();
  }

  /// Send verification email

  Future<void> sendVerificationEmail() async {
    try {
      await AuthRepo.instance.sendEmailVerification();
      Get.snackbar('Verification email sent',
          'Please check your inbox and verify your email.',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      print(e.toString());
      Get.snackbar("Oh snap! ", e.toString(),
          icon: Icon(
            Icons.cloud_off,
            color: Colors.white,
          ),
          backgroundColor: Color(0xffFF0033),
          colorText: Colors.white);
    }
  }

  void setTimerForAutoRedirect() {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(() => SuccessScreen(
            image: AppImages.staticSuccessIllustration,
            title: AppTexts.emailVerified,
            subtitle: AppTexts.yourAccountCreatedSubTitle,
            onPressed: () => AuthRepo.instance.screenRedirect()));
      }
    });
  }

  /// Manually check if email is verified
  checkEmailVerificationStatus() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(
        () => SuccessScreen(
            image: AppImages.staticSuccessIllustration,
            title: AppTexts.emailVerified,
            subtitle: AppTexts.yourAccountCreatedSubTitle,
            onPressed: ()=> AuthRepo.instance.screenRedirect()
      ));
    }Get.snackbar('Verify your email first',
        'Please check your inbox and verify your email.',
        backgroundColor: Colors.orange, colorText: Colors.white);
  }
}
