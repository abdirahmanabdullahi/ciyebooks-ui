import 'package:ciyebooks/features/forex/ui/widgets/fx_transaction_success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../common/styles/custom_container.dart';
import '../../../../utils/constants/colors.dart';

class ForexTransactions extends StatelessWidget {
  const ForexTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('transactions')
          .where('transactionType', isEqualTo: 'forex')
          .orderBy('dateCreated', descending: true)
          .snapshots(),
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
                  onTap: () => showForexInfo(
                      context: context,
                      forexType: data['forexType'],
                      currency: data['currencyCode'],
                      transactionCode: data['transactionId'],
                      method: data['type'],
                      amount: data['amount'].toString(),
                      rate: data['rate'].toString(),
                      totalCost: data['totalCost'].toString(),
                      date: data['dateCreated'].toDate()),
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
                                    text: '${data['forexType'].replaceAll('Fx', '').toUpperCase()} - ${data['currencyCode']}',
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: data['forexType'] == 'SELLFX' ? AppColors.red : CupertinoColors.systemBlue
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
                                    text: formatter.format(double.parse(data['amount'].toString())),
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: data['forexType'] == 'SELLFX' ? AppColors.red : CupertinoColors.systemBlue
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
                                    text: formatter.format(double.parse(data['rate'].toString())),
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: data['forexType'] == 'SELLFX' ? AppColors.red : CupertinoColors.systemBlue
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
                                    text: formatter.format(double.parse(data['totalCost'].toString())),
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: data['forexType'] == 'SELLFX' ? AppColors.red : CupertinoColors.systemBlue
                                        // Grey Label
                                        // Black Value
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Divider(),

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
                                        text: data['transactionId'],
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
                                        text: data['type'].toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
                                          // Grey Label
                                          // Black Value
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Gap(10),
                                // RichText(
                                //   text: TextSpan(
                                //     children: [
                                //       TextSpan(
                                //         text: '# ',
                                //         style: TextStyle(
                                //           fontWeight: FontWeight.w300,
                                //           fontSize: 10,
                                //           color: AppColors.secondary,
                                //           // Grey Label
                                //         ),
                                //       ),
                                //       TextSpan(
                                //         text: data['TransactionId'],
                                //         style: TextStyle(
                                //           fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
                                //
                                //           // Black Value
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
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
