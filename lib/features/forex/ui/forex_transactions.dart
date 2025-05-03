import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../common/styles/custom_container.dart';
import '../../../../utils/constants/colors.dart';


class ForexTransactions extends StatefulWidget {
  const ForexTransactions({super.key});

  @override
  ForexTransactionsState createState() => ForexTransactionsState();
}
final NumberFormat formatter = NumberFormat.decimalPatternDigits(
  locale: 'en_us',
  decimalDigits: 2,
);

class ForexTransactionsState extends State<ForexTransactions> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('transactions')
      .where('transactionType', isEqualTo: 'forex').orderBy('dateCreated',descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
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
            return CustomContainer(
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
                              text: '${data['forexType'].replaceAll('Fx','').toUpperCase()} - ${data['CurrencyCode']}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: data['forexType']=='sellFx'?AppColors.red:CupertinoColors.systemBlue
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
                              text: formatter.format(double.parse(data['Amount'].toString())),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: data['forexType']=='sellFx'?AppColors.red:CupertinoColors.systemBlue
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
                              text: formatter.format(double.parse(data['Rate'].toString())),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: data['forexType']=='sellFx'?AppColors.red:CupertinoColors.systemBlue
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
                              text: formatter.format(double.parse(data['TotalCost'].toString())),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: data['forexType']=='sellFx'?AppColors.red:CupertinoColors.systemBlue
                                // Grey Label
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
                                  text: data['transactionId'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
                                    // Grey Label
                                    // Black Value
                                  ),
                                ),
                              ],
                            ),
                          ), Gap(10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: data['type'].toString(),
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
            );
          })
              .toList()
              .cast(),
        );
      },
    );
  }
}
