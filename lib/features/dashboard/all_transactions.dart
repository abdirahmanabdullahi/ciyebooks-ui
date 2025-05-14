import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../common/styles/custom_container.dart';
import '../../../../utils/constants/colors.dart';
import '../bank/deposit/screens/widgets/deposit_success.dart';
import '../bank/withdraw/screens/widgets/withdrawal_success.dart';
import '../forex/ui/widgets/fx_transaction_success.dart';
import '../pay/screens/expense/expense_success_screen.dart';
import '../pay/screens/payments/payment_success_screen.dart';
import '../receive/screens/widgets/receipt_success.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    // final now = DateTime.now();
    // final startOfToday = DateTime(now.year, now.month, now.day);

    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );

    return Scaffold(
      backgroundColor: AppColors.quarternary,
      appBar: AppBar(
        backgroundColor: AppColors.prettyBlue,
        automaticallyImplyLeading: true,
        title: Text(
          'Transaction History',
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.quinary),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            color: AppColors.quinary,
            Icons.arrow_back_ios_rounded,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('transactions').orderBy('dateCreated', descending: true).snapshots(),
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
                      return GestureDetector(
                        onTap: () => showPaymentInfo(
                            context: context,
                            transactionCode: data['transactionId'],
                            payee: data['accountFrom'],
                            payeeAccountNo: data['accountNo'],
                            receiver: Text(
                              data['receiver'],
                            ),
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
                                              text: data['transactionType'].toUpperCase(),
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
                    }
                    else if ((data['transactionType'] == 'receipt')) {
                      return GestureDetector(
                        onTap: () => showReceiptInfo(
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
                                            color: CupertinoColors.systemBlue, // Grey Label
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
                    } else if (data['transactionType'] == 'forex') {
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
                                      ),
                                      Gap(10),
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
                    } else if (data['transactionType'] == 'expense') {
                      return GestureDetector(
                        onTap: () => showExpenseInfo(
                            context: context,
                            transactionCode: data['transactionId'],
                            category: data['category'],
                            amountPaid: data['amountPaid'].toString(),
                            description: data['description'],
                            currency: data['currency'],
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
                                          text: data['category'],
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
                                              .format(data['amountPaid'])
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
                                              text: data['transactionType'].toUpperCase(),
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
                                              text: data['paymentType'],
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
                                              text: data['transactionId'].toUpperCase(),
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
                    }
                    else if (data['transactionType'] == 'deposit') {
                      return GestureDetector(
                        onTap: () {
                          showBankDepositInfo(
                              context: context,
                              currency: data['currency'],
                              amount: data['amount'].toString(),
                              transactionCode: data['transactionId'],
                              description: data['description'],
                              date: data['dateCreated'].toDate(), depositor: data['depositedBy']);
                        },
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
                                          text: 'Bank deposit',
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
                                              text: data['transactionType'].toUpperCase(),
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
                    }
                    else if (data['transactionType'] == 'withdrawal') {
                      return GestureDetector(
                        onTap: () => showBankWithdrawInfo(
                            context: context,
                            currency: data['currency'],
                            amount: data['amount'].toString(),
                            transactionCode: data['transactionId'],
                            withdrawnBy: data['withdrawnBy'],
                            description: data['description'],
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
                                          text: 'Withdrawal',
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
                                              text: data['transactionType'].toUpperCase(),
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

                    } else {
                      return SizedBox.shrink();
                    }

                    // if (data['transactionType'] == 'receipt') {
                    //   return CustomContainer(
                    //     darkColor: AppColors.quinary,
                    //     width: double.infinity,
                    //     padding: EdgeInsets.all(8),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         // First Row (From, Receiver, Amount)
                    //         Row(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             RichText(
                    //               text: TextSpan(
                    //                 children: [
                    //                   TextSpan(
                    //                     text: data['receivingAccountName'],
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 12,
                    //                       color: AppColors.secondary,
                    //                       // Grey Label
                    //                       // Black Value
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             RichText(
                    //               text: TextSpan(
                    //                 children: [
                    //                   TextSpan(
                    //                     text: '${data['currency']}: ',
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.w300,
                    //                       fontSize: 10,
                    //                       color: AppColors.secondary,
                    //                     ),
                    //                   ),
                    //                   TextSpan(
                    //                     text: formatter
                    //                         .format(data['amount'])
                    //                     // text: payment.amountPaid
                    //                         .toString(),
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.w600,
                    //                       fontSize: 12,
                    //                       color: AppColors.red, // Grey Label
                    //                       // Black Value
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //
                    //         Divider(color: Colors.black, thickness: .11),
                    //
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Row(
                    //               mainAxisAlignment: MainAxisAlignment.start,
                    //               children: [
                    //                 RichText(
                    //                   text: TextSpan(
                    //                     children: [
                    //                       TextSpan(
                    //                         text: data['transactionType'].toUpperCase(),
                    //                         style: TextStyle(
                    //                           fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
                    //                           // Grey Label
                    //                           // Black Value
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //                 Gap(10),
                    //                 RichText(
                    //                   text: TextSpan(
                    //                     children: [
                    //                       TextSpan(
                    //                         text: data['receivingAccountNo'],
                    //                         style: TextStyle(
                    //                           fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
                    //                           // Grey Label
                    //                           // Black Value
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //                 Gap(10),
                    //                 RichText(
                    //                   text: TextSpan(
                    //                     children: [
                    //                       TextSpan(
                    //                         text: data['depositType'].toUpperCase(),
                    //                         style: TextStyle(
                    //                           fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
                    //                           // Grey Label
                    //                           // Black Value
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //                 Gap(10),
                    //                 RichText(
                    //                   text: TextSpan(
                    //                     children: [
                    //                       TextSpan(
                    //                         text: '# ',
                    //                         style: TextStyle(
                    //                           fontWeight: FontWeight.w300,
                    //                           fontSize: 10,
                    //                           color: AppColors.secondary,
                    //                           // Grey Label
                    //                         ),
                    //                       ),
                    //                       TextSpan(
                    //                         text: data['transactionId'],
                    //                         style: TextStyle(
                    //                           fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
                    //
                    //                           // Black Value
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //             RichText(
                    //               text: TextSpan(
                    //                 children: [
                    //                   TextSpan(
                    //                     text: DateFormat("dd MMM yyyy HH:mm").format(data['dateCreated'].toDate()).toUpperCase(),
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
                    //                       // Black Value
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   );
                    // }
                    // if (data['transactionType'] == 'expense') {
                    //   return CustomContainer(
                    //     darkColor: AppColors.quinary,
                    //     width: double.infinity,
                    //     padding: EdgeInsets.all(8),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         // First Row (From, Receiver, Amount)
                    //         Row(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             RichText(
                    //               text: TextSpan(
                    //                 children: [
                    //                   TextSpan(
                    //                     text: data['category'],
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 12,
                    //                       color: AppColors.secondary,
                    //                       // Grey Label
                    //                       // Black Value
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             RichText(
                    //               text: TextSpan(
                    //                 children: [
                    //                   TextSpan(
                    //                     text: '${data['currency']}: ',
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.w300,
                    //                       fontSize: 10,
                    //                       color: AppColors.secondary,
                    //                     ),
                    //                   ),
                    //                   TextSpan(
                    //                     text: formatter
                    //                         .format(data['amountPaid'])
                    //                     // text: payment.amountPaid
                    //                         .toString(),
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.w600,
                    //                       fontSize: 12,
                    //                       color: AppColors.red, // Grey Label
                    //                       // Black Value
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //
                    //         Divider(color: Colors.black, thickness: .11),
                    //
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Row(
                    //               mainAxisAlignment: MainAxisAlignment.start,
                    //               children: [
                    //                 RichText(
                    //                   text: TextSpan(
                    //                     children: [
                    //                       TextSpan(
                    //                         text: data['transactionType'].toUpperCase(),
                    //                         style: TextStyle(
                    //                           fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
                    //                           // Grey Label
                    //                           // Black Value
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //
                    //                 Gap(10),
                    //                 RichText(
                    //                   text: TextSpan(
                    //                     children: [
                    //                       TextSpan(
                    //                         text: data['paymentType'].toUpperCase(),
                    //                         style: TextStyle(
                    //                           fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
                    //                           // Grey Label
                    //                           // Black Value
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //                 Gap(10),
                    //                 RichText(
                    //                   text: TextSpan(
                    //                     children: [
                    //                       TextSpan(
                    //                         text: '# ',
                    //                         style: TextStyle(
                    //                           fontWeight: FontWeight.w300,
                    //                           fontSize: 10,
                    //                           color: AppColors.secondary,
                    //                           // Grey Label
                    //                         ),
                    //                       ),
                    //                       TextSpan(
                    //                         text: data['transactionId'].toUpperCase(),
                    //                         style: TextStyle(
                    //                           fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
                    //
                    //                           // Black Value
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //             RichText(
                    //               text: TextSpan(
                    //                 children: [
                    //                   TextSpan(
                    //                     text: DateFormat("dd MMM yyyy HH:mm").format(data['dateCreated'].toDate()).toUpperCase(),
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
                    //                       // Black Value
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   );
                    // }
                    // if (data['transactionType'] == 'deposit') {
                    //   return CustomContainer(
                    //     darkColor: AppColors.quinary,
                    //     width: double.infinity,
                    //     padding: EdgeInsets.all(8),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         // First Row (From, Receiver, Amount)
                    //         Row(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             RichText(
                    //               text: TextSpan(
                    //                 children: [
                    //                   TextSpan(
                    //                     text: data['transactionType'],
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 12,
                    //                       color: AppColors.secondary,
                    //                       // Grey Label
                    //                       // Black Value
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             RichText(
                    //               text: TextSpan(
                    //                 children: [
                    //                   TextSpan(
                    //                     text: '${data['currency']}: ',
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.w300,
                    //                       fontSize: 10,
                    //                       color: AppColors.secondary,
                    //                     ),
                    //                   ),
                    //                   TextSpan(
                    //                     text: formatter
                    //                         .format(data['amount'])
                    //                     // text: payment.amountPaid
                    //                         .toString(),
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.w600,
                    //                       fontSize: 12,
                    //                       color: AppColors.red, // Grey Label
                    //                       // Black Value
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //
                    //         Divider(color: Colors.black, thickness: .11),
                    //
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Row(
                    //               mainAxisAlignment: MainAxisAlignment.start,
                    //               children: [
                    //                 RichText(
                    //                   text: TextSpan(
                    //                     children: [
                    //                       TextSpan(
                    //                         text: data['transactionId'].toUpperCase(),
                    //                         style: TextStyle(
                    //                           fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
                    //                           // Grey Label
                    //                           // Black Value
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //
                    //
                    //                 Gap(10),
                    //                 RichText(
                    //                   text: TextSpan(
                    //                     children: [
                    //                       TextSpan(
                    //                         text: '# ',
                    //                         style: TextStyle(
                    //                           fontWeight: FontWeight.w300,
                    //                           fontSize: 10,
                    //                           color: AppColors.secondary,
                    //                           // Grey Label
                    //                         ),
                    //                       ),
                    //                       TextSpan(
                    //                         text: data['transactionId'],
                    //                         style: TextStyle(
                    //                           fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
                    //
                    //                           // Black Value
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //             RichText(
                    //               text: TextSpan(
                    //                 children: [
                    //                   TextSpan(
                    //                     text: DateFormat("dd MMM yyyy HH:mm").format(data['dateCreated'].toDate()).toUpperCase(),
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.w300, fontSize: 10, color: AppColors.secondary,
                    //                       // Black Value
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   );
                    //   return ListTile(
                    //     dense: true,
                    //     title: Text(
                    //       data['transactionType'],
                    //       style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w700, fontSize: 13),
                    //     ),
                    //     trailing: Text(
                    //       "${data['currency'].toString().toLowerCase()} ${formatter.format(double.parse(data['amount'].toString()))} ",
                    //       style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w700, fontSize: 13),
                    //     ),
                    //   );
                    // }
                    // if (data['transactionType'] == 'withdrawal') {
                    //   return TransactionCard(
                    //     name: data['transactionType'],
                    //     currency: data['currency'],
                    //     amount: formatter.format(double.parse(data['amount'].toString())),
                    //     transactionType: data['transactionType'],
                    //     transactionId: data['transactionId'],
                    //     date: DateFormat("dd MMM yyyy HH:mm").format(data['dateCreated'].toDate()).toUpperCase(),
                    //   );
                    // }
                  })
                  .toList()
                  .cast(),
            );
          },
        ),
      ),
    );
  }
}
