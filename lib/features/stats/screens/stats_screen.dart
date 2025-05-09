import 'package:ciyebooks/features/stats/controllers/stats_controller.dart';
import 'package:ciyebooks/navigation_menu.dart';
import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    final controller = Get.put(StatsController());
    return Scaffold(
      backgroundColor: AppColors.quarternary,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => NavigationMenu());
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.prettyDark,
          ),
        ),
        title: Text('Stats'),
        automaticallyImplyLeading: true,
        // title: Text("Dashboard"),
        centerTitle: true,
        // leading: IconButton(
        //   onPressed: () =>Get.off(()=>NavigationMenu()),
        //   icon: Icon(
        //     color: AppColors.quinary,
        //     Icons.west_outlined,
        //   ),
        // ),
        backgroundColor: AppColors.quinary,
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
              margin: EdgeInsets.symmetric(vertical:3),


              decoration: BoxDecoration(
                color: AppColors.quinary,



              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
                    child: Text("Payments", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Obx(
                    () => Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 15),
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
              margin: EdgeInsets.symmetric(vertical:3),


              decoration: BoxDecoration(
                color: AppColors.quinary,



              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
                    child: Text("Received from clients", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Obx(
                    () => Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 15),
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
              margin: EdgeInsets.symmetric(vertical:3),


              decoration: BoxDecoration(
                color: AppColors.quinary,



              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
                    child: Text(" Deposits", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Obx(
                    () => Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 15),
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
              margin: EdgeInsets.symmetric(vertical:3),


              decoration: BoxDecoration(
                color: AppColors.quinary,



              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
                    child: Text("Withdrawals", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Obx(
                    () => Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 15),
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
              margin: EdgeInsets.symmetric(vertical:3),


              decoration: BoxDecoration(
                color: AppColors.quinary,



              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
                    child: Text("Expenses", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Obx(
                    () => Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 15),
                        child: Column(
                            children: controller.todayReport.value.expenses.entries.map((entry) {
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

            ///Currencies payable
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(vertical:3),


              decoration: BoxDecoration(
                color: AppColors.quinary,



              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
                    child: Text("Payables", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Padding(padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 15), child: Column(children: [])),
                ],
              ),
            ),

            /// Accounts receivable
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(vertical:3),


              decoration: BoxDecoration(
                color: AppColors.quinary,



              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
                    child: Text("Accounts receivable", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
                  ),
                  Gap(8),
                  Padding(padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 15), child: Column(children: [])),
                ],
              ),
            ),

            /// Accounts receivable
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(vertical:3),


              decoration: BoxDecoration(
                color: AppColors.quinary,



              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0, ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Income", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
                        Text(formatter.format(double.parse(controller.todayReport.value.dailyProfit.toString())),
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
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
