import 'package:ciyebooks/features/accounts/screens/accounts.dart';
import 'package:ciyebooks/features/stats/controllers/stats_controller.dart';
import 'package:ciyebooks/navigation_menu.dart';
import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/styles/custom_container.dart';
import '../../accounts/model/model.dart';
import '../../accounts/screens/widgets/account_viewer.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    final controller = Get.put(StatsController());
    // In this example, the date is formatted manually. You can
    // use the intl package to format the value based on the
    // user's locale settings.

    return Scaffold(
      backgroundColor: AppColors.quarternary,
      // appBar: AppBar(

      //   title: Text('Stats'),
      //   automaticallyImplyLeading: true,
      //   backgroundColor: AppColors.quinary,
      // ),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.quinary,
            )),   actions: [
        IconButton(
          onPressed: () async => await showDateRangePicker(
              context: context,
              initialDateRange: DateTimeRange(start: startOfMonth, end: now),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.prettyDark, // Header and selected day color
                        onPrimary: AppColors.quinary, // Text color on selected day
                        surface: Colors.grey, // Calendar surface background
                        onSurface: AppColors.prettyDark,
                      )),
                  child: child!,
                );
              }),
          icon: Icon(
            Icons.tune_outlined,color: AppColors.quinary,
          ),
        ),
      ],
        // automaticallyImplyLeading: false,
        backgroundColor: AppColors.prettyBlue,
        title: Text(
          'Stats',
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.quinary),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            Gap(3),

            ///Payments
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.quinary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 12, 8, 0),
                    child: Text("Payments", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Obx(
                    () => Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 15),
                        child: Column(
                            children: controller.todayReport.value.payments.entries.map((entry) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(entry.key, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                                    Text(formatter.format(entry.value), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.prettyDark)),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 0,
                                thickness: .11,
                                color: AppColors.prettyDark,
                              )
                            ],
                          );
                          ;
                        }).toList())),
                  ),
                ],
              ),
            ),

            ///Client deposits
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.quinary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 12, 8, 0),
                    child: Text("Received from clients", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Obx(
                    () => Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 15),
                        child: Column(
                            children: controller.todayReport.value.received.entries.map((entry) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(entry.key, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                                    Text(formatter.format(entry.value), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.prettyDark)),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 0,
                                thickness: .11,
                                color: AppColors.prettyDark,
                              )
                            ],
                          );
                          ;
                        }).toList())),
                  ),
                ],
              ),
            ),

            ///Bank deposits
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.quinary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 12, 8, 0),
                    child: Text(" Deposits", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Obx(
                    () => Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 15),
                        child: Column(
                            children: controller.todayReport.value.deposits.entries.map((entry) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(entry.key, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                                    Text(formatter.format(entry.value), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.prettyDark)),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 0,
                                thickness: .11,
                                color: AppColors.prettyDark,
                              )
                            ],
                          );
                          ;
                        }).toList())),
                  ),
                ],
              ),
            ),

            /// Bank withdrawals
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.quinary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 12, 8, 0),
                    child: Text("Withdrawals", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Obx(
                    () => Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 15),
                        child: Column(
                            children: controller.todayReport.value.withdrawals.entries.map((entry) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(entry.key, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                                    Text(formatter.format(entry.value), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.prettyDark)),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 0,
                                thickness: .11,
                                color: AppColors.prettyDark,
                              )
                            ],
                          );
                          ;
                        }).toList())),
                  ),
                ],
              ),
            ),

            /// Expenses
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.quinary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 12, 8, 8),
                    child: Text("Receivables", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Obx(
                    () => ListView(
                      shrinkWrap: true,
                      children: controller.accounts.map((account) {
                        return GestureDetector(onTap: ()=>showAccountDetails(context: context, accountName: account.accountName, accountNumber: account.accountNo, email: account.email, phoneNumber: account.phoneNo, balances: account.currencies.entries.map((currency) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(currency.key,
                                      style: TextStyle(
                                        fontSize: 13,
                                      )),
                                  Text(formatter.format(currency.value),
                                      style: TextStyle(
                                          fontSize: 13,color: double.parse(currency.value.toString())<0?AppColors.red:AppColors.prettyDark
                                      )),
                                ],
                              ),
                              Divider(color: Colors.black, thickness: .11),
                            ],
                          );
                        }).toList()),
                          child: Padding(
                            padding: const EdgeInsets.only(top:  6),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(account.accountName, style: TextStyle(color:Colors.red, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                                Divider(
                                  // height: 0,
                                  thickness: .11,
                                  color: AppColors.prettyDark,
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),

            // /// Accounts receivable
            // Container(
            //   width: double.maxFinite,
            //   margin: EdgeInsets.symmetric(vertical: 3),
            //   decoration: BoxDecoration(
            //     color: AppColors.quinary,
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.fromLTRB(8.0, 12, 8, 0),
            //         child: Text("Payables", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
            //       ),
            //       Gap(8),
            //       Obx(
            //         () => Padding(
            //             padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 15),
            //             child: Column(
            //                 children: controller.todayReport.value.expenses.entries.map((entry) {
            //               return Column(
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.symmetric(vertical: 6.0),
            //                     child: Row(
            //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Text(entry.key, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
            //                         Text(formatter.format(entry.value), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.prettyDark)),
            //                       ],
            //                     ),
            //                   ),
            //                   Divider(
            //                     height: 0,
            //                     thickness: .11,
            //                     color: AppColors.prettyDark,
            //                   )
            //                 ],
            //               );
            //               ;
            //             }).toList())),
            //       ),
            //     ],
            //   ),
            // ),
            //
            // /// Accounts payable
            // Container(
            //   width: double.maxFinite,
            //   margin: EdgeInsets.symmetric(vertical: 3),
            //   decoration: BoxDecoration(
            //     color: AppColors.quinary,
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.fromLTRB(8.0, 12, 8, 0),
            //         child: Text("Expenses", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
            //       ),
            //       Gap(8),
            //       Obx(
            //         () => Padding(
            //             padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 15),
            //             child: Column(
            //                 children: controller.todayReport.value.expenses.entries.map((entry) {
            //               return Column(
            //                 children: [
            //                   Padding(
            //                     padding: const EdgeInsets.symmetric(vertical: 6.0),
            //                     child: Row(
            //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Text(entry.key, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
            //                         Text(formatter.format(entry.value), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.prettyDark)),
            //                       ],
            //                     ),
            //                   ),
            //                   Divider(
            //                     height: 0,
            //                     thickness: .11,
            //                     color: AppColors.prettyDark,
            //                   )
            //                 ],
            //               );
            //               ;
            //             }).toList())),
            //       ),
            //     ],
            //   ),
            // ),

            /// Income
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.quinary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(
                      12.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Income", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => controller.createDailyReport(),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.quarternary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                width: 80,
                                margin: EdgeInsets.only(right: 20),
                                child: Row(
                                  children: [
                                    Icon(
                                      size: 18,
                                      Icons.refresh_outlined,
                                      color: AppColors.prettyDark,
                                    ),
                                    Gap(6),
                                    Text(
                                      'Refresh',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Obx(
                              () => Text(formatter.format(double.parse(controller.todayReport.value.dailyProfit.toString())),
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.prettyDark)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
