import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../navigation_menu.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../password_config/reset_password.dar/forgot_password.dart';
import '../../signup/signup.dart';
import '../../signup/widgets/switch_screens.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              suffix: Icon(
                Icons.mail_outline,
                color: Colors.grey,
              ),
              label: Text(AppTexts.email),
            ),
          ),
           Gap(AppSizes.spaceBtwInputFields),
          TextFormField(
            decoration: const InputDecoration(
                label: Text(AppTexts.password),
                suffixIcon: Icon(
                  Icons.visibility_off_outlined,
                )),
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
                      child: Checkbox(value: true, onChanged: (value) {})),Gap(6),
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
            child: FloatingActionButton(
              backgroundColor: AppColors.prettyDark,
              elevation: 2,
              onPressed: () => Get.offAll(() => const NavigationMenu()),
              child: Text(
                AppTexts.signIn,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .apply(color: AppColors.quinary),
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
