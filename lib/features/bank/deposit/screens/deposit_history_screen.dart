import 'package:ciyebooks/features/bank/deposit/controller/deposit_cash_controller.dart';
import 'package:ciyebooks/features/bank/deposit/model/deposit_model.dart';
import 'package:ciyebooks/features/pay/pay_expense/screens/pay_expense_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../../../common/styles/custom_container.dart';
import '../../../../utils/constants/colors.dart';

class DepositHistoryScreen extends StatelessWidget {
  const DepositHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DepositCashController());
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
        onPressed: () => Get.offAll(() => PayExpenseForm()),
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
        actions: [],
        backgroundColor: CupertinoColors.systemBlue,
        title: Text(
          'Deposit history',
          style: TextStyle(color: AppColors.quinary),
        ),
      ),
      body: Obx(
        () => SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 40, 12, 6),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: SizedBox(
                          height: 30,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.quinary,
                                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                padding: EdgeInsets.symmetric(horizontal: 10)),
                            onPressed: () => controller.sortCriteria.value = 'dateCreated',
                            child: Text(
                              'Sort by date',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: SizedBox(
                          height: 30,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.quinary,
                                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                padding: EdgeInsets.symmetric(horizontal: 10)),
                            onPressed: () => controller.sortCriteria.value = 'amount',
                            child: Text(
                              'Sort by amount',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: SizedBox(
                          height: 30,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.quinary,
                                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                padding: EdgeInsets.symmetric(horizontal: 10)),
                            onPressed: () => controller.sortCriteria.value = 'currency',
                            child: Text(
                              'Sort by currency',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: SizedBox(
                          height: 30,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: AppColors.quinary,
                                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                padding: EdgeInsets.symmetric(horizontal: 10)),
                            onPressed: () => controller.sortCriteria.value = 'transactionId',
                            child: Text(
                              'Sort by transactionId',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: FirestoreListView<DepositModel>(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  query: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(uid)
                      .collection('transactions')
                      .where('transactionType', isEqualTo: 'deposit')
                      .orderBy(controller.sortCriteria.value,descending: true)
                      .withConverter<DepositModel>(
                        fromFirestore: (snapshot, _) => DepositModel.fromJson(snapshot.data()!),
                        toFirestore: (deposit, _) => deposit.toJson(),
                      ),
                  itemBuilder: (context, snapshot) {
                    DepositModel deposit = snapshot.data();
                    print(deposit.amount);

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
                                            text: 'Depositor: ',
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
                                            text: deposit.description,
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
                                            text: 'Type: ',
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
