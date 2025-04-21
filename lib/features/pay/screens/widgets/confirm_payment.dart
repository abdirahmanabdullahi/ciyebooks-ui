import 'package:ciyebooks/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/colors.dart';
import '../../controllers/pay_client_controller.dart';


showConfirmPayment(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final NumberFormat formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_us',
        decimalDigits: 2,
      );
      final controller = Get.put(PayClientController());
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(AppSizes.padding),
        backgroundColor: AppColors.quinary,
        contentPadding: EdgeInsets.symmetric(vertical: AppSizes.padding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.systemBlue),
          width: double.maxFinite,
          // height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Confirm payment',
                  style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w500),
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
                    'Payment',
                  ),
                ],
              ),
            ),
            // Gap(5),
            Divider(thickness: 0.11,
              color: AppColors.prettyDark,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text("Payee", style: TextStyle()),
                  ),
                  Text(
                    controller.from.text.trim(),
                  ),
                ],
              ),
            ),
            Divider(thickness: 0.11,
              color: AppColors.prettyDark,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Receiver',
                  ),
                  Obx(
                        () => controller.paidToOwner.value
                        ? Text(
                      "Account holder",
                    )
                        : Text(
                      controller.receiver.text,
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 0.11,
              color: AppColors.prettyDark,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Paid currency", style: TextStyle()),
                  Text(
                    controller.paidCurrency.text.trim(),
                  ),
                ],
              ),
            ),
            Divider(thickness: 0.11,
              color: AppColors.prettyDark,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text("Amount", style: TextStyle()),
                  ),
                  Text(
                    formatter.format(double.parse(controller.amount.text.replaceAll(',', ''))),
                  ),
                ],
              ),
            ),
            Divider(thickness: 0.11,
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
            Divider(thickness: 0.11,
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
            Divider(thickness: 0.11,
              color: AppColors.prettyDark,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: SizedBox(
                height: 45,
                width: double.maxFinite,
                child: FloatingActionButton(
                    elevation: 0,
                    // style: ElevatedButton.styleFrom(
                    //   padding: EdgeInsets.symmetric(horizontal: 10),
                    //   disabledBackgroundColor: const Color(0xff35389fff),
                    backgroundColor: CupertinoColors.systemBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    // ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      controller.createPayment(context);
                    },

                    // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
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
