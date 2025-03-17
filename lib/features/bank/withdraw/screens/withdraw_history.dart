import 'package:ciyebooks/features/bank/withdraw/screens/withdraw_form.dart';
import 'package:ciyebooks/features/pay/pay_client/pay_client_model/pay_client_model.dart';
import 'package:ciyebooks/features/pay/pay_client/screens/pay_client_form.dart';
import 'package:ciyebooks/features/pay/pay_expense/expense_controller/pay_expense_controller.dart';
import 'package:ciyebooks/features/pay/pay_expense/expense_model/expense_model.dart';
import 'package:ciyebooks/features/pay/pay_expense/screens/pay_expense_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../../../common/styles/custom_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../dashboard/controller/dashboard_controller.dart';
import '../../deposit/model/deposit_model.dart';
import '../../transfers/model/transfer_model.dart';
import '../model/withdraw_model.dart';

class WithdrawHistory extends StatelessWidget {
  const WithdrawHistory({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(PayExpenseController());
    final controller= Get.put(DashboardController());
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    final uid = FirebaseAuth.instance.currentUser?.uid;
    // final usersQuery =
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: CupertinoColors.systemBlue,
        shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.quarternary, width: 2), borderRadius: BorderRadius.circular(20)),
        onPressed: () => Get.offAll(() => WithdrawForm()),
        child: Icon(
          Icons.add_circle_outline,
          // Icons.add_circle_outline,
          color: AppColors.quinary,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      appBar: AppBar(
        foregroundColor: AppColors.quinary,
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.quinary,
            )),
        backgroundColor: CupertinoColors.systemBlue,
        title: Text(
          'Bank history',
          style: TextStyle(color: AppColors.quinary),
        ),
      ),
      body: SafeArea(bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: DefaultTabController(
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
                Expanded(

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
        ),
      ),
    );
  }
}
