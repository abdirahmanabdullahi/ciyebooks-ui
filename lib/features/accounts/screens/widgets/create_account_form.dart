import 'package:ciyebooks/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../controller/accounts_controller.dart';

Future<dynamic> showCreateAccountDialog(BuildContext context) {
  final controller = Get.put(AccountsController());
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(16),
        backgroundColor: AppColors.quarternary,
        contentPadding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        title: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: AppColors.quinary),
          width: double.maxFinite,
          // height: 30,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Create a account',
                        style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w400),
                      ),
                    ),
                    IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: AppColors.prettyDark,
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'First name is required';
                            }
                            return null;
                          },
                          controller: controller.firstName,
                          decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16), hintText: 'First name'),
                        ),
                      ),
                      Gap(AppSizes.spaceBtwItems),
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Last name is required';
                            }
                            return null;
                          },
                          controller: controller.lastName,
                          decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16), hintText: 'Last name'),
                        ),
                      ),
                    ],
                  ),
                  Gap(AppSizes.spaceBtwItems),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                    controller: controller.phoneNo,
                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16), hintText: 'Phone number'),
                  ),
                  Gap(AppSizes.spaceBtwItems),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: controller.email,
                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16), hintText: 'Email'),
                  ),
                  Gap(20),
                ],
              ),
              SizedBox(
                height: 45,
                width: double.maxFinite,
                child: Obx(
                  () => FloatingActionButton(
                      disabledElevation: 0,
                      // style: ElevatedButton.styleFrom(
                      //   padding: EdgeInsets.symmetric(horizontal: 10),
                      //   disabledBackgroundColor: const Color(0xff35689fff),
                      backgroundColor: controller.isButtonEnabled.value ? AppColors.prettyBlue : AppColors.prettyGrey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      // ),
                      onPressed: controller.isButtonEnabled.value && !controller.isLoading.value ? () => controller.createAccount(context) : null,
                      // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                      child: controller.isLoading.value
                          ? SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                color: AppColors.quinary,
                              ))
                          : Text(
                              'Create account',
                              style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w600),
                            )),
                ),
              ),
            ],
          ),
        ),
      );
    },
  ).then((_){controller.clearControllers();});
}
