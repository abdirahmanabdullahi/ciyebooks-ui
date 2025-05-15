import 'dart:io';

import 'package:ciyebooks/features/bank/deposit/screens/deposits.dart';
import 'package:ciyebooks/features/bank/payment_bank_bottom_sheet.dart';
import 'package:ciyebooks/features/bank/withdraw/screens/withdrawals.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../utils/constants/colors.dart';


class BankHistory extends StatelessWidget {
  const BankHistory({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(DepositCashController());
    return Scaffold(
      backgroundColor: AppColors.quarternary,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.prettyDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),

        onPressed: () => Platform.isIOS ? showIosBankActionSheet(context) : showAndroidBankBottomSheet(context: context),
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
          'Bank',
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.quinary),
        ),
      ),      body: SafeArea(
        bottom: false,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                color: AppColors.quinary,
                child: TabBar(
                  padding: EdgeInsets.zero,
                  indicatorColor: CupertinoColors.systemBlue,
                  labelPadding: EdgeInsets.zero,
                  labelStyle: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(
                      height: 35,
                      child: Text(
                        'Deposits',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Tab(
                      height: 35,
                      child: Text(
                        'Withdrawals',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Deposits(),
                    Withdrawals(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

