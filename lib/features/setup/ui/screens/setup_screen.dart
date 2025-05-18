import 'dart:io';

import 'package:ciyebooks/data/repositories/auth/auth_repo.dart';
import 'package:ciyebooks/features/setup/controller/upload_controller.dart';

import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/error_dialog.dart';
import '../../../accounts/screens/widgets/account_viewer.dart';
import '../../../stats/controllers/ui/totals_dropdown.dart';
import '../../controller/setup_controller.dart';
import '../widgets/confirm_setup_dialog.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uploadController = Get.put(UploadController());
    final controller = Get.put(SetupController());
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.prettyBlue,
        title: Text(
          'Account setup',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.quinary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    // horizontal: 3,
                    vertical: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      //   child: Text(
                      //     'Account setup',
                      //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      // Divider(
                      //   thickness: .5,
                      //   color: Colors.black,
                      //   height: 0,
                      // ),Gap(10),
                      Container(
                        margin: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.quinary,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(30),
                              blurRadius: 4,
                              offset: Offset(-3, 3),
                            )
                          ],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(14),
                                  topRight: Radius.circular(14),
                                ),
                                color: AppColors.prettyBlue,
                              ),
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Totals", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.quinary)),
                                  TextButton(
                                      onPressed: () => showAddTotals(context),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: AppColors.quinary,
                                          ),
                                          Text(
                                            'Update',
                                            style: TextStyle(fontWeight: FontWeight.bold, color:AppColors.quinary),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            Gap(10),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Text("Cash balances", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 6),
                              child: Obx(() => Column(
                                    children: controller.totals.value.cashBalances.entries.map((entry) {
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(entry.key, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                                                Text(formatter.format(entry.value), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.prettyDark)),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 0,
                                            thickness: .11,
                                            color: AppColors.prettyDark,
                                          )
                                        ],
                                      );
                                    }).toList(),
                                  )),
                            ),
                            Gap(15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: Text("Bank balances", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
                                  child: Obx(() => Column(
                                        children: controller.totals.value.bankBalances.entries.map((entry) {
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(entry.key, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                                                    Text(formatter.format(entry.value), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.prettyDark)),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                height: 0,
                                                thickness: .11,
                                                color: AppColors.prettyDark,
                                              )
                                            ],
                                          );
                                        }).toList(),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Obx(() {
                        return Container(
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.quinary,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(30),
                                blurRadius: 4,
                                offset: Offset(-3, 3),
                              )
                            ],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(14),
                                  topRight: Radius.circular(14),
                                ),
                                color: AppColors.prettyBlue,
                              ),
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Currency stock", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.quinary)),
                                  TextButton(
                                                              onPressed: () => uploadController.checkInternetConnection(context),
                                      child: Row(
                                        children: [
                                          Icon(size: 25,
                                            Icons.upload_file_outlined,
                                            color: AppColors.quinary,
                                          ),Gap(3),
                                          Text(
                                            'Upload',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.quinary),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                              Gap(10),

                              controller.totals.value.currenciesAtCost == 0
                                  ? SizedBox(
                                      width: double.maxFinite,
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Center(child: Text('No foreign currencies available.')),
                                      ),
                                    )
                                  : Obx(
                                      () {
                                        return SingleChildScrollView(
                                          physics: ClampingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          child: Container(
                                            color: AppColors.quinary,
                                            width: MediaQuery.sizeOf(context).width,
                                            child: DataTable(
                                                dataRowMaxHeight: 40,
                                                dataRowMinHeight: 40,
                                                showBottomBorder: true,
                                                headingTextStyle: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w600),
                                                columnSpacing: 30,
                                                headingRowHeight: 40,
                                                horizontalMargin: 0,
                                                columns: [
                                                  DataColumn(label: Text(' Name')),
                                                  DataColumn(label: Text('Amount')),
                                                  DataColumn(label: Text('Rate')),
                                                  DataColumn(label: Text('Total ')),
                                                ],
                                                rows: controller.currencies.map((currency) {
                                                  return DataRow(cells: [
                                                    DataCell(Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Text(
                                                        currency.currencyCode,
                                                        style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w400),
                                                      ),
                                                    )),
                                                    DataCell(
                                                      Text(
                                                        formatter.format(
                                                          currency.amount,
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(Text(
                                                      currency.amount <= 0 ? '0.0' : formatter.format(currency.totalCost / currency.amount),
                                                    )),
                                                    DataCell(Text(
                                                      formatter.format(currency.totalCost),
                                                    )),
                                                  ]);
                                                }).toList()),
                                          ),
                                        );
                                      },
                                    ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Cost of currencies", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark)),
                                    Obx(() => Text(formatter.format(double.parse(controller.totals.value.currenciesAtCost.toString())),
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.prettyDark))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      Container(
                        height: 500,
                        // padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.quinary,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(30),
                              blurRadius: 4,
                              offset: Offset(-3, 3),
                            )
                          ],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                  ),
                                  color: AppColors.prettyBlue,
                                ),
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Accounts", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.quinary)),
                                    TextButton(
                                        onPressed: ()async {

                                          try {
                                            final result = await InternetAddress.lookup('example.com');
                                            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                              if (context.mounted) {
                                                uploadController.uploadAccounts(context);
                                              }
                                            }
                                          } on SocketException catch (_) {
                                            if (context.mounted) {
                                              showErrorDialog(context: context, errorTitle: 'Connection error!', errorText: 'Please check your network connection and try again.');
                                            }
                                            return;
                                          }
                                          },
                                        child: Row(
                                          children: [
                                            Icon(size: 25,
                                              Icons.upload_file_outlined,
                                              color: AppColors.quinary,
                                            ),Gap(3),
                                            Text(
                                              'Upload',
                                              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.quinary),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                              Gap(10),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('accounts').snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }

                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Text("Loading");
                                  }

                                  return Column(
                                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                      return GestureDetector(
                                        onTap: () => showAccountDetails(
                                          context: context,
                                          accountName: data['accountName'],
                                          accountNumber: data['accountNo'],
                                          email: data['email'],
                                          phoneNumber: data['phoneNo'],
                                          balances: data['currencies'].entries.expand<Widget>((currency) {
                                            return [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(currency.key, style: TextStyle(fontSize: 13)),
                                                  Text(
                                                    formatter.format(currency.value),
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: double.parse(currency.value.toString()) < 0 ? AppColors.red : AppColors.prettyDark,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(color: Colors.black, thickness: .11),
                                            ];
                                          }).toList(),
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(3, 6, 3, 0),
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withAlpha(30),
                                                blurRadius: 4,
                                                offset: Offset(-3, 3),
                                              )
                                            ],
                                            borderRadius: BorderRadius.circular(10),
                                            color: AppColors.quinary,
                                          ),
                                          width: double.infinity,
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: data['accountName'],
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 13,
                                                        color: AppColors.secondary,
                                                        // Black Value
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Divider(color: AppColors.prettyDark, thickness: .11),

                                              // Second Row (Transaction ID, Type, Date)
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'ACCOUNT NO: ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w300,
                                                            fontSize: 10,
                                                            color: AppColors.prettyDark, // Grey Label
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: data['accountNo'],
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w300,
                                                            fontSize: 10,
                                                            color: AppColors.prettyDark, // Grey Label
                                                            // Black Value
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // RichText(
                                                  //   text: TextSpan(
                                                  //     children: [
                                                  //       TextSpan(
                                                  //         text: 'CREATED AT: ',
                                                  //         style: TextStyle(
                                                  //           fontWeight: FontWeight.w300,
                                                  //           fontSize: 10,
                                                  //           color: AppColors.prettyDark, // Grey Label
                                                  //         ),
                                                  //       ),
                                                  //       TextSpan(
                                                  //         text: DateFormat('dd MMM yyy').format(
                                                  //           account.dateCreated,
                                                  //         ),
                                                  //         style: TextStyle(
                                                  //           fontWeight: FontWeight.w300,
                                                  //           fontSize: 10,
                                                  //           color: AppColors.prettyDark, // Grey Label
                                                  //           // Black Value
                                                  //         ),
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                              Gap(6)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(100),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: FloatingActionButton(
                      heroTag: 'Complete',
                      backgroundColor: AppColors.prettyBlue,
                      onPressed: () => showCompleteSetupDialog(context:context, errorText: 'Please make sure all your data is correct and accurate.', errorTitle: 'Is your data accurate?', ),
                      child: Text(
                        'Complete setup',
                        style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: FloatingActionButton(
                      heroTag: 'Res1231et',
                      backgroundColor: AppColors.prettyGrey,
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut().then((_) {
                          AuthRepo.instance.screenRedirect();
                        });
                        // controller.resetDatabase();
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
