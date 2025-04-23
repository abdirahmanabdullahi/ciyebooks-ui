import 'dart:io';

import 'package:ciyebooks/features/pay/controllers/pay_client_controller.dart';
import 'package:ciyebooks/features/pay/screens/widgets/payment_bottom_sheet.dart';
import 'package:ciyebooks/navigation_menu.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../dashboard/widgets/bottom_sheet_button.dart';

import '../controllers/pay_expense_controller.dart';
import 'expenses.dart';
import 'payments.dart';

class PaymentHome extends StatefulWidget {
  const PaymentHome({super.key});

  @override
  State<PaymentHome> createState() => _PaymentHomeState();
}

class _PaymentHomeState extends State<PaymentHome> {
  @override
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Platform.isIOS ? showIosPaymentActionSheet(context) : showAndroidPaymentBottomSheet(context: context);
    });

    PayExpenseController.instance.fetchTotals();
    super.initState();
  }

  final controller = Get.put(PayExpenseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.prettyDark,
        shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.quinary, width: 1.5), borderRadius: BorderRadius.circular(100)),
        onPressed: () {
          Get.to(() => PaymentSuccessPage());
          // Platform.isIOS ? showIosPaymentActionSheet(context) : showAndroidPaymentBottomSheet(context: context);
        },
        child: Icon(
          Icons.add,
          color: AppColors.quinary,
          // size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Get.offAll(NavigationMenu()),
              icon: Icon(
                Icons.close,
                color: AppColors.prettyDark,
              )),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.quarternary,
        title: Text(
          'Payment history',
          style: TextStyle(fontWeight: FontWeight.w400, color: AppColors.prettyDark),
        ),
      ),
      body: SafeArea(
        // bottom: false,
        child: DefaultTabController(
            length: 2,
            child: Column(children: [
              Container(
                color: Colors.white,
                child: TabBar(
                  padding: EdgeInsets.zero,
                  indicatorColor: CupertinoColors.systemBlue,
                  labelPadding: EdgeInsets.zero,
                  labelStyle: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(
                      height: 35,
                      child: Text(
                        'Payments',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Tab(
                      height: 35,
                      child: Text(
                        'Expenses',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(children: [PaymentsHistory(), ExpenseHistory()]),
              )
            ])),
      ),
    );
  }
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
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
                            style: TextStyle(fontWeight: FontWeight.w600,
                              fontSize: 14,
                            )),
                        Text("John Doe",
                            style: TextStyle(fontWeight: FontWeight.w600,
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
                            style: TextStyle(fontWeight: FontWeight.w600,
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
                            style: TextStyle(fontWeight: FontWeight.w600,
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
                            style: TextStyle(fontWeight: FontWeight.w600,
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
                            style: TextStyle(fontWeight: FontWeight.w600,
                              fontSize: 14,
                            )),
                      ],
                    ),
                    Divider(color: Colors.black, thickness: .11),Gap(12),

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
        ),
      ),
    );
  }
}
