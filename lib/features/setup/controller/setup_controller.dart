import 'package:ciyebooks/features/accounts/model/model.dart';
import 'package:ciyebooks/features/forex/model/new_currency_model.dart';
import 'package:ciyebooks/features/pay/pay_client/pay_client_model/pay_client_model.dart';
import 'package:ciyebooks/features/pay/pay_expense/expense_model/expense_model.dart';
import 'package:ciyebooks/features/receive/model/receive_model.dart';
import 'package:ciyebooks/features/setup/models/setup_model.dart';
import 'package:ciyebooks/features/setup/repo/setup_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/helpers/network_manager.dart';
import '../../bank/withdraw/model/withdraw_model.dart';
import '../../forex/model/new_currency_model.dart';

class SetupController extends GetxController {
  static SetupController get instance => Get.find();

  final isLoading = false.obs;
  GlobalKey<FormState> capitalFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> cashKesInHandFormKey = GlobalKey<FormState>();
  Rx<BalancesModel> totals = BalancesModel.empty().obs;
  final setupRepo = Get.put(SetupRepo());

  RxList<AccountModel> accounts = <AccountModel>[].obs;
  RxList<CurrencyModel> currency = <CurrencyModel>[].obs;

  ///Transaction counters
  final counters = {}.obs;

  final _uid = FirebaseAuth.instance.currentUser!.uid;

  ///
  RxList<PayClientModel> payments = <PayClientModel>[].obs;
  final payClientList = <PayClientModel>[];

  ///
  final receiptsList = <ReceiveModel>[];
  RxList<ReceiveModel> receipts = <ReceiveModel>[].obs;

  ///
  RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;
  final expensesList = <ExpenseModel>[];

  ///
  final withdrawalList = <WithdrawModel>[];
  RxList<WithdrawModel> withdrawals = <WithdrawModel>[].obs;

  /// fireStore instance
  final _db = FirebaseFirestore.instance;
  @override
  void onInit() {
    /// Stream for the totals
    FirebaseFirestore.instance
        .collection('Users')
        .doc(_uid)
        .collection('Setup')
        .doc('Balances')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        totals.value = BalancesModel.fromJson(snapshot.data()!);
        counters.value = totals.value.transactionCounters;
        // currency.value = BalancesModel.fromJson()
      }
    });

    /// Stream for the accounts
    FirebaseFirestore.instance
        .collection('Users')
        .doc(_uid)
        .collection('Accounts')
        .snapshots()
        .listen((querySnapshot) {
      accounts.value = querySnapshot.docs.map((doc) {
        return AccountModel.fromJson(doc.data());
      }).toList();
    });

    /// Stream for currency stock
    FirebaseFirestore.instance
        .collection('Users')
        .doc(_uid)
        .collection('CurrencyStock')
        .snapshots()
        .listen((querySnapshot) {
      currency.value = querySnapshot.docs.map((doc) {
        return CurrencyModel.fromJson(doc.data());
      }).toList();
    });

    /// Stream for transactions
    // FirebaseFirestore.instance
    //     .collection('Users')
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .collection('transactions')
    //     .snapshots()
    //     .listen((querySnapshot) {
    //   payments.value = querySnapshot.docs.map((doc) {
    //     // final data = doc.data();
    //     // final transactionType = data['transactionType'].toString();
    //
    //     return PayClientModel.fromJson(doc.data());
    //   }).toList();
    // });

    FirebaseFirestore.instance
        .collection('Users')
        .doc(_uid)
        .collection('transactions')
        .snapshots()
        .listen((querySnapshot) {
      expenses.clear();
      payments.clear();
      receipts.clear();
      withdrawals.clear();
      // Filter only expenses
      for (var doc in querySnapshot.docs) {
        final transactionType = doc.data()['transactionType'];
        if (doc.exists && transactionType == 'expense') {
          expenses.add(ExpenseModel.fromJson(doc.data()));
        } else if (transactionType == 'payment') {
          payments.add(PayClientModel.fromJson(doc.data()));
        } else if (transactionType == 'receipt') {
          receipts.add(ReceiveModel.fromJson(doc.data()));
        } else if (transactionType == 'withdraw') {
          withdrawals.add(WithdrawModel.fromJson(doc.data()));
        }
      }
    });
    super.onInit();
  }

  Future<void> updatePaymentsCounter() async {
    await _db
        .collection('Users')
        .doc(_uid)
        .collection('Setup')
        .doc('Balances')
        .update({"transactionCounters.paymentsCounter": FieldValue.increment(1)});
  }

  // / Fetch setup data
  // Future<void> fetchBalanceSData() async {
  //   try {
  //     final balances = await SetupRepo.instance.getSetupData();
  //     this.balances(balances);
  //   } catch (e) {
  //     Get.snackbar("There was an error fetching data",
  //         "Please check your internet connection and try again",
  //         icon: Icon(
  //           Icons.cloud_off,
  //           color: Colors.white,
  //         ),
  //         backgroundColor: Color(0xffFF0033),
  //         colorText: Colors.white);
  //
  //     balances(BalancesModel.empty());
  //   }
  // }

  /// Save setup data to firestore
  Future<void> saveSetupData() async {
    try {
      //Start loading
      isLoading.value = true;
      //Check connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        Get.snackbar("Oh snap! No internet connection.",
            "Please check your internet connection and try again",
            icon: Icon(
              Icons.cloud_off,
              color: Colors.white,
            ),
            backgroundColor: Color(0xffFF0033),
            colorText: Colors.white);
        return;
      }

      // final newSetup = BalancesModel(
      //   shillingAtBank: double.tryParse(shillingAtBank.text.trim())??0.0,
      //   shillingCashInHand: double.tryParse(shillingCashBalance.text.trim())??0.0,
      //   shillingReceivable: double.tryParse(shillingReceivable.text.trim())??0.0,
      //   shillingPayable: double.tryParse(shillingPayable.text.trim())??0.0,
      //   dollarAtBank: double.tryParse(dollarAtBank.text.trim())??0.0,
      //   dollarCashInHand: double.tryParse(dollarCashInHand.text.trim())??0.0,
      //   dollarReceivable: double.tryParse(dollarReceivable.text.trim())??0.0,
      //   dollarPayable: double.tryParse(dollarPayable.text.trim())??0.0,
      //   averageRateOfDollar: double.tryParse(averageRateOfDollar.text.trim())??0.0,
      //   workingCapital: double.tryParse(workingCapital.text.trim())??0.0,
      // );

      // final setupRepo = Get.put(SetupRepo());
      // await setupRepo.saveSetupData(newSetup);

      ///Success message
      // Get.snackbar('Congratulations', ' Account setup complete',
      //     backgroundColor: Colors.green, colorText: Colors.white);

      ///Go to ScreenRedirect
      // AuthRepo.instance.screenRedirect();
    } catch (e) {
      Get.snackbar("Oh snap!", e.toString(),
          backgroundColor: Color(0xffFF0033), colorText: Colors.white);
    }
  }

  ///Update capital
  // Future<void> setupCapital() async {
  //   final setupRepo = Get.put(SetupRepo());
  //
  //   try {
  //     // Validate the form before proceeding
  //     if (!capitalFormKey.currentState!.validate()) {
  //       return;
  //     }
  //     final connection = await NetworkManager.instance.isConnected();
  //     connection
  //         ? null
  //         : Get.snackbar(
  //             "Success!",
  //             "Capital has been saved locally and will sync once you're online.",
  //             backgroundColor: Colors.blue,
  //             colorText: Colors.white,
  //           );
  //
  //     // Prepare data to update
  //     // Map<String, dynamic> capitalBalance = {
  //     //   'Capital': double.tryParse(capital.text.trim()) ?? 00,
  //     // };
  //
  //     // Update the single field in the repository
  //     await setupRepo.updateSingleField(capitalBalance);
  //     Get.back();
  //
  //     // Notify the user of success
  //     Get.snackbar(
  //       "Success!",
  //       "Capital has been updated successfully.",
  //       backgroundColor: Colors.green,
  //       colorText: Colors.white,
  //     );
  //   } catch (e) {
  //     // Handle errors and notify the user
  //     print(e.toString());
  //     Get.snackbar(
  //       "Oh snap!",
  //       e.toString(),
  //       backgroundColor: Colors.black,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

  ///Update kenya shilling cash in hand
  // Future<void> updateKesCashInHand() async {
  //   final setupRepo = Get.put(SetupRepo());
  //
  //   try {
  //     // Validate the form before proceeding
  //     if (!cashKesInHandFormKey.currentState!.validate()) {
  //       return;
  //     }
  //
  //     // Prepare data to update
  //     Map<String, dynamic> balances = {
  //       'KesCashBalance': double.tryParse(kesCashBalance.text.trim()) ?? 00,
  //       'KesBankBalance': double.tryParse(kesBankBalance.text.trim()) ?? 00,
  //     };
  //
  //     // Update the single field in the repository
  //     await setupRepo.updateSingleField(balances);
  //     Get.back();
  //
  //     // Notify the user of success
  //     Get.snackbar(
  //       "Success!",
  //       "Capital has been updated successfully.",
  //       backgroundColor: Colors.green,
  //       colorText: Colors.white,
  //     );
  //   } catch (e) {
  //     // Handle errors and notify the user
  //     print(e.toString());
  //     Get.snackbar(
  //       "Oh snap!",
  //       e.toString(),
  //       backgroundColor: Colors.black,
  //       colorText: Colors.white,
  //     );
  //   }
  // }
}

// final paymentDocs = querySnapshot.docs
//     .where((doc) => doc.data()['transactionType'] == 'payment')
//     .map((doc) => PayClientModel.fromJson(doc.data()))
//     .toList();
// final expenseDocs = querySnapshot.docs
//     .where((doc) => doc.data()['transactionType'] == 'expense')
//     .map((doc) => ExpenseModel.fromJson(doc.data()))
//     .toList();
