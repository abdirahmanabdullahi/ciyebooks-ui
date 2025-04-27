import 'package:ciyebooks/features/dashboard/controller/dashboard_controller.dart';
import 'package:ciyebooks/features/dashboard/widgets/button_list.dart';
import 'package:ciyebooks/features/dashboard/widgets/transactions.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
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
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
              //   child: Text(DateFormat.yMMMMEEEEd().format(DateTime.now()),
              //       style: TextStyle(
              //         fontSize: 13,
              //         color: Colors.grey.shade600,
              //         fontWeight: FontWeight.w500,
              //         letterSpacing: 0.3,
              //       )),
              // ),
              Gap(8),
              Container(
                margin: EdgeInsets.all(6),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.quarternary,
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
                              Gap(10),
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: FloatingActionButton(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.quinary, width: 1), borderRadius: BorderRadius.circular(20)),
                                    onPressed: () {},
                                    child: Icon(
                                      size: 15,
                                      Icons.visibility,
                                      color: AppColors.prettyDark,
                                    )),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.quinary, width: 1.5),
                              // color: AppColors.quinary,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(radius:13,
                                  backgroundImage:  NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Flag_of_Kenya.svg/2560px-Flag_of_Kenya.svg.png'),
                                ),Gap(6),
                                Text('Kenya Shilling', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 10, color: AppColors.prettyDark)),
                                Gap(8),],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("ksh: 325,879,899.00", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25, color: AppColors.blue)),
                    ),
                    Gap(18),
                    ButtonList(),                    Gap(10),

                  ],
                ),
              ),

              /// 💵 Cash Balances
              Container(
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.quarternary,
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
                                        Text(formatter.format(entry.value), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.blue)),
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

              /// 🏦 Bank Balances
              Container(
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.quarternary,
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
                    SizedBox(height: 8),
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
                                        Text(formatter.format(entry.value), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.blue)),
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

              /// 📄 Transactions Section
              Container(
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.quarternary,
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blue,
                                ),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TransactionsHistory(),
                    ),
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
