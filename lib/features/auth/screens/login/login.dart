import 'package:ciyebooks/features/auth/screens/login/widgets/signin_form.dart';
import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../common/custom_header.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.quinary,
      body: SizedBox(
          width: double.infinity,
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(
                height: 130,
                title: AppTexts.loginTitle,
                subtitle: AppTexts.goToSignupTitle,
                label: AppTexts.goToSignupLabel,
              ),
              Gap(AppSizes.spaceBtwSections / 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SignInForm(),
              ),
            ],
          ),
        ),
    );
  }
}
