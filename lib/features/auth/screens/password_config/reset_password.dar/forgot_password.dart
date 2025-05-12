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
      appBar: AppBar(title:  Text(
        AppTexts.forgetPasswordTitle,
        style: TextStyle(color: AppColors.quinary,fontSize: 22,fontWeight: FontWeight.w600),
      ),
        leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_rounded,color: AppColors.quinary,)),
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.prettyBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 6, vertical: AppSizes.defaultSpace),
        child: Form(key: controller.forgotPasswordFormKey2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Gap(AppSizes.spaceBtwItems),
              Text(
                AppTexts.forgetPasswordSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const Gap(AppSizes.spaceBtwSections * 2),
              TextFormField(
                validator: (value) =>
                    Validator.validateEmptyText("Email", value),
                controller: controller.email,
                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    labelText: AppTexts.email),
              ),
              const Gap(AppSizes.defaultSpace/2),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: Obx(
                  () => FloatingActionButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: AppColors.prettyBlue,
                    elevation: 2,
                    onPressed: () => controller.checkInternetConnection(context),
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
      ),
    );
  }
}
