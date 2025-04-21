import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/pay_expense_controller.dart';

showConfirmExpenseDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final controller = Get.put(PayExpenseController());
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(AppSizes.padding),
        backgroundColor: AppColors.quinary,
        contentPadding: EdgeInsets.symmetric(vertical: AppSizes.padding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Container(
          padding: EdgeInsets.only(left: 15),
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.systemBlue),
          width: double.maxFinite,
          // height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Confirm expense',
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text("Transaction type", style: TextStyle()),
                  ),
                  Text(
                    'Expense',
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 0.11,
              color: AppColors.prettyDark,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text("Category", style: TextStyle()),
                  ),
                  Text(
                    controller.category.text.trim(),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 0.11,
              color: AppColors.prettyDark,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Currency',
                  ),
                  Text(
                    controller.paidCurrency.text.trim(),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 0.11,
              color: AppColors.prettyDark,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Amount paid", style: TextStyle()),
                  Text(
                    controller.amount.text.trim(),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 0.11,
              color: AppColors.prettyDark,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text("Description", style: TextStyle()),
                  ),
                  Text(
                    controller.description.text.trim(),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 0.11,
              color: AppColors.prettyDark,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text("Date & Time", style: TextStyle(fontWeight: FontWeight.normal)),
                  ),
                  Text(
                    DateFormat('dd MMM yyyy   HH:mm').format(DateTime.now()),
                  ),
                ],
              ),
            ),
            Gap(10),
            Divider(
              height: 0,
            ),
            Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.padding),
              child: SizedBox(
                height: 45,
                width: double.maxFinite,
                child: FloatingActionButton(
                    elevation: 0,
                    backgroundColor: CupertinoColors.systemBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    // ),
                    onPressed: () {
                      Navigator.of(context).pop();

                      controller.createExpense(context);
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: AppColors.quinary, fontSize: 15),
                    )),
              ),
            ),
          ],
        ),
      );
    },
  );
}
