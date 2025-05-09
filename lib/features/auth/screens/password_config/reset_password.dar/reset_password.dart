import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../navigation_menu.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/forgot_passwor_controller.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.quarternary, leading: IconButton(
          onPressed: () => Get.back(),

          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.prettyDark,
          )),
        actions: [
          IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(CupertinoIcons.clear))
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:AppSizes.defaultSpace,horizontal: 6),
          child: Column(children: [
            const Image(
                image: AssetImage(AppImages.deliveredEmailIllustration)),
            const Gap(AppSizes.spaceBtwSections),
            Text(
              AppTexts.changeYourPasswordTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Gap(AppSizes.spaceBtwItems),
            Text(
              AppTexts.changeYourPasswordSubTitle,
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
            const Gap(AppSizes.spaceBtwItems),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: FloatingActionButton(
                backgroundColor: AppColors.prettyDark,
                elevation: 2,onPressed: (){},
                // onPressed: () => AuthRepo.instance.screenRedirect(),
                child: Text(
                  AppTexts.done,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .apply(color: AppColors.quinary),
                ),
              ),
            ),
            const Gap(AppSizes.spaceBtwItems),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                child: const Text(AppTexts.resendEmail),
                onPressed: () => ForgotPasswordController.instance.resendPasswordResetLink(),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
