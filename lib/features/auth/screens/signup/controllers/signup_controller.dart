import 'dart:io';

import 'package:ciyebooks/data/repositories/auth/auth_repo.dart';
import 'package:ciyebooks/features/auth/models/user_model.dart';
import 'package:ciyebooks/features/auth/screens/login/widgets/verify_email.dart';
import 'package:ciyebooks/features/setup/models/setup_model.dart';
import 'package:ciyebooks/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/error_dialog.dart';
import '../../../../../data/repositories/user/user_repo.dart';
import '../../../../setup/repo/setup_repo.dart';
import '../../../controllers/verify_email_controller.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // Variables
  // final _uid FirebaseAuth.instance.currentUser;?.uid;

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

  final setup= Get.put(SetupRepo());
  final userRepo = Get.put(UserRepo());
  final controller = Get.put(VerifyEmailController());

  // SIGNUP
  // void recreatedbalances() async {
  //   await setupRepo.savesetupData(balancesModel.empty());
  // }
  checkInternetConnection(BuildContext context) async {
    isLoading.value=true;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (context.mounted) {
          signup();
        }
      }
    } on SocketException catch (_) {
      if (context.mounted) {
        showErrorDialog(context: context, errorTitle: 'Connection error!', errorText: 'Please check your network connection and try again.');
      }
    }
  }  void signup() async {
    try {
      //Start loading
      isLoading.value = true;
      //Check connectivity
      // final isConnected = await NetworkManager.instance.isConnected();
      // if (!isConnected) {
        Get.snackbar("Oh snap! No internet connection.",
            "Please check your internet connection and try again",
            icon: Icon(
              Icons.cloud_off,
              color: Colors.white,
            ),
            backgroundColor: Color(0xffFF0033),
            colorText: Colors.white);
        // return;
      // }

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
      final userCredential = await AuthRepo.instance.registerWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );
      final uid = userCredential.user?.uid;

      // Save authenticated data to the firestore.
      final newUser = UserModel(
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        accountId: userCredential.user!.uid,
        userName: userName.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        accountIsSetup: false,
      );



      /// Save user data


      await userRepo.saveUserDate(newUser);

      ///Create empty setup data
      await setup.saveSetupData(BalancesModel.empty(),uid).then((value) => Get.snackbar(
        "Success!",
        'balances update complete',
        backgroundColor: Colors.purple,
        colorText: Colors.white,
      ));

      //Success message
      Get.snackbar('Congratulations', AppTexts.yourAccountCreatedTitle,
          backgroundColor: Colors.green, colorText: Colors.white);

      // Send email verification

      try {
        await controller.sendVerificationEmail();
        Get.to(VerifyEmail());
      } catch (e) {
        Get.snackbar("Oh snap!", e.toString(),
            backgroundColor: Color(0xffFF0033), colorText: Colors.white);
      }

      /// Notify user that verification email was sent
      Get.snackbar('Verification email sent', 'Please check your inbox and verify your email.',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Oh snap!", e.toString(),
          backgroundColor: Color(0xffFF0033), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
