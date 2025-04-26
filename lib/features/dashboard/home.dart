import 'package:ciyebooks/features/dashboard/controller/dashboard_controller.dart';
import 'package:ciyebooks/features/dashboard/widgets/button_list.dart';
import 'package:ciyebooks/features/dashboard/widgets/transactions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/constants/colors.dart';

import '../profile/profile.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    // final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: AppColors.quarternary,
      appBar: AppBar(
        backgroundColor: AppColors.quarternary,
        automaticallyImplyLeading: true,
        // title: Text("Dashboard"),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SizedBox(
            child: IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Correct context for drawer
              },
              icon: Icon(
                color: AppColors.prettyDark,
                Icons.sort,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: CupertinoColors.systemBlue,
            ),
          ),
          IconButton(
            onPressed: () => Get.to(() => Profile()),
            icon: Icon(
              Icons.person_outline,
              color: AppColors.prettyDark,
            ),
          ),
        ],
      ),
      body: SafeArea(
        // bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                child: Text(DateFormat.yMMMMEEEEd().format(DateTime.now()), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.prettyDark)),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.quinary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: ButtonList(),
              ),
              // Gap(15),

              SizedBox(height: 16),

              // 💵 Cash Balances
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.quinary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Cash balances", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.prettyDark)),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Obx(() => Column(
                            children: controller.totals.value.cashBalances.entries.map((entry) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(entry.key, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                                        Text("\$${formatter.format(entry.value)}", style: TextStyle(fontWeight: FontWeight.w700, color: CupertinoColors.systemBlue)),
                                      ],
                                    ),
                                  ),Divider(
                                    height: 0,
                                    thickness: .11,
                                    color: AppColors.prettyDark,
                                  )
                                ],
                              );
                            }).toList(),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // 🏦 Bank Balances
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.quinary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bank balances", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.prettyDark)),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Obx(() => Column(
                            children: controller.totals.value.bankBalances.entries.map((entry) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(entry.key, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                                        Text("\$${formatter.format(entry.value)}", style: TextStyle(fontWeight: FontWeight.w700, color: CupertinoColors.systemBlue)),
                                      ],
                                    ),
                                  ),Divider(
                                    height: 0,
                                    thickness: .11,
                                    color: AppColors.prettyDark,
                                  )
                                ],
                              );
                            }).toList(),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // 📄 Transactions Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.quinary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Recent transactions", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.prettyDark)),
                    SizedBox(height: 16),
                    TransactionsHistory(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
