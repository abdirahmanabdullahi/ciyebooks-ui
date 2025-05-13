import 'package:ciyebooks/features/auth/controllers/signin_controller.dart';
import 'package:ciyebooks/features/auth/screens/signup/signup.dart';
import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/validators/validation.dart';
import '../common/custom_header.dart';
import '../password_config/reset_password.dar/forgot_password.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    return Scaffold(
      backgroundColor: AppColors.quinary,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomHeader(
              height: 150,
              title: AppTexts.loginTitle,
              subtitle: AppTexts.goToSignupTitle,
              label: AppTexts.goToSignupLabel,
            ),
            Gap(AppSizes.spaceBtwSections / 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Form(
                key: controller.signInFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: controller.email,
                      validator: (value) => Validator.validateEmptyText('Email', value),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        label: const Text(AppTexts.email),
                      ),
                    ),
                    Gap(AppSizes.spaceBtwInputFields / 2),
                    Obx(
                      () => TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        obscureText: controller.hidePassword.value,
                        controller: controller.password,
                        validator: (value) => Validator.validateEmptyText('Password', value),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          label: const Text(AppTexts.password),
                          // suffix: IconButton(
                          //   icon: controller.hidePassword.value
                          //       ? Icon(
                          //     Icons.visibility,
                          //   )
                          //       : Icon(
                          //     Icons.visibility_off_outlined,
                          //   ),
                          //   onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                          // ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                            onPressed: () => Navigator.push(
                                  context,
                                  CupertinoPageRoute(builder: (context) => const ForgotPassword()),
                                ),
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: CupertinoColors.systemBlue),
                            )),
                      ),
                    ),
                    // TextButton(onPressed: () => Get.offAll(() => Signup()), child: Text('data')),
                    // const Gap(AppSizes.spaceBtwSections / 2),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: Obx(
                        () => FloatingActionButton(
                          heroTag: 'Sign in',
                          elevation: 0,
                          isExtended: true,
                          enableFeedback: true,
                          backgroundColor: AppColors.prettyBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          onPressed: controller.isLoading.value
                              ? null // Disable button when loading
                              : () => controller.signIn(),
                          child: controller.isLoading.value == true
                              ? SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ))
                              : Text(
                                  AppTexts.signIn,
                                  style: Theme.of(context).textTheme.titleMedium!.apply(color: AppColors.quinary),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
