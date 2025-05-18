import 'dart:io';

import 'package:ciyebooks/features/accounts/model/model.dart';
import 'package:ciyebooks/features/bank/deposit/model/deposit_model.dart';
import 'package:ciyebooks/features/forex/model/new_currency_model.dart';
import 'package:ciyebooks/features/receive/model/receipt.dart';
import 'package:ciyebooks/features/setup/models/setup_model.dart';
import 'package:ciyebooks/features/setup/repo/setup_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/error_dialog.dart';
import '../../../data/repositories/auth/auth_repo.dart';
import '../../bank/withdraw/model/withdraw_model.dart';
import '../../pay/models/expense_model.dart';
import '../../pay/models/pay_client_model.dart';

class SetupController extends GetxController {
  static SetupController get instance => Get.find();

  final isLoading = false.obs;
  // GlobalKey<FormState> capitalFormKey = GlobalKey<FormState>();
  // GlobalKey<FormState> cashKesInHandFormKey = GlobalKey<FormState>();
  Rx<BalancesModel> totals = BalancesModel.empty().obs;
  final setup = Get.put(setupRepo());

  RxList<AccountModel> accounts = <AccountModel>[].obs;
  RxList<CurrencyModel> currencies = <CurrencyModel>[].obs;

  ///Transaction counters
  final counters = {}.obs;

  final _uid = FirebaseAuth.instance.currentUser?.uid;

  RxList<PayClientModel> payments = <PayClientModel>[].obs;

  RxList<ReceiveModel> receipts = <ReceiveModel>[].obs;

  RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;

  RxList<WithdrawModel> withdrawals = <WithdrawModel>[].obs;

  RxList<DepositModel> deposits = <DepositModel>[].obs;

  /// For setup totals
  final isCash = true.obs;

  final type = TextEditingController();
  final currency = TextEditingController();
  final amount = TextEditingController();

  /// Reset database


  @override
  void onInit() {
    /// Stream for the totals

    FirebaseFirestore.instance.collection('users').doc(_uid).collection('setup').doc('balances').snapshots().listen((snapshot) {
      if (snapshot.exists) {
        totals.value = BalancesModel.fromJson(snapshot.data()!);
        counters.value = totals.value.transactionCounters;
      }
    });

    /// Stream for the accounts
    FirebaseFirestore.instance.collection('users').doc(_uid).collection('accounts').snapshots().listen((querySnapshot) {
      accounts.value = querySnapshot.docs.map((doc) {
        return AccountModel.fromJson(doc.data());
      }).toList();
    });

    /// Stream for currency stock
    FirebaseFirestore.instance.collection('users').doc(_uid).collection('currencyStock').snapshots().listen((querySnapshot) {
      currencies.clear();
      currencies.value = querySnapshot.docs.map((doc) {
        return CurrencyModel.fromJson(doc.data());
      }).toList();
    });

    super.onInit();
  }

  clearControllers(){
    type.clear();
    amount.clear();
    currency.clear();
  }
  checkInternetConnectionTotals(BuildContext context) async {
    isLoading.value = true;
    try {
      isLoading.value = true;
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isLoading.value = false;
        if (context.mounted) {
          updateTotals(context);
        }
      }
    } on SocketException catch (_) {
      isLoading.value = false;
      if (context.mounted) {
        showErrorDialog(context: context, errorTitle: 'Connection error!', errorText: 'Please check your network connection and try again.');
      }
      return;
    }
  }

  updateTotals(BuildContext context) async {
    try{
      final balancesRef = FirebaseFirestore.instance.collection('users').doc(_uid).collection('setup').doc('balances');
      if (type.text.trim() == 'CASH') {
        await balancesRef.update({'cashBalances.${currency.text.trim()}': double.parse(amount.text.trim())}).then((_) {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        });
      }else{
      await balancesRef.update({'bankBalances.${currency.text.trim()}': double.parse(amount.text.trim())}).then((_) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      });}
    }catch(e){
if(context.mounted){
  showErrorDialog(context: context, errorText: 'Error!', errorTitle: 'There was an error when updating totals. Please try again later.')
;}
    }

  }
  checkInternetConnection(BuildContext context) async {
    isLoading.value = true;
    try {
      isLoading.value = true;
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isLoading.value = false;
        if (context.mounted) {
         completeSetup();
        }
      }
    } on SocketException catch (_) {
      isLoading.value = false;
      if (context.mounted) {
        showErrorDialog(context: context, errorTitle: 'Connection error!', errorText: 'Please check your network connection and try again.');
      }
      return;
    }
  }
  /// Update setup status
  Future<void> completeSetup() async {
    try {
      //Start loading
      isLoading.value = true;
      //Check connectivity
      // final isConnected = await NetworkManager.instance.isConnected();
      // if (!isConnected) {

      final setupStatus = {'accountIsSetup': true};

      await setup.updatesetupStatus(setupStatus).then((_) {
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Success!",
          'setup has been completed',
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
