import 'dart:ui';

import 'package:ciyebooks/features/dashboard/controller/dashboard_controller.dart';
import 'package:ciyebooks/features/dashboard/widgets/button_list.dart';
import 'package:ciyebooks/features/dashboard/recent_transactions.dart';
import 'package:ciyebooks/features/dashboard/widgets/top_button.dart';
import 'package:ciyebooks/features/profile/controller/profile_controller.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/constants/colors.dart';

import '../accounts/screens/accounts.dart';
import '../bank/bank_home.dart';
import '../forex/ui/forex_home.dart';
import '../pay/screens/payment_home.dart';
import '../profile/profile.dart';
import '../receive/screens/receipts_history.dart';
import '../stats/stats.dart';
import 'all_transactions.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    final profileController = Get.put(ProfileController());
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    // final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: AppColors.quarternary,
      appBar: AppBar(
        backgroundColor: AppColors.quinary,
        automaticallyImplyLeading: true,
        // title: Text("Dashboard"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Correct context for drawer
          },
          icon: Icon(
            color: AppColors.prettyBlue,
            Icons.sort_rounded,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const Stats()),
              );
            },
            icon: Icon(
              Icons.bar_chart_rounded,
              color: AppColors.prettyBlue,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const Profile()),
              );
            },
            icon: Icon(
              Icons.person_outline_outlined,
              color: AppColors.prettyBlue,
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
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Available Balance", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.quinary)),
                              Obx(
                                () => IconButton(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                    constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
                                    style: IconButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), side: BorderSide(color: AppColors.quinary, width: .5)),
                                    onPressed: () {
                                      controller.hide.value = !controller.hide.value;
                                    },
                                    icon: Icon(
                                      size: 15,
                                      controller.hide.value ? Icons.visibility_off : Icons.visibility,
                                      color: AppColors.quinary,
                                    )),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.quinary, width: .35),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 8,
                                  backgroundImage: AssetImage('assets/images/icons/kenyanFlag.png'),
                                ),
                                Gap(6),
                                Text('Kenya Shilling', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10, color: AppColors.quinary)),
                                Gap(8),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Obx(() => ImageFiltered(
                            imageFilter: controller.hide.value ? ImageFilter.blur(sigmaX: 9, sigmaY: 7) : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                            child: Text(
                              formatter
                                  .format((double.parse(controller.totals.value.cashBalances['KES'].toString()) + double.parse(controller.totals.value.bankBalances['KES'].toString())))
                                  .toString(),
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 35, color: AppColors.quinary),
                            ),
                          )),
                    ),
                    Gap(18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TopButton(
                            heroTag: "Payment",
                            icon: Icons.arrow_outward_rounded,
                            label: 'Pay',
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => const PaymentHome()),
                              );
                            }),

                        TopButton(
                            heroTag: "Receive",
                            icon: Icons.arrow_downward_rounded,
                            label: 'Receive',
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => const ReceiptsHistory()),
                              );
                            }),

                          TopButton(
                            heroTag: "Bank",
                            icon: Icons.account_balance_outlined,
                            label: 'Bank',
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => const BankHistory()),
                              );
                            }),

                        // if (profileController.forexEnabled.value)
                          TopButton(
                              heroTag: "Forex",
                              icon: Icons.currency_exchange_rounded,
                              label: 'Forex',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(builder: (context) => const ForexHome()),
                                );
                              }),
                        TopButton(
                            heroTag: "Accounts",
                            icon: Icons.group_outlined,
                            label: 'Accounts',
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => const Accounts()),
                              );
                            }),
                        // TopButton(
                        //   heroTag: "History",
                        //   icon: Icons.manage_search_outlined,
                        //   label: 'History',
                        //   onPressed: () => Get.to(() => const TransactionHistoryPage()),
                        // ),
                        // TopButton(
                        //     icon: Icons.search,
                        //     label: "Search all",
                        //     onPressed: () {},
                        //     heroTag: "Search all")
                      ],
                    ),
                    Gap(15),
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

              /// 💵 Bank Balances

              Obx(() { if (!profileController.bankEnabled.value) {
                return SizedBox.shrink();
              }
                return ImageFiltered(
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
                );
              }),

              /// 💵 Currency stock
              Obx(() {
                if (!profileController.forexEnabled.value) {
                  return SizedBox.shrink();
                }
                return ImageFiltered(
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
                          child: Text("Currency stock", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                        ),
                        Gap(8),
                        controller.totals.value.currenciesAtCost == 0
                            ? SizedBox(
                                width: double.maxFinite,
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Center(child: Text('No foreign currencies available.')),
                                ),
                              )
                            : Obx(
                                () {
                                  return SingleChildScrollView(
                                    physics: ClampingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 7),
                                      color: AppColors.quinary,
                                      width: MediaQuery.sizeOf(context).width,
                                      child: DataTable(
                                          dataRowMaxHeight: 40,
                                          dataRowMinHeight: 40,
                                          showBottomBorder: true,
                                          headingTextStyle: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w600),
                                          columnSpacing: 30,
                                          headingRowHeight: 40,
                                          horizontalMargin: 0,
                                          columns: [
                                            DataColumn(label: Text(' Name')),
                                            DataColumn(label: Text('Amount')),
                                            DataColumn(label: Text('Rate')),
                                            DataColumn(label: Text('Total ')),
                                          ],
                                          rows: controller.currencies.map((currency) {
                                            return DataRow(cells: [
                                              DataCell(Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                  currency.currencyCode,
                                                  style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w400),
                                                ),
                                              )),
                                              DataCell(
                                                Text(
                                                  formatter.format(
                                                    currency.amount,
                                                  ),
                                                ),
                                              ),
                                              DataCell(Text(
                                                currency.amount <= 0 ? '0.0' : formatter.format(currency.totalCost / currency.amount),
                                              )),
                                              DataCell(Text(
                                                formatter.format(currency.totalCost),
                                              )),
                                            ]);
                                          }).toList()),
                                    ),
                                  );
                                },
                              ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0,horizontal: 16 ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Cost of currencies", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
                              Obx(() => Text(formatter.format(double.parse(controller.totals.value.currenciesAtCost.toString())),
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              /// 📄 Transactions Section
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
                            padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Recent transactions", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(builder: (context) => const TransactionHistory()),
                                      );
                                    },
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
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
