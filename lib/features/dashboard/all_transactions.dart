import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../../common/styles/custom_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../navigation_menu.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);

    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );

    return Scaffold(backgroundColor: AppColors.quarternary,
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Get.offAll(NavigationMenu()),
              icon: Icon(
                Icons.close,
                color: AppColors.prettyDark,
              )),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.quarternary,
        title: Text(
          'Transaction history',
          style: TextStyle(fontWeight: FontWeight.w400, color: AppColors.prettyDark),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('transactions')
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

            return ListView(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              children: snapshot.data!.docs
                  .map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    if (data['transactionType'] == 'payment') {
                      return CustomContainer(
                        darkColor: AppColors.quinary,
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
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
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 10,
                                          color: AppColors.secondary,
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
                      );
                    }
                    if (data['transactionType'] == 'receipt') {
                      return CustomContainer(
                        darkColor: AppColors.quinary,
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
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
                      );
                    }
                    if (data['transactionType'] == 'expense') {
                      return CustomContainer(
                        darkColor: AppColors.quinary,
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
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
                      );
                    }
                    if (data['transactionType'] == 'deposit') {
                      return CustomContainer(
                        darkColor: AppColors.quinary,
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
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
                                        text: data['transactionType'],
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
                                            text: data['transactionId'].toUpperCase(),
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
                      // return Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(
                      //             data['transactionType'],
                      //             style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w700, fontSize: 11),
                      //           ),
                      //           Text(
                      //             "${data['currency'].toString().toUpperCase()} ${formatter.format(double.parse(data['amount'].toString()))} ",
                      //             style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w700, fontSize: 11),
                      //           ),
                      //         ],
                      //       ),
                      //       Divider(
                      //         // height: 0,
                      //         thickness: .11,
                      //         color: AppColors.prettyDark,
                      //       )
                      //     ],
                      //   ),
                      // );
                      return TransactionCard(
                        name: data['transactionType'],
                        currency: data['currency'],
                        amount: formatter.format(double.parse(data['amount'].toString())),
                        transactionType: data['transactionType'],
                        transactionId: data['transactionId'],
                        date: DateFormat("dd MMM yyyy HH:mm").format(data['dateCreated'].toDate()).toUpperCase(),
                      );
                    }
                  })
                  .toList()
                  .cast(),
            );
          },
        ),
      ),
    );
    ;
  }
}

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key, required this.name, required this.currency, required this.amount, required this.transactionType, required this.transactionId, required this.date});
  final String name, currency, amount, transactionType, transactionId, date;

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    return CustomContainer(
      darkColor: AppColors.quinary,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
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
                      text: name,
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
                      text: '$currency: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 10,
                        color: AppColors.secondary,
                      ),
                    ),
                    TextSpan(
                      text: amount
                          // text: payment.amountPaid
                     ,
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

          const Divider(color: Colors.black, thickness: .11),

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
                          text: transactionType,
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
                          text: transactionId,
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
                          text: 'paymentType',
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
                          text: 'TransactionId',
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
                      text: date,
                      // text: DateFormat("dd MMM yyyy HH:mm").format(data['dateCreated'].toDate()).toUpperCase(),
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
    );
    ;
  }
}
