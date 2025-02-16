import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../accounts/model/model.dart';
import '../../bank/deposit/model/deposit_model.dart';
import '../../bank/transfers/model/transfer_model.dart';
import '../../bank/withdraw/model/withdraw_model.dart';
import '../../forex/model/new_currency_model.dart';
import '../../pay/pay_client/pay_client_model/pay_client_model.dart';
import '../../pay/pay_expense/expense_model/expense_model.dart';
import '../../receive/model/receive_model.dart';
import '../../setup/models/setup_model.dart';

class DashboardController extends GetxController{

static DashboardController get instance => Get.find();
Rx<BalancesModel> totals = BalancesModel.empty().obs;
RxList<CurrencyModel> currencies = <CurrencyModel>[].obs;

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
///
RxList<AccountModel> accounts = <AccountModel>[].obs;
@override
  void onInit() {

  /// Stream for the accounts
  FirebaseFirestore.instance.collection('Users').doc(_uid).collection('accounts').snapshots().listen((querySnapshot) {
    accounts.value = querySnapshot.docs.map((doc) {
      return AccountModel.fromJson(doc.data());
    }).toList();
  });
///Totals Stream
  FirebaseFirestore.instance.collection('Users').doc(_uid).collection('Setup').doc('Balances').snapshots().listen((snapshot) {
    if (snapshot.exists) {
      totals.value = BalancesModel.fromJson(snapshot.data()!);
      // currency.value = BalancesModel.fromJson()
    }
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

//
  }
}