import 'dart:io';

import 'package:ciyebooks/features/pay/screens/widgets/payment_bottom_sheet.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';

import 'expense/expenses.dart';
import 'payments/payments.dart';

class PaymentHome extends StatelessWidget {
  const PaymentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.prettyDark,
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(100)),
        onPressed: () => Platform.isIOS ? showIosPaymentActionSheet(context) : showAndroidPaymentBottomSheet(context: context),
        child: Icon(
          Icons.add,
          color: AppColors.quinary,
          // size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      appBar: AppBar(

        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.quinary,
            )),
        // automaticallyImplyLeading: false,
        backgroundColor: AppColors.prettyBlue,
        title: Text(
          'Payments',
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.quinary),
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
