
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ciyebooks/utils/constants/sizes.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../controllers/pay_client_controller.dart';

showPaymentSuccessPopup(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final NumberFormat formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_us',
        decimalDigits: 2,
      );
      final controller = Get.put(PayClientController());

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
                        Text("Payment success", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: AppColors.secondary)),
                        Gap(6),
                        Text("${controller.paidCurrency.text.trim()}  ${formatter.format(double.parse(controller.amount.text.trim()))}",
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
                          "Payment Details",
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
                            Text('PAY-${controller.counters['paymentsCounter'].toString()}',
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                          ],
                        ),
                        Divider(color: Colors.black, thickness: .11),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Payee",
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                            Text(controller.from.text.trim(),
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                          ],
                        ),
                        Divider(color: Colors.black, thickness: .11),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Paying account no",
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                            Text(controller.accountNo.text.trim(),
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                          ],
                        ),
                        Divider(color: Colors.black, thickness: .11),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Receiver",
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                            Obx(
                              () => controller.paidToOwner.value
                                  ? Text(controller.from.text.trim(),
                                      style: TextStyle(
                                        fontSize: 13,
                                      ))
                                  : Text(controller.receiver.text.trim(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      )),
                            ),
                          ],
                        ),
                        Divider(color: Colors.black, thickness: .11),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Payment type",
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                            Text(controller.paymentType.text.trim(),
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
                            Text(controller.description.text.trim(),
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
                            Text(DateFormat('dd MMM yyy HH:mm').format(DateTime.now()),
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
                            Text('${controller.paidCurrency.text.trim()} ${formatter.format(double.parse(controller.amount.text.trim()))}',
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
                        backgroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          Navigator.of(context).pop();
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
