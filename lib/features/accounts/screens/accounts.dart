import 'package:ciyebooks/features/accounts/model/model.dart';
import 'package:ciyebooks/features/accounts/screens/widgets/account_viewer.dart';
import 'package:ciyebooks/features/accounts/screens/widgets/create_account_form.dart';
import 'package:ciyebooks/navigation_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/styles/custom_container.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class Accounts extends StatelessWidget {
  const Accounts({super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );

    final uid = FirebaseAuth.instance.currentUser?.uid;
    // final controller = Get.put(AccountsController());
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.prettyDark,
          shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.quinary, width: 2.5), borderRadius: BorderRadius.circular(100)),
          onPressed: () => showCreateAccountDialog(context),
          child: Icon(
            Icons.add,
            // Icons.add_circle_outline,
            color: AppColors.quinary,
            // size: 35,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.quinary,
              )),
          // automaticallyImplyLeading: false,
          backgroundColor: AppColors.prettyBlue,
          title: Text(
            'Accounts',
            style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.quinary),
          ),
        ),
        body: SafeArea(
          // bottom: false,
          child: FirestoreListView<AccountModel>(
            reverse: true,
            shrinkWrap: true,
            // physics: ClampingScrollPhysics(),
            query: FirebaseFirestore.instance.collection('Users').doc(uid).collection('accounts').withConverter<AccountModel>(
                  fromFirestore: (snapshot, _) => AccountModel.fromJson(snapshot.data()!),
                  toFirestore: (account, _) => account.toJson(),
                ),
            itemBuilder: (context, snapshot) {
              // Data is now typed!
              AccountModel account = snapshot.data();
              return GestureDetector(
                onTap: () => showAccountDetails(
                    context: context,
                    accountName: account.accountName,
                    accountNumber: account.accountNo,
                    email: account.email,
                    phoneNumber: account.phoneNo,
                    balances: account.currencies.entries.map((currency) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(currency.key,
                                  style: TextStyle(
                                    fontSize: 13,
                                  )),
                              Text(formatter.format(currency.value),
                                  style: TextStyle(
                                    fontSize: 13,color: double.parse(currency.value.toString())<0?AppColors.red:AppColors.prettyDark
                                  )),
                            ],
                          ),
                          Divider(color: Colors.black, thickness: .11),
                        ],
                      );
                    }).toList()),
                child: CustomContainer(
                  darkColor: AppColors.quinary,
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
                              text: account.accountName,
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
                                  text: account.accountNo,
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
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'CREATED AT: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 10,
                                    color: AppColors.prettyDark, // Grey Label
                                  ),
                                ),
                                TextSpan(
                                  text: DateFormat('dd MMM yyy').format(
                                    account.dateCreated,
                                  ),
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
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
