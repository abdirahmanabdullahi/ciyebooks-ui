import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/colors.dart';

class AccountStatementStreamPage extends StatelessWidget {
  const AccountStatementStreamPage({super.key});
  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Account Statement',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('transactions')
            .where('accountNo', isEqualTo: '1000')
            // .orderBy('dateCreated', descending: true)
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account Holder: John Doe', style: TextStyle(fontSize: 14)),
                Text('Period: May 1 – May 31, 2025', style: TextStyle(fontSize: 14)),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
                    // Expanded(flex: 2, child: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                  ],
                ),
                SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (_, __) => Divider(height: 16),
                    itemBuilder: (_, index) {
                      final data = snapshot.data!.docs;
                      final transaction = data[index];
                      // final isCredit = txn['type'] == 'Credit';

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(DateFormat('MMM dd').format(transaction['dateCreated'].toDate())),
                          ),
                          Expanded(
                            child: Text(transaction['description']),
                          ),
                          // Expanded(
                          //   flex: 2,
                          //   child: Text(
                          //     transaction['transactionType'],
                          //     // style: TextStyle(color: isCredit ? Colors.green : Colors.red),
                          //   ),
                          // ),
                          Expanded(flex: 0,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: transaction['transactionType']=='receipt'?'-':'+',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: transaction['transactionType']=='receipt'?AppColors.prettyDark:AppColors.red,
                                    ),
                                  ),TextSpan(
                                    text: '${transaction['currency']}: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: transaction['transactionType']=='receipt'?AppColors.prettyDark:AppColors.red,
                                    ),
                                  ),
                                  TextSpan(
                                    text: formatter.format(
                                      double.parse(
                                        transaction['amount'].toString(),
                                      ),
                                    ),
                                    // text: payment.amountPaid

                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: transaction['transactionType']=='receipt'?AppColors.prettyDark:AppColors.red,
                                      // Black Value
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // '${transaction['currency']} ${formatter.format(double.parse( transaction['amount'].toString(),))}'

                            // '${isCredit ? '+' : '-'}\$${txn['amount'].toStringAsFixed(2)}',
                            // textAlign: TextAlign.right,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
