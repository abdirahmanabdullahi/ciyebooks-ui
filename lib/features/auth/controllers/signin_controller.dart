import 'package:ciyebooks/data/repositories/auth/auth_repo.dart';
import 'package:ciyebooks/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SignInController extends GetxController {
  static SignInController get instance => Get.find();

  //Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final isLoading = false.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  // @override
  // void onInit() {
  //   email.text = localStorage.read('REMEMBER_ME_EMAIL');
  //   password.text = localStorage.read('REMEMBER_ME_PASSWORD');
  //   super.onInit();
  //
  //
  // }

  /// Autofill email and password

  Future<void> signIn() async {
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
      if (!signInFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }
      // if (_formKey.currentState!.validate()) {

      /// Save data if remember me is checked
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      /// Login user with email and password.
      await AuthRepo.instance
          .login(email.text.trim(), password.text.trim()).then((_) {

        /// Stop loading
        isLoading.value = false;

        /// Redirect
        AuthRepo.instance.screenRedirect();

        Get.snackbar(
          "Successfully logged in",
          "Welcome back",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: Icon(
            Icons.verified_user,
            color: Colors.white,
          ),
        );
      });

    } catch (e) {
      isLoading.value = false;
      Get.snackbar("There was an error during sign in!", e.toString(),
          icon: Icon(
            size: 40,
            Icons.error,
            color: Colors.white,
          ),
          backgroundColor: Color(0xffFF0033),
          colorText: Colors.white);
    }
  }
}
