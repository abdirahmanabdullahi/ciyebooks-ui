
import 'package:ciyebooks/features/auth/screens/signup/widgets/switch_screens.dart';
import 'package:ciyebooks/features/auth/screens/signup/widgets/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../common/custom_divider.dart';
import '../../common/social_icons.dart';

import '../../login/login.dart';
import '../../../controllers/signup_controller.dart';
import '../verify_email.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: TextFormField(controller: controller.firstName,
                  expands: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    label: Text(AppTexts.firstName),
                  ),
                ),
              ),
               Gap(AppSizes.spaceBtwInputFields),
              Flexible(
                child: TextFormField(controller: controller.lastName,
                  expands: false,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person_outline),
                    label: Text(AppTexts.lastName),
                  ),
                ),
              ),
            ],
          ),
          const Gap(AppSizes.spaceBtwInputFields),
          TextFormField(controller: controller.userName,
            expands: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.user_edit),
              label: Text(AppTexts.username),
            ),
          ),
          const Gap(AppSizes.spaceBtwInputFields),
          TextFormField(controller: controller.email,
            expands: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.mail_outline),
              label: Text(AppTexts.email),
            ),
          ),
          const Gap(AppSizes.spaceBtwInputFields),
          TextFormField(controller: controller.phoneNumber,
            expands: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.call),
              label: Text(AppTexts.phoneNo),
            ),
          ),
          const Gap(AppSizes.spaceBtwInputFields),
          TextFormField(controller: controller.password,
            expands: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: Icon(Iconsax.eye_slash),
              label: Text(AppTexts.password),
            ),
          ),
          const Gap(AppSizes.spaceBtwInputFields),
          const TermsAndConditions(),
          const Gap(AppSizes.spaceBtwSections),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: FloatingActionButton(
              backgroundColor: AppColors.prettyDark,
              onPressed: () => Get.to(() => const VerifyEmail()),
              child: Text(
                AppTexts.createAccount,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .apply(color: AppColors.quinary),
              ),
            ),
          ),
          const Gap(AppSizes.spaceBtwItems),
          SwitchScreens(
            title: AppTexts.goToLoginTitle,
            label: AppTexts.goToLoginLabel,
            onPressed: () => Get.offAll(()=>Login()),
          ),
          const Gap(AppSizes.appBarHeight),
          const CustomDivider(label: AppTexts.orSignUpWith),
          const Gap(AppSizes.spaceBtwItems),
          const SocialIcons()
        ],
      ),
    );
  }
}
