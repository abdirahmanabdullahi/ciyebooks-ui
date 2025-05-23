import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/colors.dart';

final now = DateTime.now();
final startOfToday = DateTime(now.year, now.month, now.day);
final NumberFormat formatter = NumberFormat.decimalPatternDigits(
  locale: 'en_us',
  decimalDigits: 2,
);
class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {



    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('transactions')
          .where('dateCreated', isGreaterThanOrEqualTo: startOfToday)
          .orderBy('dateCreated', descending: true)
          .snapshots(),
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
        if (snapshot.data!.docs.isEmpty) {
          return Center(child: Padding(
            padding: const EdgeInsets.fromLTRB(0,0,0, 30.0),
            child: const Text("Your daily transactions will appear here."),
          ));
        }
        return Column(
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                if (data['transactionType'] == 'forex') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['forexType'],
                              style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            Text(
                              "${data['currencyCode'].toString().toUpperCase()} ${formatter.format(double.parse(data['amount'].toString()))} ",
                              style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ],
                        ),
                           Divider(),
                      ],
                    ),
                  );


                }

                if (data['transactionType'] == 'payment') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['accountFrom'],
                              style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            Text(
                              "-${data['currency'].toString().toUpperCase()} ${formatter.format(double.parse(data['amount'].toString()))} ",
                              style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ],
                        ),
                           Divider(),
                      ],
                    ),
                  );
                }
                if (data['transactionType'] == 'receipt') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['receivingAccountName'],
                              style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            Text(
                              "+${data['currency'].toString().toUpperCase()} ${formatter.format(double.parse(data['amount'].toString()))} ",
                              style: TextStyle(color: Color(0xff118B50), fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ],
                        ),
                           Divider(),
                      ],
                    ),
                  );
                }
                if (data['transactionType'] == 'expense') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['category'],
                              style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            Text(
                              "-${data['currency'].toString().toUpperCase()} ${formatter.format(double.parse(data['amount'].toString()))} ",
                              style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ],
                        ),
                           Divider(),
                      ],
                    ),
                  );
                }
                if (data['transactionType'] == 'deposit') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['transactionType'],
                              style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            Text(
                              "${data['currency'].toString().toUpperCase()} ${formatter.format(double.parse(data['amount'].toString()))} ",
                              style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ],
                        ),
                           Divider(),
                      ],
                    ),
                  );

                }
                if (data['transactionType'] == 'withdrawal') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['transactionType'],
                              style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                            Text(
                              "${data['currency'].toString().toUpperCase()} ${formatter.format(double.parse(data['amount'].toString()))} ",
                              style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ],
                        ),
                           Divider(),
                      ],
                    ),
                  );

                }
              })
              .toList()
              .cast(),
        );
      },
    );
  }
}
