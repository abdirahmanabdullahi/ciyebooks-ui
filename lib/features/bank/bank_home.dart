import 'dart:io';

import 'package:ciyebooks/features/bank/deposit/controller/deposit_cash_controller.dart';
import 'package:ciyebooks/features/bank/withdraw/screens/deposits.dart';
import 'package:ciyebooks/features/bank/payment_bank_bottom_sheet.dart';
import 'package:ciyebooks/features/bank/withdraw/screens/withdrawals.dart';

import 'package:ciyebooks/navigation_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../utils/constants/colors.dart';


class BankHistory extends StatelessWidget {
  const BankHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DepositCashController());
    return Scaffold(
      backgroundColor: AppColors.quarternary,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.prettyDark,
        shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.quinary, width: 2.5), borderRadius: BorderRadius.circular(100)),

        onPressed: () => Platform.isIOS ? showIosBankActionSheet(context) : showAndroidBankBottomSheet(context: context),
        child: Icon(
          Icons.add,
          color: AppColors.quinary,
          // size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(

        // leading:
      // IconButton(
          // onPressed: () => Get.off(NavigationMenu()),
          // icon: Icon(
          //   Icons.arrow_back_ios,
          //   color: AppColors.prettyDark,
          // )),
        elevation: 0,
        // actions: [
        //   IconButton(
        //       onPressed: () => Get.offAll(NavigationMenu()),
        //       icon: Icon(
        //         Icons.close,
        //         color: AppColors.prettyDark,
        //       )),
        // ],
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.quarternary,
        title: Text(
          'Bank',
          style: TextStyle(fontWeight: FontWeight.w400, color: AppColors.prettyDark),
        ),
      ),
      body: SafeArea(
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

