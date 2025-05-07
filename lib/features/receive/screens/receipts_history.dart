import 'package:ciyebooks/features/receive/screens/widgets/client_deposit_form.dart';
import 'package:ciyebooks/features/receive/screens/widgets/deposit_success.dart';
import 'package:ciyebooks/navigation_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/styles/custom_container.dart';
import '../../../../utils/constants/colors.dart';

class ReceiptsHistory extends StatelessWidget {
  const ReceiptsHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('transactions')
        .where('transactionType', isEqualTo: 'receipt')
        .orderBy('dateCreated', descending: true)
        .snapshots();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showReceiptForm(context),
        backgroundColor: AppColors.prettyDark,
        shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.quinary, width: 2.5), borderRadius: BorderRadius.circular(100)),
        child: Icon(
          Icons.add,
          color: AppColors.quinary,
          // size: 35,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.quarternary,
        title: Text(
          'Deposits',
          style: TextStyle(fontWeight: FontWeight.w400, color: AppColors.prettyDark),
        ),
        // actions: [IconButton(onPressed: () => Get.offAll(() => NavigationMenu()), icon: Icon(Icons.close))],
      ),
      backgroundColor: AppColors.quarternary,
      body: StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (!snapshot.hasData) {
            return const Text('No data available');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return GestureDetector(
                    onTap: () => showClientDepositInfo(
                        context: context,
                        currency: data['currency'],
                        transactionCode: data['transactionId'],
                        amount: data['amount'].toString(),
                        depositor: Text(data['depositorName']),
                        depositType: data['depositType'],
                        receivingAccountName: data['receivingAccountName'],
                        receivingAccountNo: data['receivingAccountNo'],
                        description: data['description'],
                        date: data['dateCreated'].toDate()),
                    child: Container(
                      color: AppColors.quinary,
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // First Row (From, Receiver, Amount)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: data['receivingAccountName'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: AppColors.secondary,
                                        // Grey Label
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
                                      text: '${data['currency']}: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 10,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: formatter
                                          .format(data['amount'])
                                          // text: payment.amountPaid
                                          .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: AppColors.green, // Grey Label
                                        // Black Value
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          Divider(color: Colors.black, thickness: .11),

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
                                          text: data['receivingAccountNo'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
                                            // Grey Label
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
                                          text: data['depositType'].toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
                                            // Grey Label
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
                                            color: AppColors.secondary,
                                            // Grey Label
                                          ),
                                        ),
                                        TextSpan(
                                          text: data['transactionId'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,

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
                                      text: DateFormat("dd MMM yyyy HH:mm").format(data['dateCreated'].toDate()).toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
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
                })
                .toList()
                .cast(),
          );
        },
      ),
    );
  }
}
