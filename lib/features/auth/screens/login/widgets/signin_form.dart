import 'package:ciyebooks/utils/validators/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/signin_controller.dart';
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
            keyboardType: TextInputType.emailAddress,
            controller: controller.email,
            validator: (value) => Validator.validateEmptyText('Email', value),
            decoration: InputDecoration(
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
                  label: const Text(AppTexts.password),
                  suffixIcon: IconButton(
                    icon: controller.hidePassword.value
                        ? Icon(
                            Icons.visibility,
                          )
                        : Icon(
                            Icons.visibility_off_outlined,
                          ),
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                  )),
            ),
          ),

          const Gap(AppSizes.spaceBtwSections / 2),
          SizedBox(
            height: 45,
            width: double.infinity,
            child: Obx(
              () => FloatingActionButton(
                elevation: 0,
                isExtended: true,
                enableFeedback: true,
                backgroundColor: AppColors.secondary,
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
          const Gap(AppSizes.spaceBtwItems),
          SwitchScreens(title: AppTexts.goToSignupTitle, label: AppTexts.goToSignupLabel, onPressed: () => Get.to(() => const Signup()))
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
