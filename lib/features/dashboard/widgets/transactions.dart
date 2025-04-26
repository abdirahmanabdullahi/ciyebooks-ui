import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../common/styles/custom_container.dart';
import '../../../../utils/constants/colors.dart';

class TransactionsHistory extends StatefulWidget {
  const TransactionsHistory({super.key});

  @override
  TransactionsHistoryState createState() => TransactionsHistoryState();
}

final NumberFormat formatter = NumberFormat.decimalPatternDigits(
  locale: 'en_us',
  decimalDigits: 2,
);

class TransactionsHistoryState extends State<TransactionsHistory> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('transactions')
      .where(
        'transactionType',
      )
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
          shrinkWrap: true,
          children: snapshot.data!.docs
              .map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                if (data['transactionType'] == 'payment') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['AccountFrom'],
                              style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w700, fontSize: 11),
                            ),
                            Text(
                              "-${data['Currency'].toString().toLowerCase()} ${formatter.format(double.parse(data['AmountPaid'].toString()))} ",
                              style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w700, fontSize: 11),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: .11,
                          color: AppColors.prettyDark,
                        )
                      ],
                    ),
                  );

                  return ListTile(
                    dense: true,
                    title: Text(
                      data['AccountFrom'],
                      style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    trailing: Text(
                      "-${data['Currency'].toString().toLowerCase()} ${formatter.format(double.parse(data['AmountPaid'].toString()))} ",
                      style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w700, fontSize: 13),
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
                              style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w700, fontSize: 11),
                            ),
                            Text(
                              "+${data['currency'].toString().toLowerCase()} ${formatter.format(double.parse(data['amount'].toString()))} ",
                              style: TextStyle(color: Color(0xff118B50), fontWeight: FontWeight.w700, fontSize: 11),
                            ),
                          ],
                        ),
                        Divider(
                          // height: 0,
                          thickness: .11,
                          color: AppColors.prettyDark,
                        )
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
                              style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w700, fontSize: 11),
                            ),
                            Text(
                              "-${data['currency'].toString().toLowerCase()} ${formatter.format(double.parse(data['amountPaid'].toString()))} ",
                              style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w700, fontSize: 11),
                            ),
                          ],
                        ),
                        Divider(
                          // height: 0,
                          thickness: .11,
                          color: AppColors.prettyDark,
                        )
                      ],
                    ),
                  );
                  return ListTile(
                    dense: true,
                    title: Text(
                      data['category'],
                      style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    trailing: Text(
                      "-${data['currency'].toString().toLowerCase()} ${formatter.format(double.parse(data['amountPaid'].toString()))} ",
                      style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w700, fontSize: 13),
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
                              style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w700, fontSize: 11),
                            ),
                            Text(
                              "${data['currency'].toString().toLowerCase()} ${formatter.format(double.parse(data['amount'].toString()))} ",
                              style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w700, fontSize: 11),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: .11,
                          color: AppColors.prettyDark,
                        )
                      ],
                    ),
                  );
                  return ListTile(
                    dense: true,
                    title: Text(
                      data['transactionType'],
                      style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    trailing: Text(
                      "${data['currency'].toString().toLowerCase()} ${formatter.format(double.parse(data['amount'].toString()))} ",
                      style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w700, fontSize: 13),
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
                              style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w700, fontSize: 11),
                            ),
                            Text(
                              "${data['currency'].toString().toLowerCase()} ${formatter.format(double.parse(data['amount'].toString()))} ",
                              style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w700, fontSize: 11),
                            ),
                          ],
                        ),
                        Divider(
                          // height: 0,
                          thickness: .11,
                          color: AppColors.prettyDark,
                        )
                      ],
                    ),
                  );
                  return ListTile(
                    dense: true,
                    title: Text(
                      data['transactionType'],
                      style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    trailing: Text(
                      "${data['currency'].toString().toLowerCase()} ${formatter.format(double.parse(data['amount'].toString()))} ",
                      style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w700, fontSize: 13),
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
