import 'package:ciyebooks/features/dashboard/controller/dashboard_controller.dart';
import 'package:ciyebooks/features/dashboard/widgets/balances_tile.dart';
import 'package:ciyebooks/features/dashboard/widgets/button_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common/styles/custom_container.dart';
import '../../utils/constants/colors.dart';
import '../accounts/model/model.dart';
import '../bank/deposit/model/deposit_model.dart';
import '../bank/transfers/model/transfer_model.dart';
import '../bank/withdraw/model/withdraw_model.dart';
import '../pay/pay_client/pay_client_model/pay_client_model.dart';
import '../pay/pay_expense/expense_model/expense_model.dart';
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
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemBlue,
        automaticallyImplyLeading: true,
        // title: Text("Dashboard"),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SizedBox(
            child: IconButton(
              // backgroundColor: AppColors.quarternary.withOpacity(.9),
              // shape:  CircleBorder(
              //   side: BorderSide(width: 1, color: AppColors.quarternary.withOpacity(.2)),
              // ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Correct context for drawer
              },
              icon: Icon(
                color: AppColors.quinary,
                Icons.sort,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => Profile()),
            icon: Icon(
              Icons.person_outline,
              color: AppColors.quinary,
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          // primary: true,

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Container(color: AppColors.quinary, height: 100, width: double.infinity, padding: const EdgeInsets.all(6), child: ButtonList()),
              ),
              // Cash balances
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cash balances",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Obx(() => Column(
                          children: controller.totals.value.cashBalances.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3.0),
                              child: BalanceTile(
                                leading: entry.key,
                                title: formatter.format(entry.value),
                                // subtitle: entry.key,
                                valueColor: CupertinoColors.activeGreen,
                              ),
                            );
                          }).toList(),
                        )),
                  ],
                ),
              ),
              //Bank balances
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bank balances",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Obx(() => Column(
                          children: controller.totals.value.bankBalances.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3.0),
                              child: BalanceTile(
                                leading: entry.key,
                                title: formatter.format(entry.value),
                                // subtitle: entry.key,
                                valueColor: CupertinoColors.activeGreen,
                              ),
                            );
                          }).toList(),
                        )),
                    const Gap(6),
                    Text(
                      "Foreign currency stock",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: CustomContainer(
                        border: Border.all(color: Colors.grey, width: 0.3),
                        darkColor: AppColors.quinary,
                        width: double.infinity,
                        padding: const EdgeInsets.all(6),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: ClampingScrollPhysics(),
                          child: Obx(
                            () {
                              return DataTable(
                                  columnSpacing: 35,
                                  headingRowHeight: 40,
                                  horizontalMargin: 0,
                                  headingTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  columns: [
                                    DataColumn(label: Text('Code')),
                                    DataColumn(label: Text('Amount')),
                                    DataColumn(label: Text('Rate')),
                                    DataColumn(label: Text('Total cost')),
                                  ],
                                  rows: controller.currencies.map((currency) {
                                    return DataRow(cells: [
                                      DataCell(Text(
                                        currency.currencyCode,
                                        style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.bold, fontSize: 15),
                                      )),
                                      DataCell(Text(
                                        formatter.format(
                                          currency.amount,
                                        ),
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      )),
                                      DataCell(Text(currency.amount <= 0 ? '0.0' : formatter.format(currency.totalCost / currency.amount), style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataCell(Text(formatter.format(currency.totalCost), style: TextStyle(fontWeight: FontWeight.bold))),
                                    ]);
                                  }).toList());
                            },
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Text(
                      "Recent transactions",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    CustomContainer(
                      border: Border.all(color: Colors.grey, width: 0.3),
                      darkColor: AppColors.quinary,
                      width: double.infinity,
                      padding: const EdgeInsets.all(0),
                      child: DefaultTabController(
                          length: 5,
                          child: Column(children: [
                            TabBar(
                              padding: EdgeInsets.zero,
                              indicatorColor: AppColors.prettyDark,
                              labelPadding: EdgeInsets.zero,
                              labelStyle: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.bold),
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
                                            child: GestureDetector(
                                              dragStartBehavior: DragStartBehavior.start,
                                              // onTapDown: (details) {
                                              //   final offset = details.globalPosition;
                                              //
                                              //   showMenu(
                                              //       color: AppColors.quinary,
                                              //       constraints: BoxConstraints.expand(
                                              //           width: 200, height: 200),
                                              //       context: context,
                                              //       position: RelativeRect.fromLTRB(
                                              //         offset.dx,
                                              //         offset.dy,
                                              //         MediaQuery.of(context).size.width -
                                              //             offset.dx,
                                              //         MediaQuery.of(context).size.height -
                                              //             offset.dy,
                                              //       ),
                                              //       items: [
                                              //         PopupMenuItem(
                                              //           ///Todo: implement pay client popup
                                              //           onTap: () {
                                              //             showDialog(
                                              //               context: context,
                                              //               builder: (context) {
                                              //                 return Dialog(
                                              //                   backgroundColor:
                                              //                   AppColors.quarternary,
                                              //                   insetPadding:
                                              //                   EdgeInsets.symmetric(
                                              //                       horizontal: 15,
                                              //                       vertical: 10),
                                              //                   shape: RoundedRectangleBorder(
                                              //                     borderRadius:
                                              //                     BorderRadius.circular(
                                              //                         15),
                                              //                   ),
                                              //                   child: Padding(
                                              //                     padding:
                                              //                     EdgeInsets.all(15.0),
                                              //                     child: Column(
                                              //                       mainAxisSize:
                                              //                       MainAxisSize.min,
                                              //                       crossAxisAlignment:
                                              //                       CrossAxisAlignment
                                              //                           .start,
                                              //                       children: [
                                              //                         // Dialog Title
                                              //                         Text(
                                              //                           "Pay Client",
                                              //                           style: TextStyle(
                                              //                             fontSize: 22,
                                              //                             fontWeight:
                                              //                             FontWeight.w600,
                                              //                             color: Colors
                                              //                                 .blueAccent,
                                              //                           ),
                                              //                         ),
                                              //                         SizedBox(height: 8),
                                              //                         Divider(
                                              //                             thickness: 1,
                                              //                             color:
                                              //                             Colors.black12),
                                              //
                                              //                         SizedBox(height: 20),
                                              //
                                              //                         // Account Details
                                              //                         Text(
                                              //                           account.fullName,
                                              //                           style: TextStyle(
                                              //                             fontSize: 18,
                                              //                             fontWeight:
                                              //                             FontWeight.bold,
                                              //                             color:
                                              //                             Colors.black87,
                                              //                           ),
                                              //                         ),
                                              //                         SizedBox(height: 12),
                                              //
                                              //                         RichText(
                                              //                           text: TextSpan(
                                              //                             children: [
                                              //                               TextSpan(
                                              //                                 text:
                                              //                                 'Account No: ',
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   fontWeight:
                                              //                                   FontWeight
                                              //                                       .bold,
                                              //                                   color: Colors
                                              //                                       .black87,
                                              //                                 ),
                                              //                               ),
                                              //                               TextSpan(
                                              //                                 text: account
                                              //                                     .accountNo,
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   color: Colors
                                              //                                       .black54,
                                              //                                 ),
                                              //                               ),
                                              //                             ],
                                              //                           ),
                                              //                         ),
                                              //                         SizedBox(height: 6),
                                              //
                                              //                         RichText(
                                              //                           text: TextSpan(
                                              //                             children: [
                                              //                               TextSpan(
                                              //                                 text: 'Email: ',
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   fontWeight:
                                              //                                   FontWeight
                                              //                                       .bold,
                                              //                                   color: Colors
                                              //                                       .black87,
                                              //                                 ),
                                              //                               ),
                                              //                               TextSpan(
                                              //                                 text: account
                                              //                                     .email,
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   color: Colors
                                              //                                       .black54,
                                              //                                 ),
                                              //                               ),
                                              //                             ],
                                              //                           ),
                                              //                         ),
                                              //                         SizedBox(height: 6),
                                              //
                                              //                         RichText(
                                              //                           text: TextSpan(
                                              //                             children: [
                                              //                               TextSpan(
                                              //                                 text:
                                              //                                 'Phone No: ',
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   fontWeight:
                                              //                                   FontWeight
                                              //                                       .bold,
                                              //                                   color: Colors
                                              //                                       .black87,
                                              //                                 ),
                                              //                               ),
                                              //                               TextSpan(
                                              //                                 text: account
                                              //                                     .phoneNo,
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   color: Colors
                                              //                                       .black54,
                                              //                                 ),
                                              //                               ),
                                              //                             ],
                                              //                           ),
                                              //                         ),
                                              //
                                              //                         SizedBox(height: 20),
                                              //
                                              //                         DropdownMenu(
                                              //                           onSelected: (v) {},
                                              //                           expandedInsets:
                                              //                           EdgeInsets.zero,
                                              //                           requestFocusOnTap:
                                              //                           false,
                                              //                           label: Text(
                                              //                               'Select currency to pay'),
                                              //                           enableFilter: true,
                                              //                           enableSearch: true,
                                              //                           menuHeight: 150,
                                              //                           inputDecorationTheme:
                                              //                           InputDecorationTheme(
                                              //                             fillColor: AppColors
                                              //                                 .quinary,
                                              //                             filled: true,
                                              //                             contentPadding:
                                              //                             const EdgeInsets
                                              //                                 .only(
                                              //                                 left: 10),
                                              //                             border:
                                              //                             const OutlineInputBorder(
                                              //                               borderRadius:
                                              //                               BorderRadius
                                              //                                   .all(Radius
                                              //                                   .circular(
                                              //                                   5)),
                                              //                             ),
                                              //                           ),
                                              //                           menuStyle: MenuStyle(
                                              //                             // backgroundColor:
                                              //                             //     WidgetStateProperty
                                              //                             //         .all<Color>(
                                              //                             //   AppColors
                                              //                             //       .quarternary,
                                              //                             // ),
                                              //                           ),
                                              //                           dropdownMenuEntries:
                                              //                           account.currencies
                                              //                               .entries
                                              //                               .map((entry) {
                                              //                             return DropdownMenuEntry<
                                              //                                 String>(
                                              //                               style:
                                              //                               ButtonStyle(
                                              //                                 textStyle: WidgetStatePropertyAll(TextStyle(
                                              //                                     fontSize:
                                              //                                     15,
                                              //                                     fontWeight:
                                              //                                     FontWeight
                                              //                                         .w500)),
                                              //                                 padding: WidgetStateProperty
                                              //                                     .all(EdgeInsets
                                              //                                     .all(
                                              //                                     10)),
                                              //                                 foregroundColor:
                                              //                                 WidgetStatePropertyAll((entry.value
                                              //                                 as num) <
                                              //                                     0
                                              //                                     ? Colors
                                              //                                     .red
                                              //                                     : CupertinoColors
                                              //                                     .systemBlue),
                                              //                                 backgroundColor:
                                              //                                 WidgetStateProperty.all(
                                              //                                     AppColors
                                              //                                         .quinary),
                                              //                               ),
                                              //                               value: entry.key,
                                              //                               label: entry.key,
                                              //                             );
                                              //                           }).toList(),
                                              //                         ),
                                              //                         SizedBox(height: 6),
                                              //
                                              //                         TextFormField(
                                              //                           decoration:
                                              //                           InputDecoration(
                                              //                             hintText:
                                              //                             "Enter Amount",
                                              //                             border:
                                              //                             OutlineInputBorder(
                                              //                               borderRadius:
                                              //                               BorderRadius
                                              //                                   .circular(
                                              //                                   8),
                                              //                             ),
                                              //                           ),
                                              //                         ),
                                              //
                                              //                         SizedBox(height: 30),
                                              //
                                              //                         // Action Buttons: Cancel and Submit
                                              //                         Row(
                                              //                           mainAxisAlignment:
                                              //                           MainAxisAlignment
                                              //                               .end,
                                              //                           children: [
                                              //                             ElevatedButton(
                                              //                               style:
                                              //                               ElevatedButton
                                              //                                   .styleFrom(
                                              //                                 backgroundColor:
                                              //                                 AppColors
                                              //                                     .prettyDark,
                                              //                                 padding:
                                              //                                 const EdgeInsets
                                              //                                     .symmetric(
                                              //                                   horizontal:
                                              //                                   20,
                                              //                                   vertical: 12,
                                              //                                 ),
                                              //                                 shape:
                                              //                                 RoundedRectangleBorder(
                                              //                                   borderRadius:
                                              //                                   BorderRadius
                                              //                                       .circular(
                                              //                                       12),
                                              //                                 ),
                                              //                                 foregroundColor:
                                              //                                 Colors
                                              //                                     .grey

                                              //                                 textStyle:
                                              //                                 TextStyle(
                                              //                                     fontSize:
                                              //                                     16),
                                              //                               ),
                                              //                               onPressed: () {
                                              //                                 Navigator.of(
                                              //                                     context)
                                              //                                     .pop(); // Close dialog
                                              //                               },
                                              //                               child: Text(
                                              //                                   "Cancel"),
                                              //                             ),
                                              //                             SizedBox(width: 10),
                                              //                             ElevatedButton(
                                              //                               style:
                                              //                               ElevatedButton
                                              //                                   .styleFrom(
                                              //                                 backgroundColor:
                                              //                                 AppColors
                                              //                                     .prettyDark,
                                              //                                 padding:
                                              //                                 const EdgeInsets
                                              //                                     .symmetric(
                                              //                                   horizontal:
                                              //                                   20,
                                              //                                   vertical: 12,
                                              //                                 ),
                                              //                                 shape:
                                              //                                 RoundedRectangleBorder(
                                              //                                   borderRadius:
                                              //                                   BorderRadius
                                              //                                       .circular(
                                              //                                       12),
                                              //                                 ),
                                              //                                 foregroundColor:
                                              //                                 Colors
                                              //                                     .grey

                                              //                                 textStyle:
                                              //                                 TextStyle(
                                              //                                     fontSize:
                                              //                                     16),
                                              //                               ),
                                              //                               onPressed: () {
                                              //                                 Navigator.of(
                                              //                                     context)
                                              //                                     .pop(); // Close dialog
                                              //                               },
                                              //                               child: Text(
                                              //                                   "  Add  "),
                                              //                             ),
                                              //                           ],
                                              //                         ),
                                              //                       ],
                                              //                     ),
                                              //                   ),
                                              //                 );
                                              //               },
                                              //             );
                                              //           },
                                              //           child: Text(
                                              //             "Pay",
                                              //             style: TextStyle(fontSize: 15),
                                              //           ),
                                              //         ),
                                              //         PopupMenuItem(
                                              //           ///Todo: implement New receive backend
                                              //
                                              //           onTap: () {
                                              //             showDialog(
                                              //               context: context,
                                              //               builder: (context) {
                                              //                 return Dialog(
                                              //                   backgroundColor:
                                              //                   AppColors.quarternary,
                                              //                   insetPadding:
                                              //                   EdgeInsets.symmetric(
                                              //                       horizontal: 15,
                                              //                       vertical: 10),
                                              //                   shape: RoundedRectangleBorder(
                                              //                     borderRadius:
                                              //                     BorderRadius.circular(
                                              //                         15),
                                              //                   ),
                                              //                   child: Padding(
                                              //                     padding:
                                              //                     EdgeInsets.all(15.0),
                                              //                     child: Column(
                                              //                       mainAxisSize:
                                              //                       MainAxisSize.min,
                                              //                       crossAxisAlignment:
                                              //                       CrossAxisAlignment
                                              //                           .start,
                                              //                       children: [
                                              //                         // Dialog Title
                                              //                         Text(
                                              //                           "Receive deposit",
                                              //                           style: TextStyle(
                                              //                             fontSize: 22,
                                              //                             fontWeight:
                                              //                             FontWeight.w600,
                                              //                             color: Colors
                                              //                                 .blueAccent,
                                              //                           ),
                                              //                         ),
                                              //                         SizedBox(height: 8),
                                              //                         Divider(
                                              //                             thickness: 1,
                                              //                             color:
                                              //                             Colors.black12),
                                              //
                                              //                         SizedBox(height: 20),
                                              //
                                              //                         // Account Details
                                              //                         Text(
                                              //                           account.fullName,
                                              //                           style: TextStyle(
                                              //                             fontSize: 18,
                                              //                             fontWeight:
                                              //                             FontWeight.bold,
                                              //                             color:
                                              //                             Colors.black87,
                                              //                           ),
                                              //                         ),
                                              //                         SizedBox(height: 12),
                                              //
                                              //                         RichText(
                                              //                           text: TextSpan(
                                              //                             children: [
                                              //                               TextSpan(
                                              //                                 text:
                                              //                                 'Account No: ',
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   fontWeight:
                                              //                                   FontWeight
                                              //                                       .bold,
                                              //                                   color: Colors
                                              //                                       .black87,
                                              //                                 ),
                                              //                               ),
                                              //                               TextSpan(
                                              //                                 text: account
                                              //                                     .accountNo,
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   color: Colors
                                              //                                       .black54,
                                              //                                 ),
                                              //                               ),
                                              //                             ],
                                              //                           ),
                                              //                         ),
                                              //                         SizedBox(height: 6),
                                              //
                                              //                         RichText(
                                              //                           text: TextSpan(
                                              //                             children: [
                                              //                               TextSpan(
                                              //                                 text: 'Email: ',
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   fontWeight:
                                              //                                   FontWeight
                                              //                                       .bold,
                                              //                                   color: Colors
                                              //                                       .black87,
                                              //                                 ),
                                              //                               ),
                                              //                               TextSpan(
                                              //                                 text: account
                                              //                                     .email,
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   color: Colors
                                              //                                       .black54,
                                              //                                 ),
                                              //                               ),
                                              //                             ],
                                              //                           ),
                                              //                         ),
                                              //                         SizedBox(height: 6),
                                              //
                                              //                         RichText(
                                              //                           text: TextSpan(
                                              //                             children: [
                                              //                               TextSpan(
                                              //                                 text:
                                              //                                 'Phone No: ',
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   fontWeight:
                                              //                                   FontWeight
                                              //                                       .bold,
                                              //                                   color: Colors
                                              //                                       .black87,
                                              //                                 ),
                                              //                               ),
                                              //                               TextSpan(
                                              //                                 text: account
                                              //                                     .phoneNo,
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   color: Colors
                                              //                                       .black54,
                                              //                                 ),
                                              //                               ),
                                              //                             ],
                                              //                           ),
                                              //                         ),
                                              //
                                              //                         SizedBox(height: 20),
                                              //
                                              //                         DropdownMenu(
                                              //                           onSelected: (v) {},
                                              //                           expandedInsets:
                                              //                           EdgeInsets.zero,
                                              //                           requestFocusOnTap:
                                              //                           false,
                                              //                           label: Text(
                                              //                               'Select currency to pay'),
                                              //                           enableFilter: true,
                                              //                           enableSearch: true,
                                              //                           menuHeight: 150,
                                              //                           inputDecorationTheme:
                                              //                           InputDecorationTheme(
                                              //                             fillColor: AppColors
                                              //                                 .quinary,
                                              //                             filled: true,
                                              //                             contentPadding:
                                              //                             const EdgeInsets
                                              //                                 .only(
                                              //                                 left: 10),
                                              //                             border:
                                              //                             const OutlineInputBorder(
                                              //                               borderRadius:
                                              //                               BorderRadius
                                              //                                   .all(Radius
                                              //                                   .circular(
                                              //                                   5)),
                                              //                             ),
                                              //                           ),
                                              //                           menuStyle: MenuStyle(
                                              //                             // backgroundColor:
                                              //                             //     WidgetStateProperty
                                              //                             //         .all<Color>(
                                              //                             //   AppColors
                                              //                             //       .quarternary,
                                              //                             // ),
                                              //                           ),
                                              //                           dropdownMenuEntries:
                                              //                           account.currencies
                                              //                               .entries
                                              //                               .map((entry) {
                                              //                             return DropdownMenuEntry<
                                              //                                 String>(
                                              //                               style:
                                              //                               ButtonStyle(
                                              //                                 textStyle: WidgetStatePropertyAll(TextStyle(
                                              //                                     fontSize:
                                              //                                     15,
                                              //                                     fontWeight:
                                              //                                     FontWeight
                                              //                                         .w500)),
                                              //                                 padding: WidgetStateProperty
                                              //                                     .all(EdgeInsets
                                              //                                     .all(
                                              //                                     10)),
                                              //                                 foregroundColor:
                                              //                                 WidgetStatePropertyAll((entry.value
                                              //                                 as num) <
                                              //                                     0
                                              //                                     ? Colors
                                              //                                     .red
                                              //                                     : CupertinoColors
                                              //                                     .systemBlue),
                                              //                                 backgroundColor:
                                              //                                 WidgetStateProperty.all(
                                              //                                     AppColors
                                              //                                         .quinary),
                                              //                               ),
                                              //                               value: entry.key,
                                              //                               label: entry.key,
                                              //                             );
                                              //                           }).toList(),
                                              //                         ),
                                              //                         SizedBox(height: 6),
                                              //
                                              //                         TextFormField(
                                              //                           decoration:
                                              //                           InputDecoration(
                                              //                             hintText:
                                              //                             "Enter Amount",
                                              //                             border:
                                              //                             OutlineInputBorder(
                                              //                               borderRadius:
                                              //                               BorderRadius
                                              //                                   .circular(
                                              //                                   8),
                                              //                             ),
                                              //                           ),
                                              //                         ),
                                              //
                                              //                         SizedBox(height: 30),
                                              //
                                              //                         // Action Buttons: Cancel and Submit
                                              //                         Row(
                                              //                           mainAxisAlignment:
                                              //                           MainAxisAlignment
                                              //                               .end,
                                              //                           children: [
                                              //                             ElevatedButton(
                                              //                               style:
                                              //                               ElevatedButton
                                              //                                   .styleFrom(
                                              //                                 backgroundColor:
                                              //                                 AppColors
                                              //                                     .prettyDark,
                                              //                                 padding:
                                              //                                 const EdgeInsets
                                              //                                     .symmetric(
                                              //                                   horizontal:
                                              //                                   20,
                                              //                                   vertical: 12,
                                              //                                 ),
                                              //                                 shape:
                                              //                                 RoundedRectangleBorder(
                                              //                                   borderRadius:
                                              //                                   BorderRadius
                                              //                                       .circular(
                                              //                                       12),
                                              //                                 ),
                                              //                                 foregroundColor:
                                              //                                 Colors
                                              //                                     .grey

                                              //                                 textStyle:
                                              //                                 TextStyle(
                                              //                                     fontSize:
                                              //                                     16),
                                              //                               ),
                                              //                               onPressed: () {
                                              //                                 Navigator.of(
                                              //                                     context)
                                              //                                     .pop(); // Close dialog
                                              //                               },
                                              //                               child: Text(
                                              //                                   "Cancel"),
                                              //                             ),
                                              //                             SizedBox(width: 10),
                                              //                             ElevatedButton(
                                              //                               style:
                                              //                               ElevatedButton
                                              //                                   .styleFrom(
                                              //                                 backgroundColor:
                                              //                                 AppColors
                                              //                                     .prettyDark,
                                              //                                 padding:
                                              //                                 const EdgeInsets
                                              //                                     .symmetric(
                                              //                                   horizontal:
                                              //                                   20,
                                              //                                   vertical: 12,
                                              //                                 ),
                                              //                                 shape:
                                              //                                 RoundedRectangleBorder(
                                              //                                   borderRadius:
                                              //                                   BorderRadius
                                              //                                       .circular(
                                              //                                       12),
                                              //                                 ),
                                              //                                 foregroundColor:
                                              //                                 Colors
                                              //                                     .grey

                                              //                                 textStyle:
                                              //                                 TextStyle(
                                              //                                     fontSize:
                                              //                                     16),
                                              //                               ),
                                              //                               onPressed: () {
                                              //                                 Navigator.of(
                                              //                                     context)
                                              //                                     .pop(); // Close dialog
                                              //                               },
                                              //                               child: Text(
                                              //                                   "  Add  "),
                                              //                             ),
                                              //                           ],
                                              //                         ),
                                              //                       ],
                                              //                     ),
                                              //                   ),
                                              //                 );
                                              //               },
                                              //             );
                                              //           },
                                              //
                                              //           child: Text(
                                              //             "Receive",
                                              //             style: TextStyle(fontSize: 15),
                                              //           ),
                                              //         ),
                                              //         PopupMenuItem(
                                              //           ///Todo: implement New currency popup
                                              //           onTap: () {
                                              //             showDialog(
                                              //               context: context,
                                              //               builder: (context) {
                                              //                 return Dialog(
                                              //                   backgroundColor:
                                              //                   AppColors.quarternary,
                                              //                   insetPadding:
                                              //                   EdgeInsets.symmetric(
                                              //                       horizontal: 15,
                                              //                       vertical: 10),
                                              //                   shape: RoundedRectangleBorder(
                                              //                     borderRadius:
                                              //                     BorderRadius.circular(
                                              //                         15),
                                              //                   ),
                                              //                   child: Padding(
                                              //                     padding:
                                              //                     EdgeInsets.all(15.0),
                                              //                     child: Column(
                                              //                       mainAxisSize:
                                              //                       MainAxisSize.min,
                                              //                       crossAxisAlignment:
                                              //                       CrossAxisAlignment
                                              //                           .start,
                                              //                       children: [
                                              //                         // Dialog Title
                                              //                         Text(
                                              //                           "Add new currency",
                                              //                           style: TextStyle(
                                              //                             fontSize: 22,
                                              //                             fontWeight:
                                              //                             FontWeight.w600,
                                              //                             color: Colors
                                              //                                 .blueAccent,
                                              //                           ),
                                              //                         ),
                                              //                         SizedBox(height: 8),
                                              //                         Divider(
                                              //                             thickness: 1,
                                              //                             color:
                                              //                             Colors.black12),
                                              //
                                              //                         SizedBox(height: 20),
                                              //
                                              //                         // Account Details
                                              //                         Text(
                                              //                           account.fullName,
                                              //                           style: TextStyle(
                                              //                             fontSize: 18,
                                              //                             fontWeight:
                                              //                             FontWeight.bold,
                                              //                             color:
                                              //                             Colors.black87,
                                              //                           ),
                                              //                         ),
                                              //                         SizedBox(height: 12),
                                              //
                                              //                         RichText(
                                              //                           text: TextSpan(
                                              //                             children: [
                                              //                               TextSpan(
                                              //                                 text:
                                              //                                 'Account No: ',
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   fontWeight:
                                              //                                   FontWeight
                                              //                                       .bold,
                                              //                                   color: Colors
                                              //                                       .black87,
                                              //                                 ),
                                              //                               ),
                                              //                               TextSpan(
                                              //                                 text: account
                                              //                                     .accountNo,
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   color: Colors
                                              //                                       .black54,
                                              //                                 ),
                                              //                               ),
                                              //                             ],
                                              //                           ),
                                              //                         ),
                                              //                         SizedBox(height: 6),
                                              //
                                              //                         RichText(
                                              //                           text: TextSpan(
                                              //                             children: [
                                              //                               TextSpan(
                                              //                                 text: 'Email: ',
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   fontWeight:
                                              //                                   FontWeight
                                              //                                       .bold,
                                              //                                   color: Colors
                                              //                                       .black87,
                                              //                                 ),
                                              //                               ),
                                              //                               TextSpan(
                                              //                                 text: account
                                              //                                     .email,
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   color: Colors
                                              //                                       .black54,
                                              //                                 ),
                                              //                               ),
                                              //                             ],
                                              //                           ),
                                              //                         ),
                                              //                         SizedBox(height: 6),
                                              //
                                              //                         RichText(
                                              //                           text: TextSpan(
                                              //                             children: [
                                              //                               TextSpan(
                                              //                                 text:
                                              //                                 'Phone No: ',
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   fontWeight:
                                              //                                   FontWeight
                                              //                                       .bold,
                                              //                                   color: Colors
                                              //                                       .black87,
                                              //                                 ),
                                              //                               ),
                                              //                               TextSpan(
                                              //                                 text: account
                                              //                                     .phoneNo,
                                              //                                 style:
                                              //                                 TextStyle(
                                              //                                   fontSize: 14,
                                              //                                   color: Colors
                                              //                                       .black54,
                                              //                                 ),
                                              //                               ),
                                              //                             ],
                                              //                           ),
                                              //                         ),
                                              //
                                              //                         SizedBox(height: 20),
                                              //
                                              //                         DropdownMenu(
                                              //                           onSelected: (v) {},
                                              //                           expandedInsets:
                                              //                           EdgeInsets.zero,
                                              //                           requestFocusOnTap:
                                              //                           false,
                                              //                           label: Text(
                                              //                               'Select currency to pay'),
                                              //                           enableFilter: true,
                                              //                           enableSearch: true,
                                              //                           menuHeight: 150,
                                              //                           inputDecorationTheme:
                                              //                           InputDecorationTheme(
                                              //                             fillColor: AppColors
                                              //                                 .quinary,
                                              //                             filled: true,
                                              //                             contentPadding:
                                              //                             const EdgeInsets
                                              //                                 .only(
                                              //                                 left: 10),
                                              //                             border:
                                              //                             const OutlineInputBorder(
                                              //                               borderRadius:
                                              //                               BorderRadius
                                              //                                   .all(Radius
                                              //                                   .circular(
                                              //                                   5)),
                                              //                             ),
                                              //                           ),
                                              //                           menuStyle: MenuStyle(
                                              //                             // backgroundColor:
                                              //                             //     WidgetStateProperty
                                              //                             //         .all<Color>(
                                              //                             //   AppColors
                                              //                             //       .quarternary,
                                              //                             // ),
                                              //                           ),
                                              //                           dropdownMenuEntries:
                                              //                           account.currencies
                                              //                               .entries
                                              //                               .map((entry) {
                                              //                             return DropdownMenuEntry<
                                              //                                 String>(
                                              //                               style:
                                              //                               ButtonStyle(
                                              //                                 textStyle: WidgetStatePropertyAll(TextStyle(
                                              //                                     fontSize:
                                              //                                     15,
                                              //                                     fontWeight:
                                              //                                     FontWeight
                                              //                                         .w500)),
                                              //                                 padding: WidgetStateProperty
                                              //                                     .all(EdgeInsets
                                              //                                     .all(
                                              //                                     10)),
                                              //                                 foregroundColor:
                                              //                                 WidgetStatePropertyAll((entry.value
                                              //                                 as num) <
                                              //                                     0
                                              //                                     ? Colors
                                              //                                     .red
                                              //                                     : CupertinoColors
                                              //                                     .systemBlue),
                                              //                                 backgroundColor:
                                              //                                 WidgetStateProperty.all(
                                              //                                     AppColors
                                              //                                         .quinary),
                                              //                               ),
                                              //                               value: entry.key,
                                              //                               label: entry.key,
                                              //                             );
                                              //                           }).toList(),
                                              //                         ),
                                              //
                                              //                         SizedBox(height: 30),
                                              //
                                              //                         // Action Buttons: Cancel and Submit
                                              //                         Row(
                                              //                           mainAxisAlignment:
                                              //                           MainAxisAlignment
                                              //                               .end,
                                              //                           children: [
                                              //                             ElevatedButton(
                                              //                               style:
                                              //                               ElevatedButton
                                              //                                   .styleFrom(
                                              //                                 backgroundColor:
                                              //                                 AppColors
                                              //                                     .prettyDark,
                                              //                                 padding:
                                              //                                 const EdgeInsets
                                              //                                     .symmetric(
                                              //                                   horizontal:
                                              //                                   20,
                                              //                                   vertical: 12,
                                              //                                 ),
                                              //                                 shape:
                                              //                                 RoundedRectangleBorder(
                                              //                                   borderRadius:
                                              //                                   BorderRadius
                                              //                                       .circular(
                                              //                                       12),
                                              //                                 ),
                                              //                                 foregroundColor:
                                              //                                 Colors
                                              //                                     .grey

                                              //                                 textStyle:
                                              //                                 TextStyle(
                                              //                                     fontSize:
                                              //                                     16),
                                              //                               ),
                                              //                               onPressed: () {
                                              //                                 Navigator.of(
                                              //                                     context)
                                              //                                     .pop(); // Close dialog
                                              //                               },
                                              //                               child: Text(
                                              //                                   "Cancel"),
                                              //                             ),
                                              //                             SizedBox(width: 10),
                                              //                             ElevatedButton(
                                              //                               style:
                                              //                               ElevatedButton
                                              //                                   .styleFrom(
                                              //                                 backgroundColor:
                                              //                                 AppColors
                                              //                                     .prettyDark,
                                              //                                 padding:
                                              //                                 const EdgeInsets
                                              //                                     .symmetric(
                                              //                                   horizontal:
                                              //                                   20,
                                              //                                   vertical: 12,
                                              //                                 ),
                                              //                                 shape:
                                              //                                 RoundedRectangleBorder(
                                              //                                   borderRadius:
                                              //                                   BorderRadius
                                              //                                       .circular(
                                              //                                       12),
                                              //                                 ),
                                              //                                 foregroundColor:
                                              //                                 Colors
                                              //                                     .grey

                                              //                                 textStyle:
                                              //                                 TextStyle(
                                              //                                     fontSize:
                                              //                                     16),
                                              //                               ),
                                              //                               onPressed: () {
                                              //                                 Navigator.of(
                                              //                                     context)
                                              //                                     .pop(); // Close dialog
                                              //                               },
                                              //                               child: Text(
                                              //                                   "  Add  "),
                                              //                             ),
                                              //                           ],
                                              //                         ),
                                              //                       ],
                                              //                     ),
                                              //                   ),
                                              //                 );
                                              //               },
                                              //             );
                                              //           },
                                              //
                                              //           child: Text(
                                              //             "New currency",
                                              //             style: TextStyle(fontSize: 15),
                                              //           ),
                                              //         ),
                                              //         PopupMenuItem(
                                              //           child: Text(
                                              //             "Edit info",
                                              //             style: TextStyle(fontSize: 15),
                                              //           ),
                                              //         ),
                                              //       ]);
                                              // },
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
                                                                    text: payment.receiver,
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
                                                                    text: payment.transactionType,
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
                                                                    text: payment.transactionId,
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
                                                                text: DateFormat("dd MMM yyyy HH:mm").format(payment.dateCreated),
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
                                    length: 3,
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
                                          Tab(
                                            child: Text('Transfers'),
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
                                          Padding(
                                            padding: const EdgeInsets.only(top: 6.0),
                                            child: Obx(
                                              () {
                                                if (controller.transfers.isEmpty) {
                                                  return Text('Once created, Transfers will appear here');
                                                }
                                                return ListView.builder(
                                                  physics: ClampingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: controller.transfers.length,
                                                  itemBuilder: (context, index) {
                                                    final TransferModel transfer = controller.transfers[index];
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
                                                                              text: 'Transferred to: ',
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 10,
                                                                                color: Colors.grey[600],
                                                                              ),
                                                                            ),
                                                                            TextSpan(
                                                                              text: transfer.receiver,
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
                                                                          text: '${transfer.currency}: ',
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            // fontSize: 12,
                                                                            fontSize: 10,
                                                                            color: Colors.grey[600], // Grey Label
                                                                          ),
                                                                        ),
                                                                        TextSpan(
                                                                          text: formatter
                                                                              .format(transfer.amount)
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
                                                                              text: transfer.transactionType,
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
                                                                              text: transfer.transactionId,
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
                                                                          text: DateFormat("dd MMM yyyy HH:mm").format(transfer.dateCreated),
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
                    ),
                    const Gap(10),
                    Text(
                      "Client accounts",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    FirestoreListView<AccountModel>(
                      reverse: true,
                      shrinkWrap: true,
                      // physics: ClampingScrollPhysics(),
                      query: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).collection('accounts').withConverter<AccountModel>(
                            fromFirestore: (snapshot, _) => AccountModel.fromJson(snapshot.data()!),
                            toFirestore: (account, _) => account.toJson(),
                          ),
                      itemBuilder: (context, snapshot) {
                        // Data is now typed!
                        AccountModel account = snapshot.data();

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
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
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Account name: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          TextSpan(
                                            text: account.accountName,
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
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: account.currencies.entries.map((entry) {
                                        return RichText(
                                            text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${entry.key}: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                // fontSize: 12,
                                                fontSize: 10,
                                                color: Colors.grey[600], // Grey Label
                                              ),
                                            ),
                                            TextSpan(
                                              text: formatter.format(
                                                double.tryParse(entry.value.toString()) ?? 0.0,
                                              ),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  // fontSize: 12,
                                                  fontSize: 10,
                                                  color: (double.tryParse(entry.value.toString()) ?? 0.0) <= 0 ? CupertinoColors.destructiveRed : CupertinoColors.systemBlue // Grey Label
                                                  ),
                                            ),
                                          ],
                                        ));
                                      }).toList(),
                                    ),
                                  ],
                                ),

                                Divider(color: Colors.grey[400], thickness: 1),

                                // Second Row (Transaction ID, Type, Date)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Account no: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                              color: Colors.grey[600], // Grey Label
                                            ),
                                          ),
                                          TextSpan(
                                            text: account.accountNo,
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
                                                // Black Value
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Date created: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                              color: Colors.grey[600], // Grey Label
                                            ),
                                          ),
                                          TextSpan(
                                            text: DateFormat('dd MMM yyy').format(
                                              account.dateCreated,
                                            ),
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
                    ),
                    Gap(30)
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
