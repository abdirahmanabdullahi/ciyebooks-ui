import 'package:ciyebooks/common/styles/custom_container.dart';
import 'package:ciyebooks/features/bank/deposit/model/deposit_model.dart';
import 'package:ciyebooks/features/bank/withdraw/model/withdraw_model.dart';
import 'package:ciyebooks/features/receive/model/receive_model.dart';
import 'package:ciyebooks/features/setup/controller/upload_controller.dart';

import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/validators/validation.dart';
import '../accounts/controller/accounts_controller.dart';
import '../accounts/model/model.dart';
import '../pay/models/expense_model.dart';
import '../pay/models/pay_client_model.dart';
import 'controller/setup_controller.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uploadController = Get.put(UploadController());
    final controller = Get.put(SetupController());
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    //Todo: Remove these,

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              FloatingActionButton(
                  child: Text('Log out'),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Account setup',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                      thickness: 2,
                      color: Colors.black,
                      height: 0,
                    ),
                    Gap(10),
                    ExpansionTile(
                      shape: Border(bottom: BorderSide.none, top: BorderSide.none),
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      title: Text(
                        'Totals',
                        style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                      ),
                      children: [
                        Obx(
                          () => InfoRow(
                            valueColor: CupertinoColors.black,
                            title: 'Shilling at bank',
                            value: ('controller.totals.value.shillingAtBank'),
                          ),
                        ),
                        Gap(10),
                        Divider(),
                        Gap(10),
                        Obx(
                          () => InfoRow(
                            valueColor: CupertinoColors.systemBlue,
                            title: 'Shilling cash balance',
                            value: formatter.format('controller.totals.value.shillingCashInHand'),
                          ),
                        ),
                        Gap(10),
                        Divider(),
                        Gap(10),
                        Obx(
                          () => InfoRow(
                            valueColor: CupertinoColors.systemBlue,
                            title: 'Shilling receivable',
                            value: ('controller.totals.value.shillingReceivable'),
                          ),
                        ),
                        Gap(10),
                        Divider(),
                        Gap(10),
                        Obx(
                          () => InfoRow(
                            valueColor: CupertinoColors.systemBlue,
                            title: 'Shilling payable',
                            value: ('controller.totals.value.shillingPayable'),
                          ),
                        ),
                        Gap(10),
                        Divider(
                          thickness: 2,
                          color: Colors.black,
                        ),
                        Gap(10),
                        Obx(
                          () => InfoRow(
                            valueColor: Color(0xff05a12e),
                            title: 'Dollar at bank',
                            value: ('controller.totals.value.dollarAtBank'),
                          ),
                        ),
                        Gap(10),
                        Divider(),
                        Gap(10),
                        Obx(
                          () => InfoRow(
                            valueColor: Color(0xff05a12e),
                            title: 'Dollar cash balance',
                            value: formatter.format('controller.totals.value.dollarCashInHand'),
                          ),
                        ),
                        Gap(10),
                        Divider(),
                        Gap(10),
                        Obx(
                          () => InfoRow(
                            valueColor: Color(0xff05a12e),
                            title: 'Dollar receivable',
                            value: ('controller.totals.value.dollarReceivable'),
                          ),
                        ),
                        Gap(10),
                        Divider(),
                        Gap(10),
                        Obx(
                          () => InfoRow(
                            valueColor: Color(0xff05a12e),
                            title: 'Dollar payable',
                            value: ('controller.totals.value.dollarPayable'),
                          ),
                        ),
                        Gap(10),
                      ],
                    ),
                    Divider(
                      height: 0,
                    ),
                    Gap(10),
                    Obx(
                      () => InfoRow(
                        valueColor: CupertinoColors.systemBlue,

                        // valueColor: CupertinoColors.systemBlue,
                        title: 'Cost of foreign currencies in hand ',
                        value: formatter.format(controller.totals.value.currenciesAtCost),
                      ),
                    ),
                    Gap(10),
                    Divider(),
                    Gap(10),
                    Obx(
                      () => InfoRow(
                          fontWeight: FontWeight.w700, fontSize: 17, valueColor: CupertinoColors.systemBlue, title: 'Working capital', value: formatter.format(controller.totals.value.workingCapital)),
                    ),
                    Gap(10), Divider(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // uploadController.uploadTotals(context);
                        },
                        child: const Text(
                          "Upload totals",
                          style: TextStyle(
                            color: AppColors.prettyDark,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    // uploadTotals
                    Divider(
                      thickness: 2,
                      color: Colors.black,
                    ),
                    ExpansionTile(
                      shape: Border(bottom: BorderSide.none, top: BorderSide.none),
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      title: Text(
                        'Accounts',
                        style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                      ),
                      children: [
                        Obx(
                          () {
                            if (controller.accounts.isEmpty) {
                              return Text('Once created, accounts will appear here');
                            }
                            return ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.accounts.length,
                              itemBuilder: (context, index) {
                                final AccountModel account = controller.accounts[index];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: CustomContainer(
                                    darkColor: AppColors.quinary,
                                    width: double.infinity,
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'Name: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 10,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '${account.firstName}${account.lastName}',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 13,
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
                                                        text: 'Phone no: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 10,
                                                          color: Colors.grey[600], // Grey Label
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: account.phoneNo,
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
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'USD: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 10,
                                                          color: Colors.grey[600], // Grey Label
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '''formatter
                                                            .format(account.usdBalance)'''

                                                            // text: payment.amountPaid
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 12,
                                                          // color: account.usdBalance < 0 ? Colors.redAccent : Colors.blue, // Grey Label
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
                                                        text: 'KES: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 10,
                                                          color: Colors.grey[600], // Grey Label
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '''formatter
                                                            .format(account.kesBalance)'''

                                                            // text: payment.amountPaid
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 12,
                                                          // color: account.kesBalance < 0 ? Colors.redAccent : Colors.blue, // Grey Label
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
                                        Divider(color: Colors.grey[400], thickness: 1),
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
                                                        text: 'REF: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 10,
                                                          color: Colors.grey[600], // Grey Label
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: account.accountNo,
                                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
                                                            // Black Value
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // RichText(
                                            //   text: TextSpan(
                                            //     children: [
                                            //       TextSpan(
                                            //         text: DateFormat("dd MMM yyyy HH:mm").format(
                                            //           account.dateCreated,
                                            //         ),
                                            //         style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
                                            //             // Black Value
                                            //             ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   dragStartBehavior: DragStartBehavior.start,
                                  //   onTapDown: (details) {
                                  //     final offset = details.globalPosition;
                                  //
                                  //     showMenu(
                                  //         color: AppColors.quinary,
                                  //         constraints: BoxConstraints.expand(
                                  //             width: 200, height: 200),
                                  //         context: context,
                                  //         position: RelativeRect.fromLTRB(
                                  //           offset.dx,
                                  //           offset.dy,
                                  //           MediaQuery.of(context).size.width -
                                  //               offset.dx,
                                  //           MediaQuery.of(context).size.height -
                                  //               offset.dy,
                                  //         ),
                                  //         items: [
                                  //           PopupMenuItem(
                                  //             ///Todo: implement pay client popup
                                  //             onTap: () {
                                  //               showDialog(
                                  //                 context: context,
                                  //                 builder: (context) {
                                  //                   return Dialog(
                                  //                     backgroundColor:
                                  //                         AppColors.quarternary,
                                  //                     insetPadding:
                                  //                         EdgeInsets.symmetric(
                                  //                             horizontal: 15,
                                  //                             vertical: 10),
                                  //                     shape:
                                  //                         RoundedRectangleBorder(
                                  //                       borderRadius:
                                  //                           BorderRadius
                                  //                               .circular(15),
                                  //                     ),
                                  //                     child: Padding(
                                  //                       padding: EdgeInsets.all(
                                  //                           15.0),
                                  //                       child: Column(
                                  //                         mainAxisSize:
                                  //                             MainAxisSize.min,
                                  //                         crossAxisAlignment:
                                  //                             CrossAxisAlignment
                                  //                                 .start,
                                  //                         children: [
                                  //                           // Dialog Title
                                  //                           Text(
                                  //                             "Pay Client",
                                  //                             style: TextStyle(
                                  //                               fontSize: 22,
                                  //                               fontWeight:
                                  //                                   FontWeight
                                  //                                       .w600,
                                  //                               color: Colors
                                  //                                   .blueAccent,
                                  //                             ),
                                  //                           ),
                                  //                           SizedBox(height: 8),
                                  //                           Divider(
                                  //                               thickness: 1,
                                  //                               color: Colors
                                  //                                   .black12),
                                  //
                                  //                           SizedBox(
                                  //                               height: 20),
                                  //
                                  //                           // Account Details
                                  //                           Text(
                                  //                             account.fullName,
                                  //                             style: TextStyle(
                                  //                               fontSize: 18,
                                  //                               fontWeight:
                                  //                                   FontWeight
                                  //                                       .bold,
                                  //                               color: Colors
                                  //                                   .black87,
                                  //                             ),
                                  //                           ),
                                  //                           SizedBox(
                                  //                               height: 12),
                                  //
                                  //                           RichText(
                                  //                             text: TextSpan(
                                  //                               children: [
                                  //                                 TextSpan(
                                  //                                   text:
                                  //                                       'Account No: ',
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     fontWeight:
                                  //                                         FontWeight
                                  //                                             .bold,
                                  //                                     color: Colors
                                  //                                         .black87,
                                  //                                   ),
                                  //                                 ),
                                  //                                 TextSpan(
                                  //                                   text: account
                                  //                                       .accountNo,
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     color: Colors
                                  //                                         .black54,
                                  //                                   ),
                                  //                                 ),
                                  //                               ],
                                  //                             ),
                                  //                           ),
                                  //                           SizedBox(height: 6),
                                  //
                                  //                           RichText(
                                  //                             text: TextSpan(
                                  //                               children: [
                                  //                                 TextSpan(
                                  //                                   text:
                                  //                                       'Email: ',
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     fontWeight:
                                  //                                         FontWeight
                                  //                                             .bold,
                                  //                                     color: Colors
                                  //                                         .black87,
                                  //                                   ),
                                  //                                 ),
                                  //                                 TextSpan(
                                  //                                   text: account
                                  //                                       .email,
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     color: Colors
                                  //                                         .black54,
                                  //                                   ),
                                  //                                 ),
                                  //                               ],
                                  //                             ),
                                  //                           ),
                                  //                           SizedBox(height: 6),
                                  //
                                  //                           RichText(
                                  //                             text: TextSpan(
                                  //                               children: [
                                  //                                 TextSpan(
                                  //                                   text:
                                  //                                       'Phone No: ',
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     fontWeight:
                                  //                                         FontWeight
                                  //                                             .bold,
                                  //                                     color: Colors
                                  //                                         .black87,
                                  //                                   ),
                                  //                                 ),
                                  //                                 TextSpan(
                                  //                                   text: account
                                  //                                       .phoneNo,
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     color: Colors
                                  //                                         .black54,
                                  //                                   ),
                                  //                                 ),
                                  //                               ],
                                  //                             ),
                                  //                           ),
                                  //
                                  //                           SizedBox(
                                  //                               height: 20),
                                  //
                                  //                           DropdownMenu(
                                  //                             onSelected:
                                  //                                 (v) {},
                                  //                             expandedInsets:
                                  //                                 EdgeInsets
                                  //                                     .zero,
                                  //                             requestFocusOnTap:
                                  //                                 false,
                                  //                             label: Text(
                                  //                                 'Select currency to pay'),
                                  //                             enableFilter:
                                  //                                 true,
                                  //                             enableSearch:
                                  //                                 true,
                                  //                             menuHeight: 150,
                                  //                             inputDecorationTheme:
                                  //                                 InputDecorationTheme(
                                  //                               fillColor:
                                  //                                   AppColors
                                  //                                       .quinary,
                                  //                               filled: true,
                                  //                               contentPadding:
                                  //                                   const EdgeInsets
                                  //                                       .only(
                                  //                                       left:
                                  //                                           10),
                                  //                               border:
                                  //                                   const OutlineInputBorder(
                                  //                                 borderRadius:
                                  //                                     BorderRadius.all(
                                  //                                         Radius.circular(
                                  //                                             5)),
                                  //                               ),
                                  //                             ),
                                  //                             menuStyle: MenuStyle(
                                  //                                 // backgroundColor:
                                  //                                 //     WidgetStateProperty
                                  //                                 //         .all<Color>(
                                  //                                 //   AppColors
                                  //                                 //       .quarternary,
                                  //                                 // ),
                                  //                                 ),
                                  //                             dropdownMenuEntries:
                                  //                                 account
                                  //                                     .currencies
                                  //                                     .entries
                                  //                                     .map(
                                  //                                         (entry) {
                                  //                               return DropdownMenuEntry<
                                  //                                   String>(
                                  //                                 style:
                                  //                                     ButtonStyle(
                                  //                                   textStyle: WidgetStatePropertyAll(TextStyle(
                                  //                                       fontSize:
                                  //                                           15,
                                  //                                       fontWeight:
                                  //                                           FontWeight.w500)),
                                  //                                   padding: WidgetStateProperty.all(
                                  //                                       EdgeInsets.all(
                                  //                                           10)),
                                  //                                   foregroundColor: WidgetStatePropertyAll((entry.value
                                  //                                               as num) <
                                  //                                           0
                                  //                                       ? Colors
                                  //                                           .red
                                  //                                       : CupertinoColors
                                  //                                           .systemBlue),
                                  //                                   backgroundColor:
                                  //                                       WidgetStateProperty.all(
                                  //                                           AppColors.quinary),
                                  //                                 ),
                                  //                                 value:
                                  //                                     entry.key,
                                  //                                 label:
                                  //                                     entry.key,
                                  //                               );
                                  //                             }).toList(),
                                  //                           ),
                                  //                           SizedBox(height: 6),
                                  //
                                  //                           TextFormField(
                                  //                             decoration:
                                  //                                 InputDecoration(
                                  //                               hintText:
                                  //                                   "Enter Amount",
                                  //                               border:
                                  //                                   OutlineInputBorder(
                                  //                                 borderRadius:
                                  //                                     BorderRadius
                                  //                                         .circular(
                                  //                                             8),
                                  //                               ),
                                  //                             ),
                                  //                           ),
                                  //
                                  //                           SizedBox(
                                  //                               height: 30),
                                  //
                                  //                           // Action Buttons: Cancel and Submit
                                  //                           Row(
                                  //                             mainAxisAlignment:
                                  //                                 MainAxisAlignment
                                  //                                     .end,
                                  //                             children: [
                                  //                               ElevatedButton(
                                  //                                 style: ElevatedButton
                                  //                                     .styleFrom(
                                  //                                   backgroundColor:
                                  //                                       AppColors
                                  //                                           .prettyDark,
                                  //                                   padding:
                                  //                                       const EdgeInsets
                                  //                                           .symmetric(
                                  //                                     horizontal:
                                  //                                         20,
                                  //                                     vertical:
                                  //                                         12,
                                  //                                   ),
                                  //                                   shape:
                                  //                                       RoundedRectangleBorder(
                                  //                                     borderRadius:
                                  //                                         BorderRadius.circular(
                                  //                                             12),
                                  //                                   ),
                                  //                                   foregroundColor:
                                  //                                       Colors
                                  //                                           .grey,
                                  //                                   textStyle: TextStyle(
                                  //                                       fontSize:
                                  //                                           16),
                                  //                                 ),
                                  //                                 onPressed:
                                  //                                     () {
                                  //                                   Navigator.of(
                                  //                                           context)
                                  //                                       .pop(); // Close dialog
                                  //                                 },
                                  //                                 child: Text(
                                  //                                     "Cancel"),
                                  //                               ),
                                  //                               SizedBox(
                                  //                                   width: 10),
                                  //                               ElevatedButton(
                                  //                                 style: ElevatedButton
                                  //                                     .styleFrom(
                                  //                                   backgroundColor:
                                  //                                       AppColors
                                  //                                           .prettyDark,
                                  //                                   padding:
                                  //                                       const EdgeInsets
                                  //                                           .symmetric(
                                  //                                     horizontal:
                                  //                                         20,
                                  //                                     vertical:
                                  //                                         12,
                                  //                                   ),
                                  //                                   shape:
                                  //                                       RoundedRectangleBorder(
                                  //                                     borderRadius:
                                  //                                         BorderRadius.circular(
                                  //                                             12),
                                  //                                   ),
                                  //                                   foregroundColor:
                                  //                                       Colors
                                  //                                           .grey,
                                  //                                   textStyle: TextStyle(
                                  //                                       fontSize:
                                  //                                           16),
                                  //                                 ),
                                  //                                 onPressed:
                                  //                                     () {
                                  //                                   Navigator.of(
                                  //                                           context)
                                  //                                       .pop(); // Close dialog
                                  //                                 },
                                  //                                 child: Text(
                                  //                                     "  Add  "),
                                  //                               ),
                                  //                             ],
                                  //                           ),
                                  //                         ],
                                  //                       ),
                                  //                     ),
                                  //                   );
                                  //                 },
                                  //               );
                                  //             },
                                  //             child: Text(
                                  //               "Pay",
                                  //               style: TextStyle(fontSize: 15),
                                  //             ),
                                  //           ),
                                  //           PopupMenuItem(
                                  //             ///Todo: implement New receive backend
                                  //
                                  //             onTap: () {
                                  //               showDialog(
                                  //                 context: context,
                                  //                 builder: (context) {
                                  //                   return Dialog(
                                  //                     backgroundColor:
                                  //                         AppColors.quarternary,
                                  //                     insetPadding:
                                  //                         EdgeInsets.symmetric(
                                  //                             horizontal: 15,
                                  //                             vertical: 10),
                                  //                     shape:
                                  //                         RoundedRectangleBorder(
                                  //                       borderRadius:
                                  //                           BorderRadius
                                  //                               .circular(15),
                                  //                     ),
                                  //                     child: Padding(
                                  //                       padding: EdgeInsets.all(
                                  //                           15.0),
                                  //                       child: Column(
                                  //                         mainAxisSize:
                                  //                             MainAxisSize.min,
                                  //                         crossAxisAlignment:
                                  //                             CrossAxisAlignment
                                  //                                 .start,
                                  //                         children: [
                                  //                           // Dialog Title
                                  //                           Text(
                                  //                             "Receive deposit",
                                  //                             style: TextStyle(
                                  //                               fontSize: 22,
                                  //                               fontWeight:
                                  //                                   FontWeight
                                  //                                       .w600,
                                  //                               color: Colors
                                  //                                   .blueAccent,
                                  //                             ),
                                  //                           ),
                                  //                           SizedBox(height: 8),
                                  //                           Divider(
                                  //                               thickness: 1,
                                  //                               color: Colors
                                  //                                   .black12),
                                  //
                                  //                           SizedBox(
                                  //                               height: 20),
                                  //
                                  //                           // Account Details
                                  //                           Text(
                                  //                             account.fullName,
                                  //                             style: TextStyle(
                                  //                               fontSize: 18,
                                  //                               fontWeight:
                                  //                                   FontWeight
                                  //                                       .bold,
                                  //                               color: Colors
                                  //                                   .black87,
                                  //                             ),
                                  //                           ),
                                  //                           SizedBox(
                                  //                               height: 12),
                                  //
                                  //                           RichText(
                                  //                             text: TextSpan(
                                  //                               children: [
                                  //                                 TextSpan(
                                  //                                   text:
                                  //                                       'Account No: ',
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     fontWeight:
                                  //                                         FontWeight
                                  //                                             .bold,
                                  //                                     color: Colors
                                  //                                         .black87,
                                  //                                   ),
                                  //                                 ),
                                  //                                 TextSpan(
                                  //                                   text: account
                                  //                                       .accountNo,
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     color: Colors
                                  //                                         .black54,
                                  //                                   ),
                                  //                                 ),
                                  //                               ],
                                  //                             ),
                                  //                           ),
                                  //                           SizedBox(height: 6),
                                  //
                                  //                           RichText(
                                  //                             text: TextSpan(
                                  //                               children: [
                                  //                                 TextSpan(
                                  //                                   text:
                                  //                                       'Email: ',
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     fontWeight:
                                  //                                         FontWeight
                                  //                                             .bold,
                                  //                                     color: Colors
                                  //                                         .black87,
                                  //                                   ),
                                  //                                 ),
                                  //                                 TextSpan(
                                  //                                   text: account
                                  //                                       .email,
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     color: Colors
                                  //                                         .black54,
                                  //                                   ),
                                  //                                 ),
                                  //                               ],
                                  //                             ),
                                  //                           ),
                                  //                           SizedBox(height: 6),
                                  //
                                  //                           RichText(
                                  //                             text: TextSpan(
                                  //                               children: [
                                  //                                 TextSpan(
                                  //                                   text:
                                  //                                       'Phone No: ',
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     fontWeight:
                                  //                                         FontWeight
                                  //                                             .bold,
                                  //                                     color: Colors
                                  //                                         .black87,
                                  //                                   ),
                                  //                                 ),
                                  //                                 TextSpan(
                                  //                                   text: account
                                  //                                       .phoneNo,
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     color: Colors
                                  //                                         .black54,
                                  //                                   ),
                                  //                                 ),
                                  //                               ],
                                  //                             ),
                                  //                           ),
                                  //
                                  //                           SizedBox(
                                  //                               height: 20),
                                  //
                                  //                           DropdownMenu(
                                  //                             onSelected:
                                  //                                 (v) {},
                                  //                             expandedInsets:
                                  //                                 EdgeInsets
                                  //                                     .zero,
                                  //                             requestFocusOnTap:
                                  //                                 false,
                                  //                             label: Text(
                                  //                                 'Select currency to pay'),
                                  //                             enableFilter:
                                  //                                 true,
                                  //                             enableSearch:
                                  //                                 true,
                                  //                             menuHeight: 150,
                                  //                             inputDecorationTheme:
                                  //                                 InputDecorationTheme(
                                  //                               fillColor:
                                  //                                   AppColors
                                  //                                       .quinary,
                                  //                               filled: true,
                                  //                               contentPadding:
                                  //                                   const EdgeInsets
                                  //                                       .only(
                                  //                                       left:
                                  //                                           10),
                                  //                               border:
                                  //                                   const OutlineInputBorder(
                                  //                                 borderRadius:
                                  //                                     BorderRadius.all(
                                  //                                         Radius.circular(
                                  //                                             5)),
                                  //                               ),
                                  //                             ),
                                  //                             menuStyle: MenuStyle(
                                  //                                 // backgroundColor:
                                  //                                 //     WidgetStateProperty
                                  //                                 //         .all<Color>(
                                  //                                 //   AppColors
                                  //                                 //       .quarternary,
                                  //                                 // ),
                                  //                                 ),
                                  //                             dropdownMenuEntries:
                                  //                                 account
                                  //                                     .currencies
                                  //                                     .entries
                                  //                                     .map(
                                  //                                         (entry) {
                                  //                               return DropdownMenuEntry<
                                  //                                   String>(
                                  //                                 style:
                                  //                                     ButtonStyle(
                                  //                                   textStyle: WidgetStatePropertyAll(TextStyle(
                                  //                                       fontSize:
                                  //                                           15,
                                  //                                       fontWeight:
                                  //                                           FontWeight.w500)),
                                  //                                   padding: WidgetStateProperty.all(
                                  //                                       EdgeInsets.all(
                                  //                                           10)),
                                  //                                   foregroundColor: WidgetStatePropertyAll((entry.value
                                  //                                               as num) <
                                  //                                           0
                                  //                                       ? Colors
                                  //                                           .red
                                  //                                       : CupertinoColors
                                  //                                           .systemBlue),
                                  //                                   backgroundColor:
                                  //                                       WidgetStateProperty.all(
                                  //                                           AppColors.quinary),
                                  //                                 ),
                                  //                                 value:
                                  //                                     entry.key,
                                  //                                 label:
                                  //                                     entry.key,
                                  //                               );
                                  //                             }).toList(),
                                  //                           ),
                                  //                           SizedBox(height: 6),
                                  //
                                  //                           TextFormField(
                                  //                             decoration:
                                  //                                 InputDecoration(
                                  //                               hintText:
                                  //                                   "Enter Amount",
                                  //                               border:
                                  //                                   OutlineInputBorder(
                                  //                                 borderRadius:
                                  //                                     BorderRadius
                                  //                                         .circular(
                                  //                                             8),
                                  //                               ),
                                  //                             ),
                                  //                           ),
                                  //
                                  //                           SizedBox(
                                  //                               height: 30),
                                  //
                                  //                           // Action Buttons: Cancel and Submit
                                  //                           Row(
                                  //                             mainAxisAlignment:
                                  //                                 MainAxisAlignment
                                  //                                     .end,
                                  //                             children: [
                                  //                               ElevatedButton(
                                  //                                 style: ElevatedButton
                                  //                                     .styleFrom(
                                  //                                   backgroundColor:
                                  //                                       AppColors
                                  //                                           .prettyDark,
                                  //                                   padding:
                                  //                                       const EdgeInsets
                                  //                                           .symmetric(
                                  //                                     horizontal:
                                  //                                         20,
                                  //                                     vertical:
                                  //                                         12,
                                  //                                   ),
                                  //                                   shape:
                                  //                                       RoundedRectangleBorder(
                                  //                                     borderRadius:
                                  //                                         BorderRadius.circular(
                                  //                                             12),
                                  //                                   ),
                                  //                                   foregroundColor:
                                  //                                       Colors
                                  //                                           .grey,
                                  //                                   textStyle: TextStyle(
                                  //                                       fontSize:
                                  //                                           16),
                                  //                                 ),
                                  //                                 onPressed:
                                  //                                     () {
                                  //                                   Navigator.of(
                                  //                                           context)
                                  //                                       .pop(); // Close dialog
                                  //                                 },
                                  //                                 child: Text(
                                  //                                     "Cancel"),
                                  //                               ),
                                  //                               SizedBox(
                                  //                                   width: 10),
                                  //                               ElevatedButton(
                                  //                                 style: ElevatedButton
                                  //                                     .styleFrom(
                                  //                                   backgroundColor:
                                  //                                       AppColors
                                  //                                           .prettyDark,
                                  //                                   padding:
                                  //                                       const EdgeInsets
                                  //                                           .symmetric(
                                  //                                     horizontal:
                                  //                                         20,
                                  //                                     vertical:
                                  //                                         12,
                                  //                                   ),
                                  //                                   shape:
                                  //                                       RoundedRectangleBorder(
                                  //                                     borderRadius:
                                  //                                         BorderRadius.circular(
                                  //                                             12),
                                  //                                   ),
                                  //                                   foregroundColor:
                                  //                                       Colors
                                  //                                           .grey,
                                  //                                   textStyle: TextStyle(
                                  //                                       fontSize:
                                  //                                           16),
                                  //                                 ),
                                  //                                 onPressed:
                                  //                                     () {
                                  //                                   Navigator.of(
                                  //                                           context)
                                  //                                       .pop(); // Close dialog
                                  //                                 },
                                  //                                 child: Text(
                                  //                                     "  Add  "),
                                  //                               ),
                                  //                             ],
                                  //                           ),
                                  //                         ],
                                  //                       ),
                                  //                     ),
                                  //                   );
                                  //                 },
                                  //               );
                                  //             },
                                  //
                                  //             child: Text(
                                  //               "Receive",
                                  //               style: TextStyle(fontSize: 15),
                                  //             ),
                                  //           ),
                                  //           PopupMenuItem(
                                  //             ///Todo: implement New currency popup
                                  //             onTap: () {
                                  //               showDialog(
                                  //                 context: context,
                                  //                 builder: (context) {
                                  //                   return Dialog(
                                  //                     backgroundColor:
                                  //                         AppColors.quarternary,
                                  //                     insetPadding:
                                  //                         EdgeInsets.symmetric(
                                  //                             horizontal: 15,
                                  //                             vertical: 10),
                                  //                     shape:
                                  //                         RoundedRectangleBorder(
                                  //                       borderRadius:
                                  //                           BorderRadius
                                  //                               .circular(15),
                                  //                     ),
                                  //                     child: Padding(
                                  //                       padding: EdgeInsets.all(
                                  //                           15.0),
                                  //                       child: Column(
                                  //                         mainAxisSize:
                                  //                             MainAxisSize.min,
                                  //                         crossAxisAlignment:
                                  //                             CrossAxisAlignment
                                  //                                 .start,
                                  //                         children: [
                                  //                           // Dialog Title
                                  //                           Text(
                                  //                             "Add new currency",
                                  //                             style: TextStyle(
                                  //                               fontSize: 22,
                                  //                               fontWeight:
                                  //                                   FontWeight
                                  //                                       .w600,
                                  //                               color: Colors
                                  //                                   .blueAccent,
                                  //                             ),
                                  //                           ),
                                  //                           SizedBox(height: 8),
                                  //                           Divider(
                                  //                               thickness: 1,
                                  //                               color: Colors
                                  //                                   .black12),
                                  //
                                  //                           SizedBox(
                                  //                               height: 20),
                                  //
                                  //                           // Account Details
                                  //                           Text(
                                  //                             account.fullName,
                                  //                             style: TextStyle(
                                  //                               fontSize: 18,
                                  //                               fontWeight:
                                  //                                   FontWeight
                                  //                                       .bold,
                                  //                               color: Colors
                                  //                                   .black87,
                                  //                             ),
                                  //                           ),
                                  //                           SizedBox(
                                  //                               height: 12),
                                  //
                                  //                           RichText(
                                  //                             text: TextSpan(
                                  //                               children: [
                                  //                                 TextSpan(
                                  //                                   text:
                                  //                                       'Account No: ',
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     fontWeight:
                                  //                                         FontWeight
                                  //                                             .bold,
                                  //                                     color: Colors
                                  //                                         .black87,
                                  //                                   ),
                                  //                                 ),
                                  //                                 TextSpan(
                                  //                                   text: account
                                  //                                       .accountNo,
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     color: Colors
                                  //                                         .black54,
                                  //                                   ),
                                  //                                 ),
                                  //                               ],
                                  //                             ),
                                  //                           ),
                                  //                           SizedBox(height: 6),
                                  //
                                  //                           RichText(
                                  //                             text: TextSpan(
                                  //                               children: [
                                  //                                 TextSpan(
                                  //                                   text:
                                  //                                       'Email: ',
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     fontWeight:
                                  //                                         FontWeight
                                  //                                             .bold,
                                  //                                     color: Colors
                                  //                                         .black87,
                                  //                                   ),
                                  //                                 ),
                                  //                                 TextSpan(
                                  //                                   text: account
                                  //                                       .email,
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     color: Colors
                                  //                                         .black54,
                                  //                                   ),
                                  //                                 ),
                                  //                               ],
                                  //                             ),
                                  //                           ),
                                  //                           SizedBox(height: 6),
                                  //
                                  //                           RichText(
                                  //                             text: TextSpan(
                                  //                               children: [
                                  //                                 TextSpan(
                                  //                                   text:
                                  //                                       'Phone No: ',
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     fontWeight:
                                  //                                         FontWeight
                                  //                                             .bold,
                                  //                                     color: Colors
                                  //                                         .black87,
                                  //                                   ),
                                  //                                 ),
                                  //                                 TextSpan(
                                  //                                   text: account
                                  //                                       .phoneNo,
                                  //                                   style:
                                  //                                       TextStyle(
                                  //                                     fontSize:
                                  //                                         14,
                                  //                                     color: Colors
                                  //                                         .black54,
                                  //                                   ),
                                  //                                 ),
                                  //                               ],
                                  //                             ),
                                  //                           ),
                                  //
                                  //                           SizedBox(
                                  //                               height: 20),
                                  //
                                  //                           DropdownMenu(
                                  //                             onSelected:
                                  //                                 (v) {},
                                  //                             expandedInsets:
                                  //                                 EdgeInsets
                                  //                                     .zero,
                                  //                             requestFocusOnTap:
                                  //                                 false,
                                  //                             label: Text(
                                  //                                 'Select currency to pay'),
                                  //                             enableFilter:
                                  //                                 true,
                                  //                             enableSearch:
                                  //                                 true,
                                  //                             menuHeight: 150,
                                  //                             inputDecorationTheme:
                                  //                                 InputDecorationTheme(
                                  //                               fillColor:
                                  //                                   AppColors
                                  //                                       .quinary,
                                  //                               filled: true,
                                  //                               contentPadding:
                                  //                                   const EdgeInsets
                                  //                                       .only(
                                  //                                       left:
                                  //                                           10),
                                  //                               border:
                                  //                                   const OutlineInputBorder(
                                  //                                 borderRadius:
                                  //                                     BorderRadius.all(
                                  //                                         Radius.circular(
                                  //                                             5)),
                                  //                               ),
                                  //                             ),
                                  //                             menuStyle: MenuStyle(
                                  //                                 // backgroundColor:
                                  //                                 //     WidgetStateProperty
                                  //                                 //         .all<Color>(
                                  //                                 //   AppColors
                                  //                                 //       .quarternary,
                                  //                                 // ),
                                  //                                 ),
                                  //                             dropdownMenuEntries:
                                  //                                 account
                                  //                                     .currencies
                                  //                                     .entries
                                  //                                     .map(
                                  //                                         (entry) {
                                  //                               return DropdownMenuEntry<
                                  //                                   String>(
                                  //                                 style:
                                  //                                     ButtonStyle(
                                  //                                   textStyle: WidgetStatePropertyAll(TextStyle(
                                  //                                       fontSize:
                                  //                                           15,
                                  //                                       fontWeight:
                                  //                                           FontWeight.w500)),
                                  //                                   padding: WidgetStateProperty.all(
                                  //                                       EdgeInsets.all(
                                  //                                           10)),
                                  //                                   foregroundColor: WidgetStatePropertyAll((entry.value
                                  //                                               as num) <
                                  //                                           0
                                  //                                       ? Colors
                                  //                                           .red
                                  //                                       : CupertinoColors
                                  //                                           .systemBlue),
                                  //                                   backgroundColor:
                                  //                                       WidgetStateProperty.all(
                                  //                                           AppColors.quinary),
                                  //                                 ),
                                  //                                 value:
                                  //                                     entry.key,
                                  //                                 label:
                                  //                                     entry.key,
                                  //                               );
                                  //                             }).toList(),
                                  //                           ),
                                  //
                                  //                           SizedBox(
                                  //                               height: 30),
                                  //
                                  //                           // Action Buttons: Cancel and Submit
                                  //                           Row(
                                  //                             mainAxisAlignment:
                                  //                                 MainAxisAlignment
                                  //                                     .end,
                                  //                             children: [
                                  //                               ElevatedButton(
                                  //                                 style: ElevatedButton
                                  //                                     .styleFrom(
                                  //                                   backgroundColor:
                                  //                                       AppColors
                                  //                                           .prettyDark,
                                  //                                   padding:
                                  //                                       const EdgeInsets
                                  //                                           .symmetric(
                                  //                                     horizontal:
                                  //                                         20,
                                  //                                     vertical:
                                  //                                         12,
                                  //                                   ),
                                  //                                   shape:
                                  //                                       RoundedRectangleBorder(
                                  //                                     borderRadius:
                                  //                                         BorderRadius.circular(
                                  //                                             12),
                                  //                                   ),
                                  //                                   foregroundColor:
                                  //                                       Colors
                                  //                                           .grey,
                                  //                                   textStyle: TextStyle(
                                  //                                       fontSize:
                                  //                                           16),
                                  //                                 ),
                                  //                                 onPressed:
                                  //                                     () {
                                  //                                   Navigator.of(
                                  //                                           context)
                                  //                                       .pop(); // Close dialog
                                  //                                 },
                                  //                                 child: Text(
                                  //                                     "Cancel"),
                                  //                               ),
                                  //                               SizedBox(
                                  //                                   width: 10),
                                  //                               ElevatedButton(
                                  //                                 style: ElevatedButton
                                  //                                     .styleFrom(
                                  //                                   backgroundColor:
                                  //                                       AppColors
                                  //                                           .prettyDark,
                                  //                                   padding:
                                  //                                       const EdgeInsets
                                  //                                           .symmetric(
                                  //                                     horizontal:
                                  //                                         20,
                                  //                                     vertical:
                                  //                                         12,
                                  //                                   ),
                                  //                                   shape:
                                  //                                       RoundedRectangleBorder(
                                  //                                     borderRadius:
                                  //                                         BorderRadius.circular(
                                  //                                             12),
                                  //                                   ),
                                  //                                   foregroundColor:
                                  //                                       Colors
                                  //                                           .grey,
                                  //                                   textStyle: TextStyle(
                                  //                                       fontSize:
                                  //                                           16),
                                  //                                 ),
                                  //                                 onPressed:
                                  //                                     () {
                                  //                                   Navigator.of(
                                  //                                           context)
                                  //                                       .pop(); // Close dialog
                                  //                                 },
                                  //                                 child: Text(
                                  //                                     "  Add  "),
                                  //                               ),
                                  //                             ],
                                  //                           ),
                                  //                         ],
                                  //                       ),
                                  //                     ),
                                  //                   );
                                  //                 },
                                  //               );
                                  //             },
                                  //
                                  //             child: Text(
                                  //               "New currency",
                                  //               style: TextStyle(fontSize: 15),
                                  //             ),
                                  //           ),
                                  //           PopupMenuItem(
                                  //             child: Text(
                                  //               "Edit info",
                                  //               style: TextStyle(fontSize: 15),
                                  //             ),
                                  //           ),
                                  //         ]);
                                  //   },
                                  //   child: CustomContainer(
                                  //     width: double.infinity,
                                  //     padding: EdgeInsets.all(10),
                                  //     darkColor: AppColors.quinary,
                                  //     child: Row(
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.spaceBetween,
                                  //       children: [
                                  //         Column(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.start,
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.start,
                                  //           children: [
                                  //             Text(
                                  //               account.fullName,
                                  //               style: TextStyle(
                                  //                   fontSize: 15,
                                  //                   fontWeight:
                                  //                       FontWeight.bold),
                                  //             ),
                                  //             Text(
                                  //               account.accountNo,
                                  //               style: TextStyle(
                                  //                   fontSize: 12,
                                  //                   color: Colors.purple),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //         Column(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.spaceEvenly,
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.end,
                                  //           children: account.currencies.entries
                                  //               .map((entry) {
                                  //             return Text(
                                  //               '${entry.key}: ${(entry.value is num) ? formatter.format(entry.value as num) : 0.0}',
                                  //               style: TextStyle(
                                  //                   fontWeight: FontWeight.bold,
                                  //                   fontSize: 14,
                                  //                   color:
                                  //                       (entry.value as num) < 0
                                  //                           ? Colors.red
                                  //                           : CupertinoColors
                                  //                               .systemBlue),
                                  //             );
                                  //           }).toList(),
                                  //           // Text(
                                  //           //   'KES: ',
                                  //           //   style: TextStyle(
                                  //           //     fontWeight: FontWeight.bold,
                                  //           //     fontSize: 13,
                                  //           //     // color: account.kesBalance < 0
                                  //           //     //     ? Colors.red
                                  //           //     //     : CupertinoColors.systemBlue,
                                  //           //   ),
                                  //           // ),
                                  //           // Text(
                                  //           //   'USD: ',
                                  //           //   style: TextStyle(
                                  //           //     fontWeight: FontWeight.bold,
                                  //           //     fontSize: 13,
                                  //           //     // color: account.usdBalance < 0
                                  //           //     //     ? Colors.red
                                  //           //     //     : CupertinoColors.activeCupertinoColors.systemBlue,
                                  //           //   ),
                                  //           // ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                );
                              },
                            );
                          },
                        ),
                        Divider(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // uploadController.uploadAccounts(context);
                            },
                            // style: ElevatedButton.styleFrom(
                            //   backgroundColor: CupertinoColors.systemBlue,
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 20,
                            //     vertical: 12,
                            //   ),
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(12),
                            //   ),
                            // ),
                            child: const Text(
                              "Upload accounts",
                              style: TextStyle(
                                color: AppColors.prettyDark,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        // Column(
                        //   children: [
                        //     StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        //       stream: FirebaseFirestore.instance
                        //           .collection('Users')
                        //           .doc(FirebaseAuth.instance.currentUser!.uid)
                        //           .collection('Accounts')
                        //           .orderBy('dateCreated', descending: true)
                        //           .snapshots(),
                        //       builder: (context, snapshot) {
                        //         if (!snapshot.hasData || snapshot.hasError) {
                        //           return Center(
                        //             child: Text(
                        //                 'No accounts found or an error occurred.'),
                        //           );
                        //         }
                        //
                        //         final accounts = snapshot.data!.docs;
                        //
                        //         if (accounts.isEmpty) {
                        //           return Center(
                        //             child: Text('No accounts available.'),
                        //           );
                        //         }
                        //
                        //         // Using a for loop to generate the list of widgets
                        //         List<Widget> accountWidgets = [];
                        //
                        //         /// Format the number to have decimals and 1,000 separator
                        //         final formatter = NumberFormat.decimalPatternDigits(
                        //           locale: 'en_us',
                        //           decimalDigits: 2,
                        //         );
                        //
                        //         for (var account in accounts) {
                        //           final accountData = account.data();
                        //           accountWidgets.add(
                        //             Padding(
                        //               padding: const EdgeInsets.only(bottom: 8.0),
                        //               child: ListTile(
                        //                 isThreeLine: true, dense: true,
                        //                 titleAlignment:
                        //                     ListTileTitleAlignment.titleHeight,
                        //                 contentPadding: EdgeInsets.symmetric(
                        //                     horizontal: 10, vertical: 3),
                        //                 shape: RoundedRectangleBorder(
                        //                     borderRadius:
                        //                         BorderRadius.circular(10)),
                        //                 // dense: true,
                        //                 tileColor: AppColors.quinary,
                        //                 title: Text('${accountData['AccountName']}',
                        //                     style: TextStyle(
                        //                         fontSize: 15,
                        //                         fontWeight: FontWeight.bold)),
                        //                 subtitle: Text(
                        //                   'Acc-no: ${accountData['AccountNo']}',
                        //                   style: TextStyle(
                        //                       fontSize: 12, color: Colors.purple),
                        //                 ),
                        //                 trailing: Column(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.spaceEvenly,
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.end,
                        //                   children: [
                        //                     Text(
                        //                         'KES: ${formatter.format(accountData['KesBalance'] ?? 0.0)}',
                        //                         style: TextStyle(
                        //                             fontWeight: FontWeight.bold,
                        //                             fontSize: 13,
                        //                             color: (accountData[
                        //                                             'KesBalance'] ??
                        //                                         0.0) <
                        //                                     0
                        //                                 ? Colors.red
                        //                                 : Colors.blue)),
                        //                     Gap(4),
                        //                     Text(
                        //                         'USD: ${formatter.format(accountData['UsdBalance'] ?? 0.0)}',
                        //                         style: TextStyle(
                        //                             fontWeight: FontWeight.bold,
                        //                             fontSize: 13,
                        //                             color: (accountData[
                        //                                             'UsdBalance'] ??
                        //                                         0.0) <
                        //                                     0
                        //                                 ? Colors.red
                        //                                 : CupertinoColors.activeCupertinoColors.systemBlue))
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //           );
                        //         }
                        //
                        //         return Column(
                        //           children: accountWidgets,
                        //         );
                        //       },
                        //     ),

                        //     Gap(6),
                        //   ],
                        // ),
                      ],
                    ),
                    Divider(
                      height: 0,
                    ),
                    ExpansionTile(
                      shape: Border(bottom: BorderSide.none, top: BorderSide.none),
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      title: InfoRow(
                          fontWeight: FontWeight.w600,
                          // fontWeight: FontWeight.w700,
                          // fontSize: 17,
                          // valueColor: CupertinoColors.systemBlue,
                          title: 'Payments',
                          value: ''),
                      children: [
                        Obx(
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
                        Divider(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // uploadController.uploadPayments(context);
                              // createNewAccountBottom(context);
                            },
                            // style: ElevatedButton.styleFrom(
                            //   backgroundColor: CupertinoColors.systemBlue,
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 20,
                            //     vertical: 12,
                            //   ),
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(12),
                            //   ),
                            // ),
                            child: const Text(
                              "Upload payments",
                              style: TextStyle(
                                color: AppColors.prettyDark,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        // Column(
                        //   children: [
                        //     StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        //       stream: FirebaseFirestore.instance
                        //           .collection('Users')
                        //           .doc(FirebaseAuth.instance.currentUser!.uid)
                        //           .collection('Accounts')
                        //           .orderBy('dateCreated', descending: true)
                        //           .snapshots(),
                        //       builder: (context, snapshot) {
                        //         if (!snapshot.hasData || snapshot.hasError) {
                        //           return Center(
                        //             child: Text(
                        //                 'No accounts found or an error occurred.'),
                        //           );
                        //         }
                        //
                        //         final accounts = snapshot.data!.docs;
                        //
                        //         if (accounts.isEmpty) {
                        //           return Center(
                        //             child: Text('No accounts available.'),
                        //           );
                        //         }
                        //
                        //         // Using a for loop to generate the list of widgets
                        //         List<Widget> accountWidgets = [];
                        //
                        //         /// Format the number to have decimals and 1,000 separator
                        //         final formatter = NumberFormat.decimalPatternDigits(
                        //           locale: 'en_us',
                        //           decimalDigits: 2,
                        //         );
                        //
                        //         for (var account in accounts) {
                        //           final accountData = account.data();
                        //           accountWidgets.add(
                        //             Padding(
                        //               padding: const EdgeInsets.only(bottom: 8.0),
                        //               child: ListTile(
                        //                 isThreeLine: true, dense: true,
                        //                 titleAlignment:
                        //                     ListTileTitleAlignment.titleHeight,
                        //                 contentPadding: EdgeInsets.symmetric(
                        //                     horizontal: 10, vertical: 3),
                        //                 shape: RoundedRectangleBorder(
                        //                     borderRadius:
                        //                         BorderRadius.circular(10)),
                        //                 // dense: true,
                        //                 tileColor: AppColors.quinary,
                        //                 title: Text('${accountData['AccountName']}',
                        //                     style: TextStyle(
                        //                         fontSize: 15,
                        //                         fontWeight: FontWeight.bold)),
                        //                 subtitle: Text(
                        //                   'Acc-no: ${accountData['AccountNo']}',
                        //                   style: TextStyle(
                        //                       fontSize: 12, color: Colors.purple),
                        //                 ),
                        //                 trailing: Column(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.spaceEvenly,
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.end,
                        //                   children: [
                        //                     Text(
                        //                         'KES: ${formatter.format(accountData['KesBalance'] ?? 0.0)}',
                        //                         style: TextStyle(
                        //                             fontWeight: FontWeight.bold,
                        //                             fontSize: 13,
                        //                             color: (accountData[
                        //                                             'KesBalance'] ??
                        //                                         0.0) <
                        //                                     0
                        //                                 ? Colors.red
                        //                                 : Colors.blue)),
                        //                     Gap(4),
                        //                     Text(
                        //                         'USD: ${formatter.format(accountData['UsdBalance'] ?? 0.0)}',
                        //                         style: TextStyle(
                        //                             fontWeight: FontWeight.bold,
                        //                             fontSize: 13,
                        //                             color: (accountData[
                        //                                             'UsdBalance'] ??
                        //                                         0.0) <
                        //                                     0
                        //                                 ? Colors.red
                        //                                 : CupertinoColors.activeCupertinoColors.systemBlue))
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //           );
                        //         }
                        //
                        //         return Column(
                        //           children: accountWidgets,
                        //         );
                        //       },
                        //     ),

                        //     Gap(6),
                        //   ],
                        // ),
                      ],
                    ),
                    Divider(
                      height: 0,
                    ),
                    ExpansionTile(
                      shape: Border(bottom: BorderSide.none, top: BorderSide.none),
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      title: InfoRow(
                          fontWeight: FontWeight.w600,
                          // fontWeight: FontWeight.w700,
                          // fontSize: 17,
                          // valueColor: CupertinoColors.systemBlue,
                          title: 'Expenses',
                          value: ''),
                      children: [
                        Obx(
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
                        Divider(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // uploadController.uploadExpenses(context);
                              // createNewAccountBottom(context);
                            },
                            // style: ElevatedButton.styleFrom(
                            //   backgroundColor: CupertinoColors.systemBlue,
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 20,
                            //     vertical: 12,
                            //   ),
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(12),
                            //   ),
                            // ),
                            child: const Text(
                              "Upload expenses",
                              style: TextStyle(
                                color: AppColors.prettyDark,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        // Column(
                        //   children: [
                        //     StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        //       stream: FirebaseFirestore.instance
                        //           .collection('Users')
                        //           .doc(FirebaseAuth.instance.currentUser!.uid)
                        //           .collection('Accounts')
                        //           .orderBy('dateCreated', descending: true)
                        //           .snapshots(),
                        //       builder: (context, snapshot) {
                        //         if (!snapshot.hasData || snapshot.hasError) {
                        //           return Center(
                        //             child: Text(
                        //                 'No accounts found or an error occurred.'),
                        //           );
                        //         }
                        //
                        //         final accounts = snapshot.data!.docs;
                        //
                        //         if (accounts.isEmpty) {
                        //           return Center(
                        //             child: Text('No accounts available.'),
                        //           );
                        //         }
                        //
                        //         // Using a for loop to generate the list of widgets
                        //         List<Widget> accountWidgets = [];
                        //
                        //         /// Format the number to have decimals and 1,000 separator
                        //         final formatter = NumberFormat.decimalPatternDigits(
                        //           locale: 'en_us',
                        //           decimalDigits: 2,
                        //         );
                        //
                        //         for (var account in accounts) {
                        //           final accountData = account.data();
                        //           accountWidgets.add(
                        //             Padding(
                        //               padding: const EdgeInsets.only(bottom: 8.0),
                        //               child: ListTile(
                        //                 isThreeLine: true, dense: true,
                        //                 titleAlignment:
                        //                     ListTileTitleAlignment.titleHeight,
                        //                 contentPadding: EdgeInsets.symmetric(
                        //                     horizontal: 10, vertical: 3),
                        //                 shape: RoundedRectangleBorder(
                        //                     borderRadius:
                        //                         BorderRadius.circular(10)),
                        //                 // dense: true,
                        //                 tileColor: AppColors.quinary,
                        //                 title: Text('${accountData['AccountName']}',
                        //                     style: TextStyle(
                        //                         fontSize: 15,
                        //                         fontWeight: FontWeight.bold)),
                        //                 subtitle: Text(
                        //                   'Acc-no: ${accountData['AccountNo']}',
                        //                   style: TextStyle(
                        //                       fontSize: 12, color: Colors.purple),
                        //                 ),
                        //                 trailing: Column(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.spaceEvenly,
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.end,
                        //                   children: [
                        //                     Text(
                        //                         'KES: ${formatter.format(accountData['KesBalance'] ?? 0.0)}',
                        //                         style: TextStyle(
                        //                             fontWeight: FontWeight.bold,
                        //                             fontSize: 13,
                        //                             color: (accountData[
                        //                                             'KesBalance'] ??
                        //                                         0.0) <
                        //                                     0
                        //                                 ? Colors.red
                        //                                 : Colors.blue)),
                        //                     Gap(4),
                        //                     Text(
                        //                         'USD: ${formatter.format(accountData['UsdBalance'] ?? 0.0)}',
                        //                         style: TextStyle(
                        //                             fontWeight: FontWeight.bold,
                        //                             fontSize: 13,
                        //                             color: (accountData[
                        //                                             'UsdBalance'] ??
                        //                                         0.0) <
                        //                                     0
                        //                                 ? Colors.red
                        //                                 : CupertinoColors.activeCupertinoColors.systemBlue))
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //           );
                        //         }
                        //
                        //         return Column(
                        //           children: accountWidgets,
                        //         );
                        //       },
                        //     ),

                        //     Gap(6),
                        //   ],
                        // ),
                      ],
                    ),
                    Divider(
                      height: 0,
                    ),
                    ExpansionTile(
                      shape: Border(bottom: BorderSide.none, top: BorderSide.none),
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      title: Text(
                        'Receipts',
                        style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                      ),
                      children: [
                        Obx(
                          () {
                            if (controller.receipts.isEmpty) {
                              return Text('Once created, receipts will appear here');
                            }
                            return ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.receipts.length,
                              itemBuilder: (context, index) {
                                final ReceiveModel receipt = controller.receipts[index];
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
                        Divider(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // uploadController.uploadReceipts(context);
                              // createNewAccountBottom(context);
                            },
                            // style: ElevatedButton.styleFrom(
                            //   backgroundColor: CupertinoColors.systemBlue,
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 20,
                            //     vertical: 12,
                            //   ),
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(12),
                            //   ),
                            // ),
                            child: const Text(
                              "Upload receipts",
                              style: TextStyle(
                                color: AppColors.prettyDark,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 0,
                    ),
                    ExpansionTile(
                      shape: Border(bottom: BorderSide.none, top: BorderSide.none),
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      title: Text(
                        'Withdrawals',
                        style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                      ),
                      children: [
                        Obx(
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
                        Divider(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // uploadController.uploadWithdrawals(context);
                              // createNewAccountBottom(context);
                            },
                            // style: ElevatedButton.styleFrom(
                            //   backgroundColor: CupertinoColors.systemBlue,
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 20,
                            //     vertical: 12,
                            //   ),
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(12),
                            //   ),
                            // ),
                            child: const Text(
                              "Upload withdrawals",
                              style: TextStyle(
                                color: AppColors.prettyDark,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 0,
                    ),
                    ExpansionTile(
                      shape: Border(bottom: BorderSide.none, top: BorderSide.none),
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      title: Text(
                        'Deposits',
                        style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                      ),
                      children: [
                        Obx(
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
                        Divider(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // uploadController.uploadDeposits(context);
                              // createNewAccountBottom(context);
                            },
                            // style: ElevatedButton.styleFrom(
                            //   backgroundColor: CupertinoColors.systemBlue,
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 20,
                            //     vertical: 12,
                            //   ),
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(12),
                            //   ),
                            // ),
                            child: const Text(
                              "Upload deposits",
                              style: TextStyle(
                                color: AppColors.prettyDark,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 0,
                    ),
                    ExpansionTile(
                      shape: Border(bottom: BorderSide.none, top: BorderSide.none),
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      title: Text(
                        'Transfers',
                        style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                      ),
                      children: [
                        Divider(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // uploadController.uploadTransfers(context);
                              // createNewAccountBottom(context);
                            },
                            // style: ElevatedButton.styleFrom(
                            //   backgroundColor: CupertinoColors.systemBlue,
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 20,
                            //     vertical: 12,
                            //   ),
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(12),
                            //   ),
                            // ),
                            child: const Text(
                              "Upload deposits",
                              style: TextStyle(
                                color: AppColors.prettyDark,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 0,
                    ),
                    ExpansionTile(
                      shape: Border(bottom: BorderSide.none, top: BorderSide.none),
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      title: Text(
                        'Currency stock',
                        style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                      ),
                      children: [
                        Obx(
                          () {
                            if (controller.payments.isEmpty) {
                              return Text('Once created, currencies will appear here');
                            }
                            return CustomContainer(
                              darkColor: AppColors.quinary,
                              width: double.maxFinite,
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: DataTable(
                                  headingRowHeight: 40,
                                  horizontalMargin: 6,
                                  headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
                                  columns: [
                                    DataColumn(label: Text('Code')),
                                    DataColumn(label: Text('Amount')),
                                    DataColumn(label: Text('Rate')),
                                    DataColumn(label: Text('Total cost')),
                                  ],
                                  rows: controller.currencies.map((currency) {
                                    return DataRow(cells: [
                                      DataCell(Text(currency.currencyCode)),
                                      DataCell(Text('formatter.format(currency.amount')),
                                      DataCell(Text('formatter.format(currency.totalCost / currency.amount)')),
                                      DataCell(Text('formatter.format(currency.totalCost)')),
                                    ]);
                                  }).toList()),
                            );
                          },
                        ),
                        Divider(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // uploadController.uploadCurrencyStock(context);
                              // createNewAccountBottom(context);
                            },
                            // style: ElevatedButton.styleFrom(
                            //   backgroundColor: CupertinoColors.systemBlue,
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 20,
                            //     vertical: 12,
                            //   ),
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(12),
                            //   ),
                            // ),
                            child: const Text(
                              "Upload currencies",
                              style: TextStyle(
                                color: AppColors.prettyDark,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 0,
                    ),
//                     ExpansionTile(
//                       shape: Border(bottom: BorderSide.none, top: BorderSide.none),
//                       childrenPadding: EdgeInsets.zero,
//                       tilePadding: EdgeInsets.zero,
//                       title: Text(
//                         'Transfers',
//                         style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
//                       ),
//                       children: [
//                         Obx(
//                           () {
//                             if (controller.payments.isEmpty) {
//                               return Text('Once created, payments will appear here');
//                             }
//                             return ListView.builder(
//                               physics: ClampingScrollPhysics(),
//                               shrinkWrap: true,
//                               itemCount: controller.payments.length,
//                               itemBuilder: (context, index) {
//                                 final PayClientModel payment = controller.payments[index];
//                                 return Padding(
//                                   padding: const EdgeInsets.only(top: 4.0),
//                                   child: GestureDetector(
//                                     dragStartBehavior: DragStartBehavior.start,
//                                     child: CustomContainer(
//                                       darkColor: AppColors.quinary,
//                                       width: double.infinity,
//                                       padding: EdgeInsets.all(8),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           // First Row (From, Receiver, Amount)
//                                           Row(crossAxisAlignment: CrossAxisAlignment.center,
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   RichText(
//                                                     text: TextSpan(
//                                                       children: [
//                                                         TextSpan(
//                                                           text: 'From: ',
//                                                           style: TextStyle(
//                                                             fontWeight: FontWeight.w500,
//                                                             fontSize: 10,
//                                                             color: Colors.grey[600],
//                                                           ),
//                                                         ),
//                                                         TextSpan(
//                                                           text: payment.accountFrom,
//                                                           style: TextStyle(
//                                                             fontWeight: FontWeight.w500,
//                                                             fontSize: 12,
//                                                             color: Colors.blue,
//                                                             // Black Value
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Gap(3),
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
//                                                 ],
//                                               ),
//                                               RichText(
//                                                 text: TextSpan(
//                                                   children: [
//                                                     TextSpan(
//                                                       text: '${payment.currency}: ',
//                                                       style: TextStyle(
//                                                         fontWeight: FontWeight.w500,
//                                                         // fontSize: 12,
//                                                         fontSize: 10,
//                                                         color: Colors.grey[600], // Grey Label
//                                                       ),
//                                                     ),
//                                                     TextSpan(
//                                                       text: formatter
//                                                           .format(payment.amountPaid)
//                                                           // text: payment.amountPaid
//                                                           .toString(),
//                                                       style: TextStyle(
//                                                         fontWeight: FontWeight.w700,
//                                                         fontSize: 12,
//                                                         color: Colors.redAccent, // Grey Label
//                                                         // Black Value
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//
//                                           Divider(color: Colors.grey[400], thickness: 1),
//
//                                           /// Second Row (Transaction ID, Type, Date)
//                                           Row(
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Row(
//                                                 mainAxisAlignment: MainAxisAlignment.start,
//                                                 children: [
//                                                   RichText(
//                                                     text: TextSpan(
//                                                       children: [
//                                                         TextSpan(
//                                                           text: 'type: ',
//                                                           style: TextStyle(
//                                                             fontWeight: FontWeight.w500,
//                                                             fontSize: 10,
//                                                             color: Colors.grey[600], // Grey Label
//                                                           ),
//                                                         ),
//                                                         TextSpan(
//                                                           text: payment.transactionType,
//                                                           style: TextStyle(
//                                                               fontWeight: FontWeight.w500,
//                                                               fontSize: 10,
//                                                               color: Colors.blue // Grey Label
//                                                               // Black Value
//                                                               ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Gap(10),
//                                                   RichText(
//                                                     text: TextSpan(
//                                                       children: [
//                                                         TextSpan(
//                                                           text: '# ',
//                                                           style: TextStyle(
//                                                             fontWeight: FontWeight.w500,
//                                                             fontSize: 10,
//                                                             color: Colors.grey[600], // Grey Label
//                                                           ),
//                                                         ),
//                                                         TextSpan(
//                                                           text: payment.transactionId,
//                                                           style: TextStyle(
//                                                               fontWeight: FontWeight.w500,
//                                                               fontSize: 10,
//                                                               color: Colors.blue // Grey Label
//                                                               // Black Value
//                                                               ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               RichText(
//                                                 text: TextSpan(
//                                                   children: [
//                                                     TextSpan(
//                                                       text: DateFormat("dd MMM yyyy HH:mm")
//                                                           .format(payment.dateCreated),
//                                                       style: TextStyle(
//                                                           fontWeight: FontWeight.w500,
//                                                           fontSize: 10,
//                                                           color: Colors.blue // Grey Label
//                                                           // Black Value
//                                                           ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                         Divider(),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               uploadController.uploadPayments();
//                               // createNewAccountBottom(context);
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: CupertinoColors.systemBlue,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 12,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: const Text(
//                               "Upload payments",
//                               style: TextStyle(
//                                 color: AppColors.quinary,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Divider(
//                       height: 0,
//                     ),
                    Gap(20),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FloatingActionButton(
                  heroTag: 'Complete setup',
                  backgroundColor: Colors.blueAccent,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      backgroundColor: AppColors.quarternary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 10,
                      titlePadding: EdgeInsets.zero,
                      title: Column(
                        children: [
                          Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: AppColors.quinary,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.warning_rounded,
                                    color: Colors.orange,
                                  ),
                                  Gap(10),
                                  Text(
                                    'Are you sure?',
                                    style: TextStyle(
                                      color: CupertinoColors.systemBlue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                      content: Text(
                        'Have you confirmed your totals and other uploaded data? If not, please do so. No hurry!.If done, please proceed to submit the data.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      actionsAlignment: MainAxisAlignment.center,
                      actionsPadding: EdgeInsets.only(bottom: 15),
                      actions: [
                        SizedBox(
                          height: 40,
                          width: 100,
                          child: FloatingActionButton(
                            backgroundColor: AppColors.quinary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            onPressed: () {
                              controller.completeSetup();
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Submit data",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: SizedBox(
                            height: 40,
                            width: 100,
                            child: FloatingActionButton(
                              backgroundColor: AppColors.quinary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: Text(
                    'Complete setup',
                    style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final FontWeight fontWeight;
  final double fontSize;

  const InfoRow({
    super.key,
    required this.title,
    required this.value,
    this.valueColor = Colors.black,
    this.fontWeight = FontWeight.w600,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: 'Poppins',
            color: valueColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: fontSize, color: valueColor, fontWeight: fontWeight, fontFamily: 'Poppins'),
        ),
      ],
    );
  }
}

void createNewAccountBottom(BuildContext? context) {
  final controller = Get.put(AccountsController());
  showModalBottomSheet(
    context: context!,
    isScrollControlled: true,
    backgroundColor: Colors.grey,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create new account",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    validator: (value) => Validator.validateEmptyText('field', value),
                    controller: controller.firstName,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      labelText: "First Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Gap(10),
                Expanded(
                  child: TextFormField(
                    validator: (value) => Validator.validateEmptyText('field', value),
                    controller: controller.lastName,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      labelText: "Last Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.phoneNo,
                    validator: (value) => Validator.validateEmptyText('field', value),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: TextFormField(
                    controller: controller.email,
                    validator: (value) => Validator.validateEmptyText('field', value),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                )
              ],
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.usd,
                    validator: (value) => Validator.validateEmptyText('field', value),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      labelText: "USD amount",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.kes,
                    validator: (value) => Validator.validateEmptyText('field', value),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      labelText: "KES amount",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Gap(10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // controller.makeItNegative.value = true;
                  controller.createAccount(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CupertinoColors.systemBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Gap(20),
          ],
        ),
      );
    },
  );
}
