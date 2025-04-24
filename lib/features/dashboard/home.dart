import 'package:ciyebooks/features/dashboard/controller/dashboard_controller.dart';
import 'package:ciyebooks/features/dashboard/widgets/button_list.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common/styles/custom_container.dart';
import '../../utils/constants/colors.dart';
import '../bank/deposit/model/deposit_model.dart';
import '../bank/withdraw/model/withdraw_model.dart';

import '../pay/models/expense_model.dart';
import '../pay/models/pay_client_model.dart';
import '../profile/profile.dart';
import '../receive/model/receive_model.dart';

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
      appBar:
      AppBar(
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
            // shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.prettyDark,width: .1),
            //   borderRadius: BorderRadius.circular(20)),
            // mini: true,backgroundColor: AppColors.quinary,elevation: 0,
            onPressed:(){},
            icon: Icon(
              Icons.search,
              color: CupertinoColors.systemBlue,
            ),
          ), IconButton(
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
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container( width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.quarternary,
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
              ),Gap(15),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      "Cash balances",
                      style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w500,fontSize: 16),              ),

                  ), Divider(
                    height: 2,
                    color: AppColors.prettyDark,
                  ),
                  Gap(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Obx(() => Column(
                      children: controller.totals.value.cashBalances.entries.map((entry) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: Column(
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      entry.key,
                              style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w500,),              ),

                                    Text(
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: CupertinoColors.systemBlue,
                                      ),
                                      formatter.format(entry.value),
                                    )
                                  ],
                                ),
                                Divider()
                              ],
                            )
                          // BalanceTile(
                          //   leading: entry.key,
                          //   title: formatter.format(entry.value),
                          //   // subtitle: entry.key,
                          //   valueColor: CupertinoColors.activeGreen,
                          // ),
                        );
                      }).toList(),
                    )),
                  ),
                ],
              ),

              Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  "Bank balances",
                  style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w500,fontSize: 16),              ),

              ),
              Divider(
                height: 2,
                color: AppColors.prettyDark,
              ),
              Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Obx(() => Column(
                      children: controller.totals.value.bankBalances.entries.map((entry) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: Column(
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      entry.key,
                              style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w500,),              ),

                                    Text(
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: CupertinoColors.systemBlue,
                                      ),
                                      formatter.format(entry.value),
                                    )
                                  ],
                                ),
                                Divider()
                              ],
                            )
                            // BalanceTile(
                            //   leading: entry.key,
                            //   title: formatter.format(entry.value),
                            //   // subtitle: entry.key,
                            //   valueColor: CupertinoColors.activeGreen,
                            // ),
                            );
                      }).toList(),
                    )),
              ),
              Gap(10),
              Text(
                "Foreign currency stock",
                style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w500,fontSize: 16),              ),
              Divider(
                height: 2,
                color: AppColors.prettyDark,
              ),
              Obx(
                () {
                  return Container(
                    color: AppColors.quarternary,
                    // width: MediaQuery.sizeOf(context).width,
                    child: SingleChildScrollView(physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          dataRowMaxHeight: 40,
                          dataRowMinHeight: 40,
                          showBottomBorder: true,
                          headingTextStyle: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w500),
                          columnSpacing: MediaQuery.sizeOf(context).width/8,
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
                                  style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w500),
                                ),
                              )),
                              DataCell(
                                Text(
                                  formatter.format(
                                    currency.amount,
                                  ),style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w500),
                                ),
                              ),
                              DataCell(Text(style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w500),
                                currency.amount <= 0 ? '0.0' : formatter.format(currency.totalCost / currency.amount),
                              )),
                              DataCell(Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  formatter.format(currency.totalCost),style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w500),
                                ),
                              )),
                            ]);
                          }).toList()),
                    ),
                  );
                },
              ),
              Gap(20),
              Text(
                "Recent transactions",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Divider(
                height: 0,
                color: Colors.black,
              ),
              DefaultTabController(
                  length: 5,
                  child: Column(children: [
                    TabBar(
                      padding: EdgeInsets.zero,
                      indicatorColor: AppColors.prettyDark,
                      labelPadding: EdgeInsets.zero,
                      labelStyle: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w500),
                      tabs: [
                        Tab(
                          child: Text(
                            'Payments',
                          ),
                        ),
                        Tab(
                          child: Text('Receive'),
                        ),
                        Tab(
                          child: Text('Bank'),
                        ),
                        Tab(
                          child: Text('Forex'),
                        ),
                        Tab(
                          child: Text('Expense'),
                        ),
                      ],
                    ),
                    Container(
                      color: AppColors.quarternary,
                      height: 450.0,
                      child: TabBarView(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Obx(
                            () {
                              if (controller.payments.isEmpty) {
                                return Text('Once created, payments will appear here');
                              }
                              return ListView.builder(
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.payments.length,
                                itemBuilder: (context, index) {
                                  final PayClientModel payment = controller.payments[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: CustomContainer(
                                      darkColor: AppColors.quinary,
                                      width: double.infinity,
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // First Row (From, Receiver, Amount)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'From: ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10,
                                                            color: Colors.grey[600],
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: payment.accountFrom,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10,
                                                            color: Colors.blue,
                                                            // Black Value
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Gap(3),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Receiver: ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10,
                                                            color: Colors.grey[600], // Grey Label
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: payment.receiver,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10,
                                                            color: Colors.blue,
                                                            // Grey Label
                                                            // Black Value
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '${payment.currency}: ',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        // fontSize: 12,
                                                        fontSize: 10,
                                                        color: Colors.grey[600], // Grey Label
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: formatter
                                                          .format(payment.amountPaid)
                                                          // text: payment.amountPaid
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 10,
                                                        color: Colors.redAccent, // Grey Label
                                                        // Black Value
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          Divider(color: Colors.grey[400], thickness: 1),

                                          // Second Row (Transaction ID, Type, Date)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Type: ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w300,
                                                            fontSize: 10,
                                                            color: Colors.grey[600], // Grey Label
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: payment.transactionType,
                                                          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10, color: Colors.blue // Grey Label
                                                              // Black Value
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Gap(10),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: '# ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w300,
                                                            fontSize: 10,
                                                            color: Colors.grey[600], // Grey Label
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: payment.transactionId,
                                                          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10, color: Colors.blue // Grey Label
                                                              // Black Value
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    // TextSpan(
                                                    //   text: 'Date: ',
                                                    //   style: TextStyle(
                                                    //     fontWeight:
                                                    //     FontWeight.w500,
                                                    //     fontSize: 12,
                                                    //     color: Colors
                                                    //         .blue, // Grey Label
                                                    //   ),
                                                    // ),
                                                    TextSpan(
                                                      text: DateFormat("dd MMM yyyy HH:mm").format(payment.dateCreated),
                                                      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10, color: Colors.blue // Grey Label
                                                          // Black Value
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Obx(
                            () {
                              if (controller.receipts.isEmpty) {
                                return Center(child: Text('Once created, receipts will appear here'));
                              }
                              return ListView.builder(
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.receipts.length,
                                itemBuilder: (context, index) {
                                  final ReceiveModel receipt = controller.receipts[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: CustomContainer(
                                      darkColor: AppColors.quinary,
                                      width: double.infinity,
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // First Row (From, Receiver, Amount)
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'From: ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10,
                                                            color: Colors.grey[600],
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: receipt.depositorName,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 12,
                                                            color: Colors.blue,
                                                            // Black Value
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Gap(3),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Receiver: ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10,
                                                            color: Colors.grey[600], // Grey Label
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: receipt.receivingAccountName,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 12,
                                                            color: Colors.blue,
                                                            // Grey Label
                                                            // Black Value
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '${receipt.currency}: ',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        // fontSize: 12,
                                                        fontSize: 10,
                                                        color: Colors.grey[600], // Grey Label
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: formatter
                                                          .format(receipt.amount)
                                                          // text: payment.amountPaid
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 12,
                                                        color: Colors.redAccent, // Grey Label
                                                        // Black Value
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          Divider(color: Colors.grey[400], thickness: 1),

                                          // Second Row (Transaction ID, type, Date)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'type: ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10,
                                                            color: Colors.grey[600], // Grey Label
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: receipt.transactionType,
                                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
                                                              // Black Value
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Gap(10),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: '# ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10,
                                                            color: Colors.grey[600], // Grey Label
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: receipt.transactionId,
                                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
                                                              // Black Value
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: DateFormat("dd MMM yyyy HH:mm").format(receipt.dateCreated),
                                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
                                                          // Black Value
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        DefaultTabController(
                            length: 2,
                            child: Column(children: [
                              TabBar(
                                padding: EdgeInsets.zero,
                                indicatorColor: AppColors.prettyDark,
                                labelPadding: EdgeInsets.zero,
                                labelStyle: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.bold),
                                tabs: [
                                  Tab(
                                    child: Text('Deposits'),
                                  ),
                                  Tab(
                                    child: Text('Withdrawals'),
                                  ),
                                ],
                              ),
                              Container(
                                color: AppColors.quarternary,
                                height: 400.0,
                                child: TabBarView(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Obx(
                                      () {
                                        if (controller.deposits.isEmpty) {
                                          return Text('Once created, deposits will appear here');
                                        }
                                        return ListView.builder(
                                          physics: ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: controller.deposits.length,
                                          itemBuilder: (context, index) {
                                            final DepositModel deposit = controller.deposits[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: GestureDetector(
                                                dragStartBehavior: DragStartBehavior.start,
                                                child: CustomContainer(
                                                  darkColor: AppColors.quinary,
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(8),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      // First Row (From, Receiver, Amount)
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text: 'Deposited by: ',
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 10,
                                                                        color: Colors.grey[600],
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: deposit.depositedBy,
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 12,
                                                                        color: Colors.blue,
                                                                        // Black Value
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Gap(3),
                                                              //                                                   RichText(
                                                              //                                                     text: TextSpan(
                                                              //                                                       children: [
                                                              //                                                         TextSpan(
                                                              //                                                           text: 'Receiver: ',
                                                              //                                                           style: TextStyle(
                                                              //                                                             fontWeight: FontWeight.w500,
                                                              //                                                             fontSize: 10,
                                                              //                                                             color: Colors.grey[600], // Grey Label
                                                              //                                                           ),
                                                              //                                                         ),
                                                              //                                                         TextSpan(
                                                              //                                                           text: payment.receiver,
                                                              //                                                           style: TextStyle(
                                                              //                                                             fontWeight: FontWeight.w500,
                                                              //                                                             fontSize: 12,
                                                              //                                                             color: Colors.blue,
                                                              // // Grey Label
                                                              //                                                             // Black Value
                                                              //                                                           ),
                                                              //                                                         ),
                                                              //                                                       ],
                                                              //                                                     ),
                                                              //                                                   ),
                                                            ],
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: '${deposit.currency}: ',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    // fontSize: 12,
                                                                    fontSize: 10,
                                                                    color: Colors.grey[600], // Grey Label
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: formatter
                                                                      .format(deposit.amount)
                                                                      // text: payment.amountPaid
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w700,
                                                                    fontSize: 12,
                                                                    color: Colors.redAccent, // Grey Label
                                                                    // Black Value
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      Divider(color: Colors.grey[400], thickness: 1),

                                                      // Second Row (Transaction ID, Type, Date)
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text: 'type: ',
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 10,
                                                                        color: Colors.grey[600], // Grey Label
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: deposit.transactionType,
                                                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
                                                                          // Black Value
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Gap(10),
                                                              RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text: '# ',
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 10,
                                                                        color: Colors.grey[600], // Grey Label
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: deposit.transactionId,
                                                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
                                                                          // Black Value
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: DateFormat("dd MMM yyyy HH:mm").format(deposit.dateCreated),
                                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
                                                                      // Black Value
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Obx(
                                      () {
                                        if (controller.withdrawals.isEmpty) {
                                          return Text('Once created, withdrawals will appear here');
                                        }
                                        return ListView.builder(
                                          physics: ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: controller.withdrawals.length,
                                          itemBuilder: (context, index) {
                                            final WithdrawModel withdrawal = controller.withdrawals[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: GestureDetector(
                                                dragStartBehavior: DragStartBehavior.start,
                                                child: CustomContainer(
                                                  darkColor: AppColors.quinary,
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(8),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      // First Row (From, Receiver, Amount)
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text: 'From: ',
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 10,
                                                                        color: Colors.grey[600],
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: 'Bank account',
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 12,
                                                                        color: Colors.blue,
                                                                        // Black Value
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Gap(3),
                                                              RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text: 'Withdrawn by: ',
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 10,
                                                                        color: Colors.grey[600], // Grey Label
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: withdrawal.withdrawnBy,
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 12,
                                                                        color: Colors.blue,
                                                                        // Grey Label
                                                                        // Black Value
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: '${withdrawal.currency}: ',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    // fontSize: 12,
                                                                    fontSize: 10,
                                                                    color: Colors.grey[600], // Grey Label
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: formatter
                                                                      .format(withdrawal.amount)
                                                                      // text: payment.amountPaid
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w700,
                                                                    fontSize: 12,
                                                                    color: Colors.redAccent, // Grey Label
                                                                    // Black Value
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      Divider(color: Colors.grey[400], thickness: 1),

                                                      // Second Row (Transaction ID, Type, Date)
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text: 'type: ',
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 10,
                                                                        color: Colors.grey[600], // Grey Label
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: withdrawal.transactionType,
                                                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
                                                                          // Black Value
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Gap(10),
                                                              RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text: '# ',
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 10,
                                                                        color: Colors.grey[600], // Grey Label
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: withdrawal.transactionId,
                                                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
                                                                          // Black Value
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Gap(15),
                                                              RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text: withdrawal.withdrawalType,
                                                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
                                                                          // Black Value
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: DateFormat("dd MMM yyyy HH:mm").format(withdrawal.dateCreated),
                                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
                                                                      // Black Value
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ]),
                              )
                            ])),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Obx(
                            () {
                              if (controller.receipts.isEmpty) {
                                return Center(child: Text('Once created, receipts will appear here'));
                              }
                              return Center(
                                  child: Text(
                                'Forex',
                                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                              ));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Obx(
                            () {
                              if (controller.expenses.isEmpty) {
                                return Text('Once created, expenses will appear here');
                              }
                              return ListView.builder(
                                physics: ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.expenses.length,
                                itemBuilder: (context, index) {
                                  final ExpenseModel expense = controller.expenses[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: CustomContainer(
                                      darkColor: AppColors.quinary,
                                      width: double.infinity,
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // First Row (From, Receiver, Amount)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Category: ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10,
                                                            color: Colors.grey[600],
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: expense.category,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 12,
                                                            color: Colors.blue,
                                                            // Black Value
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Gap(3),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Description: ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10,
                                                            color: Colors.grey[600], // Grey Label
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: expense.description,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 12,
                                                            color: Colors.blue,
                                                            // Grey Label
                                                            // Black Value
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '${expense.currency}: ',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        // fontSize: 12,
                                                        fontSize: 10,
                                                        color: Colors.grey[600], // Grey Label
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: formatter
                                                          .format(expense.amountPaid)
                                                          // text: payment.amountPaid
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 12,
                                                        color: Colors.redAccent, // Grey Label
                                                        // Black Value
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          Divider(color: Colors.grey[400], thickness: 1),

                                          // Second Row (Transaction ID, Type, Date)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Type: ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10,
                                                            color: Colors.grey[600], // Grey Label
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: expense.transactionType,
                                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
                                                              // Black Value
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Gap(10),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: '# ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10,
                                                            color: Colors.grey[600], // Grey Label
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: expense.transactionId,
                                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
                                                              // Black Value
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    // TextSpan(
                                                    //   text: 'Date: ',
                                                    //   style: TextStyle(
                                                    //     fontWeight:
                                                    //     FontWeight.w500,
                                                    //     fontSize: 12,
                                                    //     color: Colors
                                                    //         .blue, // Grey Label
                                                    //   ),
                                                    // ),
                                                    TextSpan(
                                                      text: DateFormat("dd MMM yyyy HH:mm").format(expense.dateCreated),
                                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
                                                          // Black Value
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ]),
                    )
                  ])),
            ],
          ),
        ),
      ),
    );
  }
}
