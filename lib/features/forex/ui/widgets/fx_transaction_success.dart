import 'package:ciyebooks/features/forex/controller/forex_controller.dart';
import 'package:ciyebooks/features/pay/screens/widgets/payment_success_screen.dart';
import 'package:ciyebooks/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/colors.dart';

showForexSuccess(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final NumberFormat formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_us',
        decimalDigits: 2,
      );
      final controller = Get.put(ForexController());
      return PopScope(
        canPop: false,
        child: AlertDialog(
          insetPadding: EdgeInsets.all(AppSizes.padding),
          backgroundColor: AppColors.quinary,
          contentPadding: EdgeInsets.all(
            16,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(6),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(16),
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
                    children: [
                      Gap(6),
                      Icon(Icons.task_alt, color: Colors.green[700], size: 68),
                      const SizedBox(height: 15),
                      Obx(()=>Text("${controller.selectedTransaction} success!", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: AppColors.secondary))),
                      Gap(6),
                      Text("${controller.currencyCode.text.trim()}  ${formatter.format(double.parse(controller.amount.text.trim()))}",
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25, color: AppColors.secondary)),
                      Gap(6),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Payment Details box
                Container(
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
                        "Transaction details",
                        style: TextStyle(letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.secondary
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24),
                      // Divider(color: Colors.black, thickness: .11),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Transaction code",
                              style: TextStyle(
                                fontSize: 13,
                              )),  Obx(
                    ()=> Text('${controller.selectedTransaction}-${controller.counters[controller.selectedTransaction]}',
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                              ),
                        ],
                      ), Divider(color: Colors.black, thickness: .11),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Forex type",
                              style: TextStyle(
                                fontSize: 13,
                              )),
                          Obx(
                                ()=> Text(controller.selectedTransaction.value,
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                          ),
                        ],
                      ), Divider(color: Colors.black, thickness: .11),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Method",
                              style: TextStyle(
                                fontSize: 13,
                              )),
                          Text(controller.type.text.trim(),
                              style: TextStyle(
                                fontSize: 13,
                              )),
                        ],
                      ),


                      Divider(color: Colors.black, thickness: .11),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Amount",
                              style: TextStyle(
                                fontSize: 13,
                              )),
                          Text(formatter.format(double.parse(controller.amount.text.trim())),
                              style: TextStyle(
                                fontSize: 13,
                              )),
                        ],
                      ),
                      Divider(color: Colors.black, thickness: .11),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Rate",
                              style: TextStyle(
                                fontSize: 13,
                              )),
                          Text(formatter.format(double.parse(controller.rate.text.trim())),
                              style: TextStyle(
                                fontSize: 13,
                              )),
                        ],
                      ), Divider(color: Colors.black, thickness: .11),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total",
                              style: TextStyle(
                                fontSize: 13,
                              )),
                          Text(formatter.format(double.parse(controller.total.text.trim().replaceAll(',', ''))),
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
                      Divider(color: Colors.black, thickness: .11), Gap(13),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.secondary)),
                          Text('KES ${formatter.format(double.parse(controller.total.text.trim().replaceAll(',', '')))}',
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
                Gap(10),
                SizedBox(
                  // height: 45,
                  width: double.maxFinite,
                  child: FloatingActionButton(
                    // elevation: 0,
                    // style: ElevatedButton.styleFrom(
                    //   padding: EdgeInsets.symmetric(horizontal: 10),
                    //   disabledBackgroundColor: const Color(0xff35389fff),
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      // ),
                      onPressed: () {

                          Navigator.of(context).pop();


                      },

                      // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                      child: Text(
                        'Done',
                        style: TextStyle(color: AppColors.quinary, fontSize: 14, fontWeight: FontWeight.w700),
                      )),
                ),

                Gap(6)
              ],
            ),
          ),
        ),
      );
    },
  );
}
