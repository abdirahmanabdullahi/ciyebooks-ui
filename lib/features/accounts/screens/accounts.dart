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
          backgroundColor: CupertinoColors.systemBlue,
          shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.quarternary, width: 2), borderRadius: BorderRadius.circular(20)),
          onPressed: () => showCreateAccountDialog(context),
          child: Icon(
            Icons.add_circle_outline,
            // Icons.add_circle_outline,
            color: AppColors.quinary,
            size: 35,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
              onPressed: () => Get.offAll(() => NavigationMenu()),
              icon: Icon(
                Icons.close,
                color: AppColors.quinary,
              )),
          centerTitle: true,
          backgroundColor: CupertinoColors.systemBlue,
          title: Text(
            'Accounts',
            style: TextStyle(color: AppColors.quinary),
          ),
        ),
        body: SafeArea(bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: FirestoreListView<AccountModel>(reverse: true,
              shrinkWrap: true,
              // physics: ClampingScrollPhysics(),
              query: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(uid)
                  .collection('accounts')
                  .withConverter<AccountModel>(
                    fromFirestore: (snapshot, _) => AccountModel.fromJson(snapshot.data()!),
                    toFirestore: (account, _) => account.toJson(),
                  ),
              itemBuilder: (context, snapshot) {
                // Data is now typed!
                AccountModel account = snapshot.data();

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
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Account name: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  TextSpan(
                                    text: account.accountName,
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
                            Column(crossAxisAlignment: CrossAxisAlignment.end,
                              children: account.currencies.entries.map((entry) {
                                return RichText(
                                    text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${entry.key}: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        // fontSize: 12,
                                        fontSize: 10,
                                        color: Colors.grey[600], // Grey Label
                                      ),
                                    ),
                                    TextSpan(
                                      text: formatter.format(
                                        double.tryParse(entry.value.toString())??0.0,
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        // fontSize: 12,
                                        fontSize: 10,
                                        color: (double.tryParse(entry.value.toString())??0.0)<=0?CupertinoColors.destructiveRed:CupertinoColors.systemBlue // Grey Label
                                      ),
                                    ),
                                  ],
                                ));
                              }).toList(),
                            ),
                          ],
                        ),

                        Divider(color: Colors.grey[400], thickness: 1),

                        // Second Row (Transaction ID, Type, Date)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Account no: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Colors.grey[600], // Grey Label
                                    ),
                                  ),
                                  TextSpan(
                                    text: account.accountNo,
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
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
                                    text: 'Date created: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Colors.grey[600], // Grey Label
                                    ),
                                  ),
                                  TextSpan(
                                    text: DateFormat('dd MMM yyy').format(
                                      account.dateCreated,
                                    ),
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
          height: 60,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create new account',
                  style: TextStyle(
                    color: AppColors.quinary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
        content: Column(
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
                  ],
                ),
              ),
            ),
            Gap(20)
          ],
        ),
        actions: [
          SizedBox(
            height: 40,
            child: OutlinedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20),
                disabledBackgroundColor: const Color(0xff35689fff),
                // backgroundColor: CupertinoColors.systemRed,foregroundColor: AppColors.quinary
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
              height: 40,
              child: Obx(()=>
         ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 20), backgroundColor: CupertinoColors.systemBlue, foregroundColor: AppColors.quinary
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                  onPressed: controller.isLoading.value?null:() => controller.createAccount(context),
                  child: const Text(
                    'Create',
                  ),
                ),
              ),
            ),
          )
        ],
      );
    },
  );
}
