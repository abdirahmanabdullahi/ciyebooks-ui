import 'package:ciyebooks/features/forex/controller/forex_controller.dart';
import 'package:ciyebooks/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/colors.dart';

showConfirmForexTransaction(BuildContext context) {
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
                        color: Colors.black.withValues(alpha:0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Gap(6),
                      Icon(Icons.info_outline_rounded, color: Colors.orange[700], size: 68),
                      const SizedBox(height: 15),
                      Obx(() => Text("Confirm ${controller.selectedTransaction}?", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: AppColors.secondary))),
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
                        color: Colors.black.withValues(alpha:0.05),
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
                      // Divider(color: Colors.black, ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Forex type",
                              style: TextStyle(
                                fontSize: 13,
                              )),
                          Obx(
                            () => Text(controller.selectedTransaction.value,
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                          ),
                        ],
                      ),
                      Divider(),
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

                      Divider(),

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
                      Divider(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Rate",
                              style: TextStyle(
                                fontSize: 13,
                              )),
                          Text(formatter.format(double.parse(controller.sellingRate.text.trim())),
                              style: TextStyle(
                                fontSize: 13,
                              )),
                        ],
                      ),
                      Divider(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total",
                              style: TextStyle(
                                fontSize: 13,
                              )),
                          Text(formatter.format(double.parse(controller.sellingTotal.text.trim().replaceAll(',', ''))),
                              style: TextStyle(
                                fontSize: 13,
                              )),
                        ],
                      ),
                      Divider(),

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
                      Divider(), Gap(13),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.secondary)),
                          Text('KES ${formatter.format(double.parse(controller.sellingTotal.text.trim().replaceAll(',', '')))}',
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
                  child: Obx(
                      ()=> FloatingActionButton(
                        // elevation: 0,
                        // style: ElevatedButton.styleFrom(
                        //   padding: EdgeInsets.symmetric(horizontal: 10),
                        //   disabledBackgroundColor: const Color(0xff35389fff),
                        backgroundColor: AppColors.prettyBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        // ),
                        onPressed: controller.isLoading.value?null:() async {
                          controller.checkInternetConnection(context);

                          // if(context.mounted){
                          //   Navigator.of(context).pop();
                          //
                          // }
                        },

                        // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                        child:  controller.isLoading.value?SizedBox(height: 30,width: 30,
                            child: CircularProgressIndicator(
                              color: AppColors.quinary,)):Text(
                          'Confirm',
                          style: TextStyle(color: AppColors.quinary, fontSize: 14, fontWeight: FontWeight.w700),
                        )),
                  ),
                ),

                Gap(10),
                Obx(
                      ()=>controller.isLoading.value?SizedBox.shrink():  SizedBox(
                    // height: 45,
                    width: double.maxFinite,
                    child: FloatingActionButton(disabledElevation: 0,
                          // elevation: 0,
                          // style: ElevatedButton.styleFrom(
                          //   padding: EdgeInsets.symmetric(horizontal: 10),
                          //   disabledBackgroundColor: const Color(0xff35389fff),
                          backgroundColor: AppColors.quinary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          // ),
                          onPressed: () => Navigator.of(context).pop(),

                          // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.west_outlined,
                                  color: AppColors.prettyDark,
                                ),
                              ),
                              Text(
                                'Back',
                                style: TextStyle(color: AppColors.prettyDark, fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          )),
                  ),
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
