import 'package:ciyebooks/features/pay/pay_client/pay_client_controller/pay_client_controller.dart';
import 'package:ciyebooks/features/pay/pay_client/pay_client_model/pay_client_model.dart';
import 'package:ciyebooks/features/receive/screens/receive_from_client_form.dart';
import 'package:ciyebooks/navigation_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../../common/styles/custom_container.dart';
import '../../../../utils/constants/colors.dart';
import '../model/receive_model.dart';

class ReceiptsHistory extends StatelessWidget {
  const ReceiptsHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PayClientController());
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    final uid = FirebaseAuth.instance.currentUser?.uid;
    // final usersQuery =
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: CupertinoColors.systemBlue,
          shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.quarternary, width: 2), borderRadius: BorderRadius.circular(20)),
          onPressed: () => Get.offAll(() => ReceiveFromClientForm()),
          child: Icon(Icons.add_circle_outline,
            // Icons.add_circle_outline,
            color: AppColors.quinary,
            size: 35,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        appBar: AppBar(automaticallyImplyLeading: true,leading: IconButton(onPressed: ()=>Get.offAll(NavigationMenu(  )), icon: Icon(Icons.close,color: AppColors.quinary,)),
          backgroundColor:CupertinoColors.systemBlue,
          title: Text('Receipts history',style: TextStyle(color: AppColors.quinary),),
        ),
        body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: SizedBox(
                            height: 30,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.quinary,
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                  padding: EdgeInsets.symmetric(horizontal: 10)),
                              onPressed: () => controller.sortCriteria.value = 'DateCreated',
                              child: Text(
                                'Sort by date',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ), Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: SizedBox(
                            height: 30,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.quinary,
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                  padding: EdgeInsets.symmetric(horizontal: 10)),
                              onPressed: () => controller.sortCriteria.value = 'AccountFrom',
                              child: Text(
                                'Sort by payee',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: SizedBox(
                            height: 30,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.quinary,
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                  padding: EdgeInsets.symmetric(horizontal: 10)),
                              onPressed: () => controller.sortCriteria.value = 'Receiver',
                              child: Text(
                                'Sort by receiver',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: SizedBox(
                            height: 30,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.quinary,
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                  padding: EdgeInsets.symmetric(horizontal: 10)),
                              onPressed: () => controller.sortCriteria.value = 'AmountPaid',
                              child: Text(
                                'Sort by amount',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: SizedBox(
                            height: 30,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.quinary,
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                  padding: EdgeInsets.symmetric(horizontal: 10)),
                              onPressed: () => controller.sortCriteria.value = 'Currency',
                              child: Text(
                                'Sort by Currency',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: SizedBox(
                            height: 30,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.quinary,
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                  padding: EdgeInsets.symmetric(horizontal: 10)),
                              onPressed: () => controller.sortCriteria.value = 'TransactionId',
                              child: Text(
                                'Sort by transactionId',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                ),Divider(),
                Expanded(
                  child: Obx(()=>
                      FirestoreListView<ReceiveModel>(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        query: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(uid)
                            .collection('transactions')
                            .where('transactionType', isEqualTo: 'receipt')
                            .orderBy(controller.sortCriteria.value, descending: true)
                            .withConverter<ReceiveModel>(
                          fromFirestore: (snapshot, _) => ReceiveModel.fromJson(snapshot.data()!),
                          toFirestore: (receipt, _) => receipt.toJson(),
                        ),
                        itemBuilder: (context, snapshot) {
                          ReceiveModel receipt = snapshot.data();

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                            child: CustomContainer(
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
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'From: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: receipt.depositorName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    color: Colors.blue,
                                                    // Black Value
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Gap(3),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Receiver: ',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10,
                                                    color: Colors.grey[600], // Grey Label
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: receipt.receivingAccountName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                    color: Colors.blue,
                                                    // Grey Label
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
                                              text: '${receipt.currency}: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                // fontSize: 12,
                                                fontSize: 10,
                                                color: Colors.grey[600], // Grey Label
                                              ),
                                            ),
                                            TextSpan(
                                              text: formatter
                                                  .format(receipt.amount)
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

                                  // Second Row (Transaction ID, Type, Date)
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
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10,
                                                    color: Colors.grey[600], // Grey Label
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: receipt.transactionType,
                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
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
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10,
                                                    color: Colors.grey[600], // Grey Label
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: receipt.transactionId,
                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
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
                                            // TextSpan(
                                            //   text: 'Date: ',
                                            //   style: TextStyle(
                                            //     fontWeight:
                                            //     FontWeight.w500,
                                            //     fontSize: 12,
                                            //     color: Colors
                                            //         .blue, // Grey Label
                                            //   ),
                                            // ),
                                            TextSpan(
                                              text: DateFormat("dd MMM yyyy HH:mm").format(receipt.dateCreated),
                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
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
                        },
                      ),
                  ),
                ),
              ],
            )));
  }
}
