import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../common/styles/custom_container.dart';
import '../../../../utils/constants/colors.dart';


class Withdrawals extends StatefulWidget {
  const Withdrawals({super.key});

  @override
  WithdrawalsState createState() => WithdrawalsState();
}
final NumberFormat formatter = NumberFormat.decimalPatternDigits(
  locale: 'en_us',
  decimalDigits: 2,
);

class WithdrawalsState extends State<Withdrawals> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('transactions')
      .where('transactionType', isEqualTo: 'withdrawal')
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
            return Padding(
              padding: const EdgeInsets.fromLTRB(3.0,3,3,0),
              child: CustomContainer(
                border: Border.all(color: AppColors.grey, width: .5),
                darkColor: AppColors.quinary,
                width: double.infinity,
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First Row (From, Receiver, Amount)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Withdrawn by: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                              TextSpan(
                                text: data['withdrawnBy'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.blue,
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
                                  fontWeight: FontWeight.w500,
                                  // fontSize: 12,
                                  fontSize: 10,
                                  color: Colors.grey[600], // Grey Label
                                ),
                              ),
                              TextSpan(
                                text: formatter
                                    .format(data['amount'])
                                // text: payment.amountPaid
                                    .toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: Colors.redAccent, // Grey Label
                                  // Black Value
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Divider(color: Colors.grey[400], thickness: 1),

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
                                    text: 'Type: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                      color: Colors.grey[600], // Grey Label
                                    ),
                                  ),
                                  TextSpan(
                                    text: data['transactionType'],
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10, color: Colors.blue // Grey Label
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
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                      color: Colors.grey[600], // Grey Label
                                    ),
                                  ),
                                  TextSpan(
                                    text: data['transactionId'],
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10, color: Colors.blue // Grey Label
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
                                text: DateFormat("dd MMM yyyy HH:mm").format(data['dateCreated'].toDate()),
                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10, color: Colors.blue // Grey Label
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
