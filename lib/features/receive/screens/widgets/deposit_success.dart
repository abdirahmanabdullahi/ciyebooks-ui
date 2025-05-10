import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ciyebooks/utils/constants/sizes.dart';
import 'package:gap/gap.dart';

import '../../../../utils/constants/colors.dart';

showClientDepositInfo({
  required BuildContext context,
  required String currency,
  required String transactionCode,
  required String amount,
  required Widget depositor,
  required String depositType,
  required String receivingAccountName,
  required String receivingAccountNo,
  required String description,
  required DateTime date,


}) {
  return showDialog(
    context: context,
    builder: (context) {
      final NumberFormat formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_us',
        decimalDigits: 2,
      );

      return PopScope(
        canPop: false,
        child: AlertDialog(
          insetPadding: EdgeInsets.all(AppSizes.padding),
          backgroundColor: AppColors.quinary,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 24, 20, 0),
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Gap(6),
                        Icon(Icons.task_alt, color: Colors.green[700], size: 68),
                        const SizedBox(height: 15),
                        Text("Client deposit success", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: AppColors.secondary)),
                        Gap(6),
                        Text("$currency  ${formatter.format(double.parse(amount))}",
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25, color: AppColors.secondary)),
                        Gap(6),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Payment Details box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(10),
                        Text(
                          "Deposit Details",
                          style: TextStyle(letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.secondary
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Transaction code",
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                            Text(transactionCode,
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                          ],
                        ),
                        Divider(color: Colors.black, thickness: .11),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Depositor",
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                           depositor
                          ],
                        ),

                        Divider(color: Colors.black, thickness: .11),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Receiving account name",
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                            Text(receivingAccountName,
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                          ],
                        ),
                        Divider(color: Colors.black, thickness: .11),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Receiving acc no",
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                            Text(receivingAccountNo,
                                style: TextStyle(
                                  fontSize: 13,
                                ))
                          ],
                        ),
                        Divider(color: Colors.black, thickness: .11),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Deposit type",
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                            Text(depositType,
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                          ],
                        ),
                        Divider(color: Colors.black, thickness: .11),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Description",
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                            Text(description,
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                          ],
                        ),
                        Divider(color: Colors.black, thickness: .11),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Date & time",
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                            Text(DateFormat('dd MMM yyy HH:mm').format(date),
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                          ],
                        ),
                        Divider(color: Colors.black, thickness: .11),
                        Gap(13),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Payment", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.secondary)),
                            Text('$currency  ${formatter.format(double.parse(amount))}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Gap(10)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 30, 24, 24),
                  child: SizedBox(
                    // height: 45,
                    width: double.maxFinite,
                    child: FloatingActionButton(
                        backgroundColor: AppColors.prettyBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },

                        // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                        child: Text(
                          'Done',
                          style: TextStyle(color: AppColors.quinary, fontSize: 14, fontWeight: FontWeight.w700),
                        )),
                  ),
                ),
                Gap(3)
              ],
            ),
          ),
        ),
      );
    },
  );
}
