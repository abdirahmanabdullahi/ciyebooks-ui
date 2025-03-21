import 'package:ciyebooks/features/accounts/model/model.dart';
import 'package:ciyebooks/features/accounts/screens/accounts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../setup/models/setup_model.dart';

class AccountsController extends GetxController {
  static AccountsController get instance => Get.find();

  final counters = {}.obs;
  final isLoading = false.obs;
  Rx<BalancesModel> totals = BalancesModel.empty().obs;

  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser?.uid;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phoneNo = TextEditingController();
  final email = TextEditingController();
  final usd = TextEditingController();
  final kes = TextEditingController();

  GlobalKey<FormState> accountsFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    fetchTotals();

  super.onInit();
  }

  fetchTotals() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('Users').doc(uid).collection('Setup').doc('Balances').get();

    if (documentSnapshot.exists && documentSnapshot.data() != null) {
      final data = documentSnapshot.data() as Map<String, dynamic>;
      totals.value = BalancesModel.fromJson(data);
      print('OnInit');
      print('PA-${totals.value.transactionCounters['accountsCounter']}')
;
    }
  }

  /// Create accounts
  Future<void> createAccount(BuildContext context) async {
    print('Start');
    print('PA-${totals.value.transactionCounters['accountsCounter']}')
;    isLoading.value = true;
    try {
      if (!accountsFormKey.currentState!.validate()) {
        isLoading.value = false;

        return;
      }

      final newAccount = AccountModel(
        currencies: {'USD':double.tryParse( usd.text.trim()), 'KES':double.tryParse( kes.text.trim())},

        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        accountNo: '${totals.value.transactionCounters['accountsCounter']}',
        phoneNo: phoneNo.text.trim(),
        email: email.text.trim(),
        // dateCreated: DateTime.now(),
        accountName: '${firstName.text.trim()}${lastName.text.trim()}', dateCreated: DateTime.now(),
        // usdBalance: 0.0,
        // kesBalance: 0.0
      );

      final batch = db.batch();
      final newAccountRef = db.collection('Users').doc(uid).collection("accounts").doc('PA-${totals.value.transactionCounters['accountsCounter']}');
      final accountNoRef = db.collection('Users').doc(uid).collection("Setup").doc('Balances');

      ///Create new account
      batch.set(newAccountRef, newAccount.toJson());

      ///Update the account number counter
      batch.update(accountNoRef, {"transactionCounters.accountsCounter": FieldValue.increment(1)});
print('End');
      print('PA-${totals.value.transactionCounters['accountsCounter']}');


      await batch.commit().then((_) {
        isLoading.value = false;

        if(context.mounted){
          Navigator.pop(context);

        }Get.offAll(()=>Accounts());
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Success",
          'Account created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
   });
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on TPlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      isLoading.value = false;

      throw 'Something went wrong. Please try again';
    }
    Get.snackbar(
      "Success!",
      "Account has been created.",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Get.back();
  }

  /// Update totals
}
