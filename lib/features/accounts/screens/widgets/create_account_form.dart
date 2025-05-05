import 'package:ciyebooks/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../controller/accounts_controller.dart';

Future<dynamic> showCreateAccountDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final controller = Get.put(AccountsController());
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(8),
        backgroundColor: AppColors.quarternary,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        title: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: AppColors.prettyBlue),
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
                        style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w400),
                      ),
                    ),
                    IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: AppColors.quinary,
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
              Gap(6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Form(
                  key: controller.accountsFormKey,
                  child: Column(
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
                              decoration: InputDecoration(hintText: 'First name'),
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
                              decoration: InputDecoration(hintText: 'Last name'),
                            ),
                          ),
                        ],
                      ),
                      Gap(AppSizes.spaceBtwItems),
                      TextFormField(keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number is required';
                          }
                          return null;
                        },
                        controller: controller.phoneNo,
                        decoration: InputDecoration(hintText: 'Phone number'),
                      ),
                      Gap(AppSizes.spaceBtwItems),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,

                        controller: controller.email,
                        decoration: InputDecoration(hintText: 'Email'),
                      ),
                      Gap(AppSizes.spaceBtwItems),
                      TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        ],
                        controller: controller.usd,
                        decoration: InputDecoration(hintText: 'USD balance'),
                      ),
                      Gap(AppSizes.spaceBtwItems),
                      TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        ],
                        controller: controller.kes,
                        decoration: InputDecoration(hintText: 'KES balance'),
                      ),
                      Gap(10),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 45,
                  width: double.maxFinite,
                  child: FloatingActionButton(
                      elevation: 0,
                      // style: ElevatedButton.styleFrom(
                      //   padding: EdgeInsets.symmetric(horizontal: 10),
                      //   disabledBackgroundColor: const Color(0xff35689fff),
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      // ),
                      onPressed: () => controller.createAccount(context),
                      // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                      child: Text(
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
  );
}
