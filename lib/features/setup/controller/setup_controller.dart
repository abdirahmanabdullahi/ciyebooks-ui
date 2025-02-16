import 'package:ciyebooks/data/repositories/auth/auth_repo.dart';
import 'package:ciyebooks/features/accounts/model/model.dart';
import 'package:ciyebooks/features/bank/deposit/model/deposit_model.dart';
import 'package:ciyebooks/features/bank/transfers/model/transfer_model.dart';
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

class SetupController extends GetxController {
  static SetupController get instance => Get.find();

  final isLoading = false.obs;
  GlobalKey<FormState> capitalFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> cashKesInHandFormKey = GlobalKey<FormState>();
  Rx<BalancesModel> totals = BalancesModel.empty().obs;
  final setupRepo = Get.put(SetupRepo());

  RxList<AccountModel> accounts = <AccountModel>[].obs;
  RxList<CurrencyModel> currencies = <CurrencyModel>[].obs;

  ///Transaction counters
  final counters = {}.obs;

  final _uid = FirebaseAuth.instance.currentUser!.uid;

  ///
  RxList<PayClientModel> payments = <PayClientModel>[].obs;

  ///
  RxList<ReceiveModel> receipts = <ReceiveModel>[].obs;

  ///
  RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;

  ///
  RxList<WithdrawModel> withdrawals = <WithdrawModel>[].obs;

  ///
  RxList<DepositModel> deposits = <DepositModel>[].obs;

  ///
  RxList<TransferModel> transfers = <TransferModel>[].obs;

  /// fireStore instance
  final _db = FirebaseFirestore.instance;

  @override
  void onInit() {
    /// Stream for the totals

    FirebaseFirestore.instance.collection('Users').doc(_uid).collection('Setup').doc('Balances').snapshots().listen((snapshot) {
      if (snapshot.exists) {
        totals.value = BalancesModel.fromJson(snapshot.data()!);
        counters.value = totals.value.transactionCounters!;
        // currency.value = BalancesModel.fromJson()
      }
    });

    /// Stream for the accounts
    FirebaseFirestore.instance.collection('Users').doc(_uid).collection('accounts').snapshots().listen((querySnapshot) {
      accounts.value = querySnapshot.docs.map((doc) {
        return AccountModel.fromJson(doc.data());
      }).toList();
    });

    /// Stream for currency stock
    FirebaseFirestore.instance.collection('Users').doc(_uid).collection('currencyStock').snapshots().listen((querySnapshot) {
      currencies.clear();
      currencies.value = querySnapshot.docs.map((doc) {
        return CurrencyModel.fromJson(doc.data());
      }).toList();
    });

    /// Stream for transactions
    FirebaseFirestore.instance.collection('Users').doc(_uid).collection('transactions').snapshots().listen((querySnapshot) {
      expenses.clear();
      payments.clear();
      receipts.clear();
      withdrawals.clear();
      deposits.clear();
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
        } else if (transactionType == 'deposit') {
          deposits.add(DepositModel.fromJson(doc.data()));
        } else if (transactionType == 'transfer') {
          transfers.add(TransferModel.fromJson(doc.data()));
        }
      }
    });
    super.onInit();
  }


  /// Update setup status
  Future<void> completeSetup() async {
    try {
      //Start loading
      isLoading.value = true;
      //Check connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        Get.snackbar("Oh snap! No internet connection.", "Please check your internet connection and try again",
            icon: Icon(
              Icons.cloud_off,
              color: Colors.white,
            ),
            backgroundColor: Color(0xffFF0033),
            colorText: Colors.white);
        return;
      }
      final setupStatus = {'AccountIsSetup': true};

      await setupRepo.updateSetupStatus(setupStatus).then((_) {
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Success!",
          'Setup has been completed',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        AuthRepo.instance.screenRedirect();
      });
    } catch (e) {
      Get.snackbar("Oh snap!", e.toString(), backgroundColor: Color(0xffFF0033), colorText: Colors.white);
    }
  }
}
