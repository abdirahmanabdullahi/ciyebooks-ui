import 'package:ciyebooks/features/accounts/model/model.dart';
import 'package:ciyebooks/navigation_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/styles/custom_container.dart';
import '../../../utils/constants/colors.dart';
import '../controller/accounts_controller.dart';

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
          elevation: 0,
          backgroundColor: AppColors.prettyDark,
          shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.prettyDark, width: 2), borderRadius: BorderRadius.circular(100)),
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
          actions: [
            IconButton(
                onPressed: () => Get.offAll(() => NavigationMenu()),
                icon: Icon(
                  Icons.close,
                  color: AppColors.prettyDark,
                )),
          ],
          backgroundColor: AppColors.quarternary,
          title: Text(
            'Accounts',
            // style: TextStyle(color: AppColors.quinary),
          ),
        ),
        body: SafeArea(
          bottom: false,
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

              return Padding(
                padding: const EdgeInsets.only(top:  7),
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
                                    color: AppColors.prettyDark,                                    // Grey Label
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
                                    color: AppColors.prettyDark,// Grey Label
                                  ),
                                ),
                                TextSpan(
                                  text: DateFormat('dd MMM yyy').format(
                                    account.dateCreated,
                                  ),
                                  style: TextStyle( fontWeight: FontWeight.w300,
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

Future<dynamic> showCreateAccountDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final controller = Get.put(AccountsController());
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(8),
        backgroundColor: AppColors.quinary,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.systemBlue),
          width: double.maxFinite,
          // height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Create a new client account',
                  style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w500),
                ),
              ),
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: AppColors.quinary,
                  ))
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Form(
                  key: controller.accountsFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'First name is required';
                          }
                          return null;
                        },
                        controller: controller.firstName,
                        decoration: InputDecoration(hintText: 'First name'),
                      ),
                      Gap(6),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Last name is required';
                          }
                          return null;
                        },
                        controller: controller.lastName,
                        decoration: InputDecoration(hintText: 'Last name'),
                      ),
                      Gap(6),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number is required';
                          }
                          return null;
                        },
                        controller: controller.phoneNo,
                        decoration: InputDecoration(hintText: 'Phone number'),
                      ),
                      Gap(6),
                      TextFormField(
                        controller: controller.email,
                        decoration: InputDecoration(hintText: 'Email'),
                      ),
                      Gap(6),
                      TextFormField(
                        controller: controller.usd,
                        decoration: InputDecoration(hintText: 'USD balance'),
                      ),
                      Gap(6),
                      TextFormField(
                        controller: controller.kes,
                        decoration: InputDecoration(hintText: 'KES balance'),
                      ),
                      Gap(20),
                      SizedBox(
                        height: 45,
                        width: double.maxFinite,
                        child: Obx(
                          () => ElevatedButton(
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 20), backgroundColor: CupertinoColors.systemBlue, foregroundColor: AppColors.quinary
                                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                            onPressed: controller.isLoading.value ? null : () => controller.createAccount(context),
                            child: const Text(
                              'Create',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Gap(10),
            ],
          ),
        ),
      );
    },
  );
}
