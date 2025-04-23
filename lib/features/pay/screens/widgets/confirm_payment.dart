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
                    Icon(Icons.info_outline_rounded, color: Colors.orange[700], size: 68),
                    const SizedBox(height: 15),
                    Text("Confirm Payment?", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: AppColors.secondary)),
                    Gap(6),
                    Text("${controller.paidCurrency.text.trim()}  ${formatter.format(double.parse(controller.amount.text.trim()))}",
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
                      "Payment Details",
                      style: TextStyle(letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.secondary
                          // fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 16),
                    // Divider(color: Colors.black, thickness: .11),
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
                        Text("Date/time",
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
              Gap(20),
              SizedBox(
                // height: 45,
                width: double.maxFinite,
                child: FloatingActionButton(
                    // elevation: 0,
                    // style: ElevatedButton.styleFrom(
                    //   padding: EdgeInsets.symmetric(horizontal: 10),
                    //   disabledBackgroundColor: const Color(0xff35389fff),
                    backgroundColor: AppColors.quinary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    // ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },

                    // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.prettyDark, fontSize: 14, fontWeight: FontWeight.w700),
                    )),
              ),
              Gap(20),
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
                      controller.createPayment(context);
                    },

                    // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                    child: Text(
                      'Confirm payment',
                      style: TextStyle(color: AppColors.quinary, fontSize: 14, fontWeight: FontWeight.w700),
                    )),
              ),
              Gap(6)
            ],
          ),
        ),
      );
    },
  );
}

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PayClientController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.createReceiptPdf();
        },
        // onPressed: () => Get.to(
        //   () => PaymentHome(),
        // ),
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Top success box
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(24),
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
                const Icon(Icons.info_outline_rounded, color: Colors.orange, size: 68),
                const SizedBox(height: 15),
                Text("Confirm Payment?", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: AppColors.secondary)),
                Gap(6),
                Text("USD 1,200.00", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25, color: AppColors.secondary)),
                Gap(6),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Payment Details box
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Details",
                  style: TextStyle(letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.secondary
                      // fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 26),
                // Divider(color: Colors.black, thickness: .11),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Payee",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        )),
                    Text("John Doe",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        )),
                  ],
                ),
                Divider(color: Colors.black, thickness: .11),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Payee",
                        style: TextStyle(
                          fontSize: 14,
                        )),
                    Text("John Doe",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        )),
                  ],
                ),
                Divider(color: Colors.black, thickness: .11),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Payee",
                        style: TextStyle(
                          fontSize: 14,
                        )),
                    Text("John Doe",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        )),
                  ],
                ),
                Divider(color: Colors.black, thickness: .11),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Payee",
                        style: TextStyle(
                          fontSize: 14,
                        )),
                    Text("John Doe",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        )),
                  ],
                ),
                Divider(color: Colors.black, thickness: .11),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Payee",
                        style: TextStyle(
                          fontSize: 14,
                        )),
                    Text("John Doe",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        )),
                  ],
                ),
                Divider(color: Colors.black, thickness: .11), Gap(13),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Payment", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.secondary)),
                    Text("IDR 1,000,000",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ],
            ),
          ),
          Gap(20),
          SizedBox(
            // height: 45,
            width: double.maxFinite,
            child: FloatingActionButton(
                elevation: 0,
                // style: ElevatedButton.styleFrom(
                //   padding: EdgeInsets.symmetric(horizontal: 10),
                //   disabledBackgroundColor: const Color(0xff35389fff),
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                // ),
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.createPayment(context);
                },

                // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                child: Text(
                  'Confirm',
                  style: TextStyle(color: AppColors.quinary, fontSize: 14),
                )),
          ),
        ],
      ),
    );
  }
}
