import 'package:ciyebooks/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../controllers/pay_expense_controller.dart';

showAddExpenseCategoryDialog(context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      final controller = Get.put(PayExpenseController());
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        backgroundColor: AppColors.quarternary,
        contentPadding: EdgeInsets.all(16),
        insetPadding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                        'Adding new expense category',
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
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 45,
                  width: double.maxFinite,
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'^\d*\.?\d*$')),
                    ],
                    onChanged: (value) => controller.updateNewCategoryButton(),
                    controller: controller.category,
                    decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 8), labelText: 'Category name'),
                  )),
              Gap(AppSizes.spaceBtwItems * 2.5),
              SizedBox(
                height: 45,
                width: double.maxFinite,
                child: Obx(
                  () => FloatingActionButton(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: controller.newCategoryButtonEnabled.value ? AppColors.prettyBlue : AppColors.prettyGrey,
                    onPressed: controller.newCategoryButtonEnabled.value
                        ? () {
                            controller.addNewExpenseCategory(context,);
                          }
                        : null,
                    child: const Text(
                      'Add',
                      style: TextStyle(color: AppColors.quinary),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
