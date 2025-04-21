import 'package:ciyebooks/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
          padding: EdgeInsets.only(left: 15),
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.systemBlue),
          width: double.maxFinite,
          // height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Adding new expense category',
                style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w500),
              ),
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: AppColors.quinary,
                  ))
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
              height: 45,
              width: double.maxFinite,
              child: TextFormField(
                controller: controller.category,
                decoration: InputDecoration(labelText: 'Category name'),
              )),
        ),
        actions: <Widget>[
          OutlinedButton(

            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(CupertinoColors.systemBlue), padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10))),
            child: const Text(
              'Add',
              style: TextStyle(color: AppColors.quinary),
            ),
            onPressed: () {
              controller.addNewExpenseCategory();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
