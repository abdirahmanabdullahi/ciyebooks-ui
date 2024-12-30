import 'package:ciyebooks/features/auth/screens/login/widgets/signin_form.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../common/custom_divider.dart';
import '../common/custom_header.dart';
import '../common/social_icons.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.defaultSpace / 4, 20, AppSizes.defaultSpace / 4, 0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomHeader(
                    height: 100,
                    title: AppTexts.loginTitle,
                    subtitle: AppTexts.goToSignupTitle,
                    label: AppTexts.goToSignupLabel,
                  ),
                  Gap(AppSizes.spaceBtwSections/2),
                  SignInForm(),
                  Gap(AppSizes.spaceBtwSections),
                  const CustomDivider(
                    label: AppTexts.orSignInWith,
                  ),
                  Gap(AppSizes.spaceBtwItems),
                  const SocialIcons()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
