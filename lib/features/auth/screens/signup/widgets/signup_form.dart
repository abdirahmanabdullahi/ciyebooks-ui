import 'package:ciyebooks/features/auth/screens/signup/widgets/switch_screens.dart';
import 'package:ciyebooks/features/auth/screens/signup/widgets/terms_and_conditions.dart';
import 'package:ciyebooks/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

import '../../login/login.dart';
import '../../../controllers/signup_controller.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("Let's create your account",style: Theme.of(context).textTheme.headlineMedium,),
          Gap(20),Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) =>
                      Validator.validateEmptyText('first name', value),
                  expands: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    label: Text(AppTexts.firstName),
                  ),
                ),
              ),
              Gap(AppSizes.spaceBtwInputFields/2),
              Flexible(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) =>
                      Validator.validateEmptyText('last name', value),
                  expands: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    label: Text(AppTexts.lastName),
                  ),
                ),
              ),
            ],
          ),
          const Gap(AppSizes.spaceBtwInputFields/2),
          TextFormField(cursorHeight: 30,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),
            validator: (value) =>
                Validator.validateEmptyText('username', value),
            controller: controller.userName,
            expands: false,
            decoration: const InputDecoration(
              // prefixIcon: Icon(Iconsax.user_edit),
              label: Text(AppTexts.username),
            ),
          ),
          const Gap(AppSizes.spaceBtwInputFields/2),
          TextFormField(keyboardType: TextInputType.emailAddress,
            validator: (value) => Validator.validateEmail(value),
            controller: controller.email,
            expands: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.mail_outline),
              label: Text(AppTexts.email),
            ),
          ),
          const Gap(AppSizes.spaceBtwInputFields/2),
          TextFormField(
            validator: (value) => Validator.validatePhoneNumber(value),
            controller: controller.phoneNumber,
            expands: false,
            decoration: const InputDecoration(
              label: Text(AppTexts.phoneNo),
            ),
          ),
          const Gap(AppSizes.spaceBtwInputFields/2),
          Obx(
            () => TextFormField(
              obscureText: controller.hidePassword(),
              validator: (value) => Validator.validatePassword(value),
              controller: controller.password,
              expands: false,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value == true
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined)),
                label: Text(AppTexts.password),
              ),
            ),
          ),
          const Gap(AppSizes.spaceBtwInputFields/2),
          const TermsAndConditions(),
          const Gap(AppSizes.spaceBtwSections),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: Obx(
              () => FloatingActionButton(
                elevation: 0,
                isExtended: true,
                enableFeedback: true,
                backgroundColor: controller.isLoading.value
                    ? AppColors.prettyDark.withValues(alpha: .9)
                    : AppColors.prettyDark,
                onPressed: controller.isLoading.value
                    ? null // Disable button when loading
                    : () => controller.signup(),
                child: controller.isLoading.value == true
                    ? SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                    : Text(
                        AppTexts.createAccount,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .apply(color: AppColors.quinary),
                      ),
              ),
            ),
          ),
          const Gap(AppSizes.spaceBtwItems),
          SwitchScreens(
            title: AppTexts.goToLoginTitle,
            label: AppTexts.goToLoginLabel,
            onPressed: () => Get.offAll(() => Login()),
          ),

        ],
      ),
    );
  }
}
