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

import '../accounts/screens/widgets/account_viewer.dart';
import 'controller/setup_controller.dart';

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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18, 0, 10, 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Cash balances", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                                  TextButton(
                                      onPressed: () => uploadController.uploadRepo.uploadData(context: context, checkList: uploadController.totalsFieldChecklist, fileName: 'totals'),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: CupertinoColors.systemBlue,
                                          ),
                                          Text(
                                            'Add',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.systemBlue),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
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
                          ],
                        ),
                      ),
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18, 0, 10, 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Bank balances", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                                  TextButton(
                                      onPressed: () => uploadController.uploadRepo.uploadData(context: context, checkList: uploadController.totalsFieldChecklist, fileName: 'totals'),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: CupertinoColors.systemBlue,
                                          ),
                                          Text(
                                            'Add',
                                            style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.systemBlue),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
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
                              Padding(
                                padding: const EdgeInsets.fromLTRB(18, 0, 10, 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Currency stock", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                                    TextButton(
                                        onPressed: () => uploadController.uploadCurrencyStock(context),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: CupertinoColors.systemBlue,
                                            ),
                                            Text(
                                              'Add',
                                              style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.systemBlue),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                              Gap(8),
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
                      Container(height: 500,padding: EdgeInsets.all( 8),
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
                        child: SingleChildScrollView(physics: ClampingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(18, 0, 10, 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Accounts", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.prettyDark)),
                                    TextButton(
                                        onPressed: () => uploadController.uploadAccounts(context),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: CupertinoColors.systemBlue,
                                            ),
                                            Text(
                                              'Add',
                                              style: TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.systemBlue),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
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
                                          accountName: data['AccountName'],
                                          accountNumber: data['AccountNo'],
                                          email: data['Email'],
                                          phoneNumber: data['PhoneNo'],
                                          balances: data['Currencies'].entries.expand<Widget>((currency) {
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
                                        child: Container(margin: EdgeInsets.fromLTRB(3,6,3,0),
                                          decoration: BoxDecoration( boxShadow: [
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
                                              // First Row (From, Receiver, Amount)
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: data['AccountName'],
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
                                                          text: data['AccountNo'],
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
                      onPressed: () => showConfirmsetupDialog(context, controller),
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
                      heroTag: 'Reset database',
                      backgroundColor: AppColors.prettyGrey,
                      onPressed: () {
                        showResetDialog(context);
                        // controller.resetDatabase();
                      },
                      child: Text(
                        'Reset setup',
                        style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w600, fontSize: 12),
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

  Future<dynamic> showConfirmsetupDialog(BuildContext context, SetupController controller) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        backgroundColor: AppColors.quarternary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        titlePadding: EdgeInsets.zero,
        title: Column(
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: AppColors.quinary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: Colors.orange,
                    ),
                    Gap(10),
                    Text(
                      'Are you sure?',
                      style: TextStyle(
                        color: CupertinoColors.systemBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 30),
        content: Text(
          'Have you confirmed your totals and other uploaded data? If not, please do so. No hurry!.If done, please proceed to submit the data.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: EdgeInsets.only(bottom: 15),
        actions: [
          SizedBox(
            height: 40,
            width: 100,
            child: FloatingActionButton(
              backgroundColor: AppColors.quinary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                controller.completeSetup();
                Navigator.pop(context);
              },
              child: Text(
                "Submit data",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: SizedBox(
              height: 40,
              width: 100,
              child: FloatingActionButton(
                backgroundColor: AppColors.quinary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> showResetDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        backgroundColor: AppColors.quarternary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        titlePadding: EdgeInsets.zero,
        title: Column(
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: AppColors.quinary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: Colors.orange,
                    ),
                    Gap(10),
                    Text(
                      'Reset items',
                      style: TextStyle(
                        color: CupertinoColors.systemBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 30),
        content: DropdownMenu(
            expandedInsets: EdgeInsets.zero,

            // controller: controller.from,
            trailingIcon: Icon(
              Icons.keyboard_arrow_down_outlined,
              color: CupertinoColors.systemBlue,
            ),
            inputDecorationTheme: InputDecorationTheme(
              fillColor: AppColors.quinary,
              filled: true,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              constraints: BoxConstraints.tight(const Size.fromHeight(45)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            enableSearch: true,
            requestFocusOnTap: true,
            enableFilter: true,
            menuStyle: MenuStyle(
              padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 0, vertical: 6)),
              backgroundColor: WidgetStateProperty.all(AppColors.quinary), // Adjust height here,
              maximumSize: WidgetStateProperty.all(Size(double.infinity, 500)), // Adjust height here
            ),
            label: Text('Select items to reset'),
            selectedTrailingIcon: Icon(
              Icons.search,
              color: CupertinoColors.systemBlue,
            ),
            // width: double.maxFinite,
            onSelected: (value) {},
            dropdownMenuEntries: [
              DropdownMenuEntry(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                      side: WidgetStateProperty.all(
                        BorderSide(width: 2, color: AppColors.quarternary),
                      ),
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ))),
                  value: 'accounts',
                  label: 'accounts'),
            ]),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: EdgeInsets.only(bottom: 15),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SizedBox(
              height: 45,
              width: double.maxFinite,
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: AppColors.quinary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Reset",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
