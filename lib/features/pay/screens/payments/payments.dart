import 'package:ciyebooks/features/pay/controllers/pay_client_controller.dart';
import 'package:ciyebooks/features/pay/screens/payments/payment_success_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../../../common/styles/custom_container.dart';
import '../../../../../utils/constants/colors.dart';

class PaymentsHistory extends StatefulWidget {
  const PaymentsHistory({super.key});

  @override
  PaymentsHistoryState createState() => PaymentsHistoryState();
}

final NumberFormat formatter = NumberFormat.decimalPatternDigits(
  locale: 'en_us',
  decimalDigits: 2,
);

class PaymentsHistoryState extends State<PaymentsHistory> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('transactions')
      .where('transactionType', isEqualTo: 'payment')
      .orderBy('dateCreated', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: const Text('Something went wrong'));
        }
        if (!snapshot.hasData) {
          return Center(child: const Text('No data available'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const Text("Loading"));
        }

        return ListView(
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () => showPaymentInfo(
                      context: context,
                      transactionCode: data['transactionId'],
                      payee: data['accountFrom'],
                      payeeAccountNo: data['accountNo'],
                      receiver: Text(data['receiver'],),
                      paymentType: data['paymentType'],
                      description: data['description'],
                      date: data['dateCreated'].toDate(),
                      totalPayment: formatter.format(
                        double.parse(data['amount'].toString()),
                      ),
                      paidCurrency: data['currency']),
                  child: CustomContainer(
                    darkColor: AppColors.quinary,
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
                                    text: data['accountFrom'],
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
                                      color: AppColors.red, // Grey Label
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
                                        text: data['accountNo'],
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
                                        text: data['paymentType'].toUpperCase(),
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
    );
  }
}
