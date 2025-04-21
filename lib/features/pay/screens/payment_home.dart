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
      backgroundColor: AppColors.quarternary,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.prettyDark,
        shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.quinary, width: 1.5), borderRadius: BorderRadius.circular(100)),
        onPressed: () {
          Platform.isIOS ? showIosPaymentActionSheet(context) : showAndroidPaymentBottomSheet(context: context);
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
