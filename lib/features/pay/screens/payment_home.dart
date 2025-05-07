import 'dart:io';

import 'package:ciyebooks/features/pay/screens/widgets/payment_bottom_sheet.dart';
import 'package:ciyebooks/navigation_menu.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';

import '../controllers/pay_expense_controller.dart';
import 'expense/expenses.dart';
import 'payments/payments.dart';


class PaymentHome extends StatelessWidget {
  const PaymentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.prettyDark,
        shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.quinary, width: 2.5), borderRadius: BorderRadius.circular(100)),
        onPressed: () => Platform.isIOS ? showIosPaymentActionSheet(context) : showAndroidPaymentBottomSheet(context: context),
        child: Icon(
          Icons.add,
          color: AppColors.quinary,
          // size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        elevation: 0,

        // automaticallyImplyLeading: false,
        backgroundColor: AppColors.quarternary,
        title: Text(
          'Payments',
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
