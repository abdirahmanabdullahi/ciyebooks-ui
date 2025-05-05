import 'package:ciyebooks/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
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
        contentPadding: EdgeInsets.symmetric(horizontal: AppSizes.padding),
        insetPadding: EdgeInsets.all(AppSizes.padding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: AppColors.secondary),
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

        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: 45,
                  width: double.maxFinite,
                  child: TextFormField(
                    controller: controller.category,
                    decoration: InputDecoration(labelText: 'Category name'),
                  )),
              Gap(AppSizes.spaceBtwItems*4),
              SizedBox(height: 45,width: double.maxFinite,
                child:  FloatingActionButton(
                backgroundColor: AppColors.secondary,

                child: const Text(
                  'Add',
                  style: TextStyle(color: AppColors.quinary),
                ),
                onPressed: () {
                  controller.addNewExpenseCategory();
                },
              ),)
            ],
          ),
        ),

      );
    },
  );
}
