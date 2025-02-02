import 'package:ciyebooks/data/repositories/auth/auth_repo.dart';
import 'package:ciyebooks/features/auth/models/user_model.dart';
import 'package:ciyebooks/features/auth/screens/signup/verify_email.dart';
import 'package:ciyebooks/features/setup/controller/setup_controller.dart';
import 'package:ciyebooks/features/setup/models/setup_model.dart';
import 'package:ciyebooks/utils/constants/text_strings.dart';
import 'package:ciyebooks/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/user/user_repo.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../setup/repo/setup_repo.dart';
import '../screens/signup/controllers/verify_email_controller.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // Variables
  final isLoading = false.obs;
  final hidePassword = true.obs;
  final privacyPolicy = false.obs;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  // SIGNUP

  void signup() async {
    try {
      //Start loading
      isLoading.value = true;
      //Check connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
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

      //Form validation
      if (!signupFormKey.currentState!.validate()) {
        return;
      }
      //Check privacy policy
      if (!privacyPolicy.value) {
        Get.snackbar(
          snackPosition: SnackPosition.BOTTOM,
          "Agree to Privacy policy and terms of use.",
          "To sign up, please agree to our privacy policy and terms of use",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
      final userCredential =
          await AuthRepo.instance.registerWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );

      // Save authenticated data to the firestore.
      final newUser = UserModel(
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        id: userCredential.user!.uid,
        userName: userName.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        accountIsSetup: false,
      );

      ///Create empty setup data
      /// Save user data
      final userRepo = Get.put(UserRepo());
      await userRepo.saveUserDate(newUser);

      /// Save setup data
      final setupRepo = Get.put(SetupRepo());
      final setup = BalancesModel.empty();
      await setupRepo.saveSetupData(setup);

      //Success message
      Get.snackbar('Congratulations', AppTexts.yourAccountCreatedTitle,
          backgroundColor: Colors.green, colorText: Colors.white);

      final controller = Get.put(VerifyEmailController());
      // Send email verification
      await controller.sendVerificationEmail();
      Get.to(VerifyEmail());

      /// Notify user that verification email was sent
      Get.snackbar('Verification email sent',
          'Please check your inbox and verify your email.',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Oh snap!", e.toString(),
          backgroundColor: Color(0xffFF0033), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
