import 'package:ciyebooks/features/bank/withdraw/controllers/withdraw_cash_controller.dart';
import 'package:ciyebooks/features/bank/withdraw/screens/deposits.dart';
import 'package:ciyebooks/features/bank/withdraw/screens/withdrawals.dart';

import 'package:ciyebooks/navigation_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../utils/constants/colors.dart';
import '../bank/deposit/controller/deposit_cash_controller.dart';
import '../common/widgets/calculator.dart';
import '../dashboard/widgets/bottom_sheet_button.dart';


class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColors.quarternary,
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () => Get.offAll(NavigationMenu()),
              icon: Icon(
                Icons.close,
                color: AppColors.prettyDark,
              )),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.quarternary,
        title: Text(
          'Transaction history',
          style: TextStyle(color: AppColors.prettyDark),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: DefaultTabController(
          length: 5,
          child: Column(
            children: [
              Container(
                color: AppColors.quinary,
                child: TabBar(
                  padding: EdgeInsets.zero,
                  indicatorColor: CupertinoColors.systemBlue,
                  labelPadding: EdgeInsets.zero,
                  labelStyle: TextStyle(color: AppColors.blue, fontSize: 12,fontWeight: FontWeight.w500),
                  tabs: [
                    Tab(
                      height: 35,
                      child: Text(
                        'Payments',
                        // style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Tab(
                      height: 35,
                      child: Text(
                        'Received',
                        // style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ), Tab(
                      height: 35,
                      child: Text(
                        'Deposits',
                        // style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),Tab(
                      height: 35,
                      child: Text(
                        'Withdrawals',
                        // style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),Tab(
                      height: 35,
                      child: Text(
                        'Expenses',
                        // style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),

                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Deposits(),
                    Withdrawals(),  Deposits(),
                    Withdrawals(),
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

