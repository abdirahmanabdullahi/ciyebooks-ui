import 'package:ciyebooks/features/accounts/model/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repo/repo.dart';

class AccountsController extends GetxController {
  static AccountsController get instance => Get.find();

  final accountRepo = Get.put(AccountsRepo());

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNo = TextEditingController();
  final email = TextEditingController();
  final currency = TextEditingController();
  final amount = TextEditingController();

  GlobalKey<FormState> accountsFormKey = GlobalKey<FormState>();

  Future<void> saveData() async {
    try {
      if (!accountsFormKey.currentState!.validate()) {
        return;
      }
      final Map<String, double> newCurrency = {
        currency.text.trim(): double.tryParse(amount.text.trim()) ?? 0
      };
      final newAccount = AccountModel(
          currencyBalances: newCurrency,
          firstName: firstName.text.trim(),
          lastName: lastName.text.trim(),
          accountNo: DateTime.now().toString(),
          phoneNo: phoneNo.text.trim(),
          email: email.text.trim());

      await accountRepo.savaAccountData(newAccount);
      Get.snackbar(
        "Success!",
        "Capital has been updated successfully.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back();
    } catch (e) {
      Get.snackbar(
        "Issues!",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
