import 'package:ciyebooks/features/calculator/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../accounts/model/model.dart';

class PayClientController extends GetxController {
  static PayClientController get instance => Get.find();
  final amount = TextEditingController();
  RxList<AccountModel> accounts = <AccountModel>[].obs;
  final accountName = TextEditingController();

  final NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
  );
final _uid = FirebaseAuth.instance.currentUser?.uid;
  /// *-----------------------------Start of amount keypad----------------------------------*

  void addCharacter(buttonValue) {
    ///Limit the number of decimals
    if (buttonValue == '.' && amount.text.contains('.')) {
      return;
    }

    ///Limit the number of decimal places
    if (amount.text.contains('.')) {
      if (amount.text.split('.')[1].length < 2) {
        amount.text += buttonValue;
      }
      return;
    }

if(amount.text.length>=12){
  return;
}
    ///Add other values
    amount.text += buttonValue;

  }
///Remove characters
  void removeCharacter() {
    if (amount.text.isNotEmpty) {
      amount.text = amount.text.substring(0, amount.text.length - 1);
    }
  }

  /// *-----------------------------End of amount keypad----------------------------------*


  @override
  void onInit() {

    /// Stream for the accounts
    FirebaseFirestore.instance.collection('Users').doc(_uid).collection('accounts').snapshots().listen((querySnapshot) {
      accounts.value = querySnapshot.docs.map((doc) {
        print('account');
        return AccountModel.fromJson(doc.data());
      }).toList();
    });

    super.onInit();


  }



}
