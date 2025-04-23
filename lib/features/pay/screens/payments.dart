import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../common/styles/custom_container.dart';
import '../../../../utils/constants/colors.dart';

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
      .collection('Users')
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
                return Padding(
                  padding: const EdgeInsets.only(top: 7),
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
                                    text: data['AccountFrom'],
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
                                    text: '${data['Currency']}: ',
                                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10,                               color: AppColors.secondary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: formatter
                                        .format(data['AmountPaid'])
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

                        Divider(color: AppColors.prettyDark, thickness: .11),

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
                                        text: data['TransactionId'],
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
                                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10,                               color: AppColors.secondary,
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
