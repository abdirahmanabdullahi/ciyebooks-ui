import 'package:ciyebooks/features/accounts/model/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repo/repo.dart';

class AccountsController extends GetxController {
  static AccountsController get instance => Get.find();

  final accountRepo = Get.put(AccountsRepo());

  /// Tried using bool ie true or false but it kept on being reset to true in the save data method.
  /// Now using 0 and 1.
  /// 0== negative;
  /// 1==positive
// final changeToNegative = 0.obs;
  final usdIsNegative = true.obs;
  final kesIsNegative = true.obs;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNo = TextEditingController();
  final email = TextEditingController();
  final usd = TextEditingController();
  final kes = TextEditingController();
  final amount = TextEditingController();

  GlobalKey<FormState> accountsFormKey = GlobalKey<FormState>();

/// Create accounts
  Future<void> createAccount() async {

    try {
      if (!accountsFormKey.currentState!.validate()) {
        return;
      }
      final Map<String, double> newCurrency = {
        'USD': 0,'KES':0,
      };
      final date = DateTime.now();
      print('Value in the saveData method');
      final accountNo =
          '${date.millisecond}${date.second}${date.minute}-${date.hour}${date.day}${date.month}${date.year}';
      final newAccount = AccountModel(
          // usdBalance: usdIsNegative.value
          //     ? -(double.tryParse(usd.text.trim()) ?? 0.0) // Negate the value if `makeItNegative` is true
          //     : (double.tryParse(usd.text.trim()) ?? 0.0),
          // kesBalance: kesIsNegative.value
          //     ? -(double.tryParse(kes.text.trim()) ?? 0.0) // Negate the value if `makeItNegative` is true
          //     : (double.tryParse(kes.text.trim()) ?? 0.0),
          firstName: firstName.text.trim(),
          lastName: lastName.text.trim(),
          accountNo: accountNo,
          phoneNo: phoneNo.text.trim(),
          email: email.text.trim(),
          dateCreated: date, usdBalance: 0.0, kesBalance: 0.0, accountName: '${firstName.text.trim()}  ${lastName.text.trim()}');

      await accountRepo.savaAccountData(
        newAccount,
      );
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

/// Update totals
