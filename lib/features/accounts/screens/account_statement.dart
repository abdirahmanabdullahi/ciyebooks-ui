import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/colors.dart';

class AccountStatement extends StatelessWidget {
  final String accountNo, accountName;
  const AccountStatement({super.key, required this.accountNo, required this.accountName});
  @override
  Widget build(BuildContext context) {
    void showDialog() {
      Platform.isIOS ?


      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system
          // navigation bar.
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          // Provide a background color for the popup.
          color: AppColors.quinary,
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            child: CupertinoDatePicker(
              backgroundColor: AppColors.quinary,
              initialDateTime: DateTime.now(),
              mode: CupertinoDatePickerMode.date,
              use24hFormat: true,
              // This shows day of week alongside day of month
              showDayOfWeek: true,
              onDateTimeChanged: (DateTime value) {
                // controller.selectedDate.value = DateFormat("d MMM yyyy").format(value);
              },
              // This is called when the user changes the date.
            ),
          ),
        ),
      ):showDatePicker(initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColors.prettyBlue, // header background color
                  onPrimary: AppColors.quinary, // header text color
                  onSurface: AppColors.prettyDark, // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: CupertinoColors.systemBlue, ),)
              // dialogBackgroundColor: Colors.white,  // Entire dialog background
            ),
            child: child!,
          );
        },
      ).then((date) {
        if (date != null) {
          // controller.selectedDate.value = DateFormat("d MMM yyyy").format(date);
        }
      });
    }

    return Scaffold(backgroundColor: AppColors.quinary,
      appBar: AppBar(actions: [IconButton(onPressed: ()=>showDialog()   , icon: Icon(Icons.calendar_month,color: AppColors.quinary,))],
        backgroundColor: AppColors.prettyBlue,
        elevation: 0,
        title: Text(
          'Account Statement',
          style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w500),
        ),
        // centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.quinary
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('transactions')
            .where('accountNo', isEqualTo: accountNo)
            // .orderBy('dateCreated', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          final NumberFormat formatter = NumberFormat.decimalPatternDigits(
            locale: 'en_us',
            decimalDigits: 2,
          );
          if (snapshot.hasError) {
            return Center(child: const Text('Something went wrong'));
          }
          if (!snapshot.hasData) {
            return Center(child: const Text('No data available'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const Text("Loading"));
          }
          // final transactions = snapshot.data;
          // final totalPayment =transactions.docs.where((t)=>t['transactionType']=='payment').fold(0.0, total)
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container( margin: EdgeInsets.fromLTRB(8,20,8,8),
                width: double.maxFinite,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.quinary,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Account holder:   ',
                            style: TextStyle(fontSize: 12, color: AppColors.prettyDark),
                          ),
                          TextSpan(
                            text: accountName,
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: CupertinoColors.systemBlue),
                          ),
                          // TextSpan(
                          //   text: formatter.format(
                          //     double.parse(
                          //       transaction['amount'].toString(),
                          //     ),
                          //   ),
                          //   // text: payment.amountPaid
                          //
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.w600,
                          //     fontSize: 12,
                          //     color: transaction['transactionType'] == 'receipt' ? CupertinoColors.systemBlue : AppColors.red,
                          //     // Black Value
                          //   ),
                          // ),
                        ],
                      ),
                    ),Divider(),
                    Gap(6),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Account no:         ',
                            style: TextStyle(fontSize: 12, color: AppColors.prettyDark),
                          ),
                          TextSpan(
                            text: accountNo,
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: CupertinoColors.systemBlue),
                          ),
                          // TextSpan(
                          //   text: formatter.format(
                          //     double.parse(
                          //       transaction['amount'].toString(),
                          //     ),
                          //   ),
                          //   // text: payment.amountPaid
                          //
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.w600,
                          //     fontSize: 12,
                          //     color: transaction['transactionType'] == 'receipt' ? CupertinoColors.systemBlue : AppColors.red,
                          //     // Black Value
                          //   ),
                          // ),
                        ],
                      ),
                    ), Divider(),
                    Gap(6),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Period:         ',
                            style: TextStyle(fontSize: 12, color: AppColors.prettyDark),
                          ),
                          TextSpan(
                            text: accountNo,
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: CupertinoColors.systemBlue),
                          ),
                          // TextSpan(
                          //   text: formatter.format(
                          //     double.parse(
                          //       transaction['amount'].toString(),
                          //     ),
                          //   ),
                          //   // text: payment.amountPaid
                          //
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.w600,
                          //     fontSize: 12,
                          //     color: transaction['transactionType'] == 'receipt' ? CupertinoColors.systemBlue : AppColors.red,
                          //     // Black Value
                          //   ),
                          // ),
                        ],
                      ),
                    ),Divider(),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  color: AppColors.quinary,
                  child: Column(children: [Container(
                  padding: EdgeInsets.all(8),
                  color: AppColors.quarternary,
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 3, child: Text('Description', style: TextStyle(fontWeight: FontWeight.bold))),
                      // Expanded(flex: 1, child: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
                      // Expanded(flex: 2, child: Text('Currency', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(flex: 3, child: Text('Amount', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                    ],
                  ),
                ),
                  SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 50),
                      itemCount: snapshot.data!.docs.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 16,
                        thickness: .5,
                      ),
                      itemBuilder: (_, index) {
                        final data = snapshot.data!.docs;
                        final transaction = data[index];
                        // final isCredit = txn['type'] == 'Credit';

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(DateFormat('dd MMMM yyy').format(transaction['dateCreated'].toDate())),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(transaction['description']),
                              ),
                              // Expanded(
                              //   flex: 2,
                              //   child: Text(
                              //     transaction['transactionType']=='payment',
                              //     // style: TextStyle(color: isCredit ? Colors.green : Colors.red),
                              //   ),
                              // ), Expanded(
                              //   flex: 2,
                              //   child: Text(
                              //     transaction['currency'],
                              //     // style: TextStyle(color: isCredit ? Colors.green : Colors.red),
                              //   ),
                              // ),
                              Expanded(
                                flex: 0,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: transaction['transactionType'] == 'receipt' ? '+' : '-',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: transaction['transactionType'] == 'receipt' ? CupertinoColors.systemBlue : AppColors.red,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${transaction['currency']}: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: transaction['transactionType'] == 'receipt' ? CupertinoColors.systemBlue : AppColors.red,
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
                                          color: transaction['transactionType'] == 'receipt' ? CupertinoColors.systemBlue : AppColors.red,
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
                          ),
                        );
                      },
                    ),
                  ),],),),
              )
            ],
          );
        },
      ),
    );
  }
}
