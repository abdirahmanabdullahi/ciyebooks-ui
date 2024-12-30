
import 'package:ciyebooks/features/auth/screens/password_config/reset_password.dar/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 6, vertical: AppSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppTexts.forgetPasswordTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Gap(AppSizes.spaceBtwItems),
            Text(
              AppTexts.forgetPasswordSubTitle,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const Gap(AppSizes.spaceBtwSections * 2),
            TextFormField(
              decoration: const InputDecoration(labelText: AppTexts.email),
            ),
            const Gap(AppSizes.defaultSpace),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: FloatingActionButton(
                backgroundColor: AppColors.prettyDark,
                elevation: 2,
                onPressed: () => Get.offAll(() => const ResetPassword()),
                child: Text(
                  AppTexts.submit,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .apply(color: AppColors.quinary),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
