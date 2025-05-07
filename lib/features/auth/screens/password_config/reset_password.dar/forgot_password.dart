import 'package:ciyebooks/features/auth/controllers/forgot_passwor_controller.dart';
import 'package:ciyebooks/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../navigation_menu.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    return Scaffold(
      appBar: AppBar( leading: IconButton(
          onPressed: () => Get.off(NavigationMenu()),
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.prettyDark,
          )),
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
            Form(
              key: controller.forgotPasswordFormKey,
              child: TextFormField(
                validator: (value) =>
                    Validator.validateEmptyText("Email", value),
                controller: controller.email,
                decoration: const InputDecoration(labelText: AppTexts.email),
              ),
            ),
            const Gap(AppSizes.defaultSpace),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: Obx(
                () => FloatingActionButton(
                  backgroundColor: AppColors.prettyDark,
                  elevation: 2,
                  onPressed: () => controller.sendPasswordResetLink(),
                  child: controller.isLoading.value
                      ? SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                      : Text(
                          AppTexts.submit,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .apply(color: AppColors.quinary),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
