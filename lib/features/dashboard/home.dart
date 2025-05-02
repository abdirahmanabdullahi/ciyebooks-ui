import 'dart:ui';

import 'package:ciyebooks/features/dashboard/controller/dashboard_controller.dart';
import 'package:ciyebooks/features/dashboard/widgets/button_list.dart';
import 'package:ciyebooks/features/dashboard/recent_transactions.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../utils/constants/colors.dart';

import '../profile/profile.dart';
import 'all_transactions.dart';

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
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Correct context for drawer
          },
          icon: Icon(
            color: AppColors.prettyDark,
            Icons.sort,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => Profile()),
            icon: Icon(
              Icons.person,
              color: AppColors.prettyDark,
            ),
          ),
        ],
      ),
      body: SafeArea(
        // bottom: false,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(8),
              Container(
                margin: EdgeInsets.all(6),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.prettyBlue,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(30),
                      blurRadius: 4,
                      offset: Offset(-3, 3),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(width: double.maxFinite,),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Available Balances", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                              Obx(
                                () => IconButton(
                                    constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
                                    style: IconButton.styleFrom(side: BorderSide(color: AppColors.quinary, width: 1.5)),
                                    onPressed: () {
                                      controller.hide.value = !controller.hide.value;
                                    },
                                    icon: Icon(
                                      size: 15,
                                      controller.hide.value ? Icons.visibility_off : Icons.visibility,
                                      color: AppColors.prettyDark,
                                    )),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.quinary, width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 8,
                                  backgroundImage: AssetImage('assets/images/icons/kenyanFlag.png'),
                                ),
                                Gap(6),
                                Text('Kenya Shilling', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 10, color: AppColors.prettyDark)),
                                Gap(8),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Obx(
                        () => controller.hide.value
                            ? ImageFiltered(
                                imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Text(
                                  formatter
                                      .format((double.parse(controller.totals.value.cashBalances['KES'].toString()) + double.parse(controller.totals.value.bankBalances['KES'].toString())))
                                      .toString(),
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25, color: AppColors.prettyDark),
                                ),
                              )
                            : Text(
                                formatter
                                    .format((double.parse(controller.totals.value.cashBalances['KES'].toString()) + double.parse(controller.totals.value.bankBalances['KES'].toString())))
                                    .toString(),
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25, color: AppColors.prettyDark),
                              ),
                      ),
                    ),
                    Gap(18),
                    ButtonList(), Gap(10),
                  ],
                ),
              ),

              /// 💵 Cash Balances
              Obx(() => ImageFiltered(
                    imageFilter: controller.hide.value ? ImageFilter.blur(sigmaX: 5, sigmaY: 5) : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.quinary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(30),
                            blurRadius: 4,
                            offset: Offset(-3, 3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
                            child: Text("Cash balances", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                          ),
                          Gap(8),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
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
                                  }).toList(),
                                )),
                          ),
                        ],
                      ),
                    ),
                  )),
              Obx(() => ImageFiltered(
                    imageFilter: controller.hide.value ? ImageFilter.blur(sigmaX: 5, sigmaY: 5) : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      margin: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.quinary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(30),
                            blurRadius: 4,
                            offset: Offset(-3, 3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
                            child: Text("Bank balances", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                          ),
                          Gap(8),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
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
                                  }).toList(),
                                )),
                          ),
                        ],
                      ),
                    ),
                  )),

              /// 🏦 Bank Balances
              // Container(
              //   margin: EdgeInsets.all(6),
              //   decoration: BoxDecoration(
              //     color: AppColors.quinary,
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withAlpha(30),
              //         blurRadius: 4,
              //         offset: Offset(-3, 3),
              //       )
              //     ],
              //     borderRadius: BorderRadius.circular(14),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.fromLTRB(12.0, 12, 0, 0),
              //         child: Text("Bank balances", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
              //       ),
              //       SizedBox(height: 8),
              //       Padding(
              //         padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
              //         child: Obx(() => Column(
              //               children: controller.totals.value.bankBalances.entries.map((entry) {
              //                 return Column(
              //                   children: [
              //                     Padding(
              //                       padding: const EdgeInsets.symmetric(vertical: 6.0),
              //                       child: Row(
              //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                         children: [
              //                           Text(entry.key, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
              //                           Text(formatter.format(entry.value), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.prettyDark)),
              //                         ],
              //                       ),
              //                     ),
              //                     Divider(
              //                       height: 0,
              //                       thickness: .11,
              //                       color: AppColors.prettyDark,
              //                     )
              //                   ],
              //                 );
              //               }).toList(),
              //             )),
              //       ),
              //     ],
              //   ),
              // ),

              /// 📄 Transactions Section
              Obx(
                () =>
                     ImageFiltered(
                       imageFilter: controller.hide.value?ImageFilter.blur(sigmaX: 5, sigmaY: 5):ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                        child: Container(
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.quinary,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(30),
                                blurRadius: 4,
                                offset: Offset(-3, 3),
                              )
                            ],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Recent transactions", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                                    TextButton(
                                        onPressed: () => Get.to(() => TransactionHistory()),
                                        child: Text(
                                          'View all',
                                          style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            decorationColor: CupertinoColors.systemBlue,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: CupertinoColors.systemBlue,
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: RecentTransactions(),
                              ),
                            ],
                          ),
                        ),
                      )

              ),
            ],
          ),
        ),
      ),
    );
  }
}
