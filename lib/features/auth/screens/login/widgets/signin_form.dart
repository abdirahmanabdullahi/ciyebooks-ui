import 'package:ciyebooks/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../navigation_menu.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/signin_controller.dart';
import '../../password_config/reset_password.dar/forgot_password.dart';
import '../../signup/signup.dart';
import '../../signup/widgets/switch_screens.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    return Form(
      key: controller.signInFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: controller.email,
            validator: (value) => Validator.validateEmail(value),
            decoration: const InputDecoration(
              suffix: Icon(
                Icons.mail_outline,
                color: Colors.grey,
              ),
              label: Text(AppTexts.email),
            ),
          ),
          Gap(AppSizes.spaceBtwInputFields),
          Obx(
            () => TextFormField(
              obscureText: controller.hidePassword.value,
              controller: controller.password,
              validator: (value) =>
                  Validator.validateEmptyText('Password', value),
              decoration: InputDecoration(
                  label: const Text(AppTexts.password),
                  suffixIcon: IconButton(
                    icon: controller.hidePassword.value
                        ? Icon(
                            Icons.visibility,
                          )
                        : Icon(
                            Icons.visibility_off_outlined,
                          ),
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                  )),
            ),
          ),
          const Gap(AppSizes.spaceBtwItems / 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                      width: 20,
                      height: 20,
                      child: Obx(() => Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: (value) => controller.rememberMe.value =
                              !controller.rememberMe.value))),
                  Gap(6),
                  const Text(AppTexts.rememberMe),
                ],
              ),
              TextButton(
                onPressed: () => Get.to(() => const ForgotPassword()),
                child: Text(
                  AppTexts.forgetPassword,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
          const Gap(AppSizes.spaceBtwSections / 2),
          SizedBox(
            height: 50,
            width: double.infinity,
            child:  Obx(
              () => FloatingActionButton(
      elevation: 0,
      isExtended: true,
      enableFeedback: true,
      backgroundColor: controller.isLoading.value
          ? AppColors.prettyDark.withValues(alpha: .9)
          : AppColors.prettyDark,
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
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .apply(color: AppColors.quinary),
      ),
    ),
    ),
          ),
          const Gap(AppSizes.spaceBtwItems),
          SwitchScreens(
              title: AppTexts.goToSignupTitle,
              label: AppTexts.goToSignupLabel,
              onPressed: () => Get.to(() => const Signup()))
          // SizedBox(
          //   width: double.infinity,
          //   child: OutlinedButton(
          //     onPressed: () => Get.to(() => const Signup()),
          //     child: const Text(
          //       AppTexts.createAccount,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
