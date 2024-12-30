import 'package:ciyebooks/features/auth/screens/signup/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../utils/constants/sizes.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSizes.defaultSpace / 4,
              AppSizes.appBarHeight + 20, AppSizes.defaultSpace / 4, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const CustomHeader(
              //   title: AppTexts.signupTitle,
              //   height: 70,
              //   subtitle: AppTexts.goToLoginTitle,
              //   label: AppTexts.goToLoginLabel,
              // ),
              Gap(AppSizes.spaceBtwSections),
              SignupForm()
            ],
          ),
        ),
      ),
    );
  }
}
