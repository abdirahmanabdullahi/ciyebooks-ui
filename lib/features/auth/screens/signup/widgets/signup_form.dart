import 'package:ciyebooks/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

import '../controllers/signup_controller.dart';

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

SizedBox(width: double.maxFinite,
    child: FloatingActionButton(onPressed:controller.isLoading.value?null: ()=>controller.signup(), child: Text('Submit',style: TextStyle(),))),
        ],
      ),
    );
  }
}
