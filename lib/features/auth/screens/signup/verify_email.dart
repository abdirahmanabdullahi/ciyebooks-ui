import 'package:ciyebooks/data/repositories/auth/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'controllers/verify_email_controller.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.quarternary,
        automaticallyImplyLeading: true,leading: IconButton(onPressed: (){FirebaseAuth.instance.signOut();
          AuthRepo.instance.screenRedirect();}, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.sm),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(
                  width: double.infinity,
                ),
                const Image(image: AssetImage(AppImages.deliveredEmailIllustration)),
                const Gap(AppSizes.spaceBtwSections),
                Text(
                  AppTexts.confirmEmail,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Gap(AppSizes.spaceBtwItems),
                Text(
                  'info@ciyebooks.com',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const Gap(AppSizes.spaceBtwItems),
                Text(
                  AppTexts.confirmEmailSubTitle,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                const Gap(AppSizes.spaceBtwSections),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: FloatingActionButton(
                    elevation: 2,
                    backgroundColor: AppColors.prettyDark,
                    child: Text(
                      AppTexts.tContinue,
                      style: Theme.of(context).textTheme.titleLarge!.apply(color: AppColors.quinary),
                    ),
                    onPressed: () => controller.checkEmailVerificationStatus(),
                  ),
                ),
                const Gap(AppSizes.spaceBtwItems),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    child: Text(
                      AppTexts.resendEmail,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    onPressed: () => controller.sendVerificationEmail(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
