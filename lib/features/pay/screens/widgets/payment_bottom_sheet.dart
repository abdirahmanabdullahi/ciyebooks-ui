import 'package:ciyebooks/features/pay/screens/expense/add_expense_category_form.dart';
import 'package:ciyebooks/features/pay/screens/payments/payment_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../dashboard/widgets/bottom_sheet_button.dart';
import '../expense/expense_form.dart';

showAndroidPaymentBottomSheet({required BuildContext context}) {
  return showModalBottomSheet<dynamic>(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24), // You can adjust the radius
      ),
    ),
    isScrollControlled: true,
    context: context,
    builder: (BuildContext bc) {
      return Wrap(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Make a payment",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Gap(20),
                Divider(
                  height: 0,
                ),
                BottomSheetButton(
                  heroTag: "Pay a client",
                  label: "Pay a client",
                  icon: Icons.north_east,
                  onPressed: () {
                    Get.back();

                    showPaymentForm(context);
                  },
                ),
                Divider(
                  height: 0,
                ),
                BottomSheetButton(
                    heroTag: "Pay an expense",
                    label: "Pay an expense",
                    icon: Icons.shopping_bag,
                    onPressed: () {
                      Get.back();
                      showExpenseForm(context);
                    }),

                Divider(
                  height: 0,
                ),
                Gap(60),
              ],
            ),
          ),
        ],
      );
    },
  );
}

void showIosPaymentActionSheet(BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoActionSheet(
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,

        /// This parameter indicates the action would be a default
        /// default behavior, turns the action's text to bold text.
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Close'),
      ),
      title: const Text('Make a payment'),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          /// This parameter indicates the action would be a default
          /// default behavior, turns the action's text to bold text.
          onPressed: () {
            Navigator.pop(context);
            showPaymentForm(context);
          },
          child: const Text(
            'Pay a client',
            style: TextStyle(color: CupertinoColors.systemBlue),
          ),
        ),
        CupertinoActionSheetAction(
          /// This parameter indicates the action would be a default
          /// default behavior, turns the action's text to bold text.
          onPressed: () {
            Navigator.pop(context);
            showExpenseForm(context);
          },
          child: const Text(
            'Pay an expense',
            style: TextStyle(color: CupertinoColors.systemBlue),
          ),
        ),

      ],
    ),
  );
}
