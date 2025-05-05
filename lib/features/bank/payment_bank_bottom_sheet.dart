import 'package:ciyebooks/features/bank/withdraw/screens/widgets/withdraw_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../dashboard/widgets/bottom_sheet_button.dart';
import 'deposit/screens/widgets/deposit_form.dart';

showAndroidBankBottomSheet({required BuildContext context}) {
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
                  "Bank",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Gap(20),
                Divider(
                  height: 0,
                ),
                BottomSheetButton(
                  heroTag: "Deposit cash at bank",
                  label: "Deposit cash at bank",
                  icon: Icons.arrow_downward,
                  onPressed: () {
                    Get.back();
                    showDepositForm(context);
                  },
                ),
                Divider(
                  height: 0,
                ),
                BottomSheetButton(
                  heroTag: "Withdraw cash from bank",
                  label: "Withdraw cash from bank",
                  icon: Icons.list_alt,
                  onPressed: () {
                    Get.back();
                    showWithdrawForm(context);
                  },
                ),
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

void showIosBankActionSheet(BuildContext context) {
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
      title: const Text('Bank transaction'),
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          /// This parameter indicates the action would be a default
          /// default behavior, turns the action's text to bold text.
          onPressed: () {
            Navigator.pop(context);
            showDepositForm(context);          },
          child: const Text(
            'Deposit cash at bank',
            style: TextStyle(color: CupertinoColors.systemBlue),
          ),
        ),
        CupertinoActionSheetAction(
          /// This parameter indicates the action would be a default
          /// default behavior, turns the action's text to bold text.
          onPressed: () {
            Navigator.pop(context);
            showWithdrawForm(context);
          },
          child: const Text(
            'Withdraw cash from bank',
            style: TextStyle(color: CupertinoColors.systemBlue),
          ),
        ),

      ],
    ),
  );
}
