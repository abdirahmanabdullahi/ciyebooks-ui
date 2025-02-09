import 'dart:convert';

import 'package:ciyebooks/features/accounts/model/model.dart';
import 'package:ciyebooks/features/accounts/repo/repo.dart';
import 'package:ciyebooks/features/bank/deposit/model/deposit_model.dart';
import 'package:ciyebooks/features/bank/deposit/repo/deposit_repo.dart';
import 'package:ciyebooks/features/bank/withdraw/model/withdraw_model.dart';
import 'package:ciyebooks/features/bank/withdraw/repo/withdrawRepo.dart';
import 'package:ciyebooks/features/pay/pay_client/pay_client_repo/pay_client_repo.dart';
import 'package:ciyebooks/features/pay/pay_expense/expense_model/expense_model.dart';
import 'package:ciyebooks/features/pay/pay_expense/expense_repo/expense_repo.dart';
import 'package:ciyebooks/features/receive/model/receive_model.dart';
import 'package:ciyebooks/features/receive/repository/receipt_repo.dart';
import 'package:ciyebooks/features/setup/models/setup_model.dart';
import 'package:ciyebooks/features/setup/repo/upload_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../pay/pay_client/pay_client_model/pay_client_model.dart';
import '../repo/setup_repo.dart';

class UploadController extends GetxController {
  static UploadController get instance => Get.find();
  final _accountRepo = Get.put(AccountsRepo());
  final _setupRepo = Get.put(SetupRepo());
  final _payClientRepo = Get.put(PayClientRepo());
  final _expenseRepo = Get.put(ExpenseRepo());
  final _receiptRepo = Get.put(ReceiptRepo());
  final _withdrawalRepo = Get.put(WithdrawRepo());
  final _depositRepo = Get.put(DepositRepo());
  Rx<BalancesModel> totals = BalancesModel.empty().obs;
  final counters = {}.obs;
  final _db = FirebaseFirestore.instance;

  @override
  void onInit() {
    /// Stream for the totals
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Setup')
        .doc('Balances')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        totals.value = BalancesModel.fromJson(snapshot.data()!);
        counters.value = totals.value.transactionCounters;
      }
    });

    super.onInit();
  }

  ///Method to update the counters
  Future<void> updateCounter(String counterToUpdate) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Setup')
        .doc('Balances')
        .update({"transactionCounters.$counterToUpdate": FieldValue.increment(1)});
  }

  ///Todo: upload totals
  Future<void> uploadTotals() async {
    try {
      final uploadRepo = Get.put(UploadRepo());
      final setupRepo = Get.put(SetupRepo());
      final result = await uploadRepo.uploadFile();
      final lines = result?.readAsLinesSync(encoding: utf8);

      // var accountNo = int.tryParse(
      //     '${date.millisecond}${date.second}${date.minute}${date.hour}${date.day}${date.month}${date.year}') ??
      //     0;
      Map<String, double> parsedTotals = {};

      for (var line in lines!) {
        final splitLine = line.split(',');
        final key = splitLine[0];
        final value = double.tryParse(splitLine[1]) ?? 0.0;
        parsedTotals[key] = value;
      }
      final convertedDollarTotal = (parsedTotals['dollarAtBank']! +
              parsedTotals['dollarCashInHand']! +
              parsedTotals['dollarReceivable']! -
              parsedTotals['dollarPayable']!) *
          parsedTotals['averageRateOfDollar']!;

      final shillingTotal = parsedTotals['shillingAtBank']! +
          parsedTotals['shillingCashInHand']! +
          parsedTotals['shillingReceivable']! -
          parsedTotals['shillingPayable']!;

      final totals = BalancesModel(
        shillingAtBank: parsedTotals['shillingAtBank'] ?? 0.0,
        shillingCashInHand: parsedTotals['shillingCashInHand'] ?? 0.0,
        shillingReceivable: parsedTotals['shillingReceivable'] ?? 0.0,
        shillingPayable: parsedTotals['shillingReceivable'] ?? 0.0,
        dollarAtBank: parsedTotals['dollarAtBank'] ?? 0.0,
        dollarCashInHand: parsedTotals['dollarCashInHand'] ?? 0.0,
        dollarReceivable: parsedTotals['dollarReceivable'] ?? 0.0,
        dollarPayable: parsedTotals['dollarPayable'] ?? 0.0,
        expenses: parsedTotals['expenses'] ?? 0.0,
        averageRateOfDollar: parsedTotals['averageRateOfDollar'] ?? 0.0,
        workingCapital: 0.0,
        payments: 0234234234234234.0,
        deposits: 0.0,
        receipts: 0.0,
        transfers: 0.0,
        withdrawals: 0.0,
        currenciesAtCost: 0.0,
        inflows: {'USD': 0.0, 'KES': 0.0},
        outflows: {'USD': 0.0, 'KES': 0.0},
        transactionCounters: {
          'paymentsCounter': 0,
          'receiptsCounter': 0,
          'transfersCounter': 0,
          'expenseCounter': 0,
          'buyFxCounter': 0,
          'selFxCounter': 0,
          'accountsCounter': 0,
          'bankDepositCounter': 0,
          'bankWithdrawCounter': 0,
          'bankTransferCounter': 0,
          'internalTransferCounter': 0,
        },
      );

      /// Save the data to firestore

      await _setupRepo.saveSetupData(
        totals,
      );

      Get.snackbar(
        "Success!",
        'Balances update complete',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  ///Todo: upload accounts
  Future<void> uploadAccounts() async {
    print(']]]]]-----------------------------before--------------------------------------------');
    print(counters['accountsCounter']);
    try {
      final uploadRepo = Get.put(UploadRepo());
      final setupRepo = Get.put(SetupRepo());
      final result = await uploadRepo.uploadFile();
      final lines = result?.readAsLinesSync(encoding: utf8);
      lines?.removeAt(0);
      final batch = _db.batch();

      int accountsCounter = 1000;

      for (var line in lines!) {
        final splitLine = line.split(',');
        if (splitLine.length < 5) {
          print(splitLine);
          print(
              '////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////');
          print(splitLine);
        }
        final newAccount = AccountModel(
            usdBalance: double.tryParse(splitLine[4]) ?? 0.0,
            kesBalance: double.tryParse(splitLine[5]) ?? 0.0,
            dateCreated: DateTime.now(),
            firstName: splitLine[0],
            lastName: splitLine[1],
            accountNo: '$accountsCounter',
            phoneNo: splitLine[2],
            email: splitLine[3]);

        final newAccountRef = _db
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("Accounts")
            .doc('PA$accountsCounter');

        ///CREATE THE ACCOUNT
        batch.set(newAccountRef, newAccount.toJson());

        ///UPDATE THE COUNTER
        ///  .collection('Users')
        //         .doc(FirebaseAuth.instance.currentUser?.uid)
        //         .collection('Setup')
        //         .doc('Balances')
        //         .update({"transactionCounters.$counterToUpdate": FieldValue.increment(1)});
        //   }
        accountsCounter++;

      }
      final counterRef = _db
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('Setup')
          .doc('Balances');
      batch.update(counterRef, {"transactionCounters.accountsCounter": accountsCounter});


      await batch.commit().then((_) {
        Get.snackbar(
          "Success!",
          result.toString(),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
         });

    } catch (e) {
      throw e.toString();
    }
  }

  ///Todo: upload payments
  Future<void> uploadPayments() async {
    try {
      final uploadRepo = Get.put(UploadRepo());
      final setupRepo = Get.put(SetupRepo());
      final result = await uploadRepo.uploadFile();
      final lines = result?.readAsLinesSync(encoding: utf8);
      lines?.removeAt(0);

      for (var line in lines!) {
        final splitLine = line.split(',');

        final newPayment = PayClientModel(
          transactionId: splitLine[1],
          accountFrom: splitLine[1],
          currency: splitLine[3],
          amountPaid: double.tryParse(splitLine[4]) ?? 0.0,
          receiver: splitLine[2],
          dateCreated: DateFormat("dd/MM/yyyy").parse(splitLine[0]),
          description: splitLine[5],
          transactionType: 'payment',
        );

        /// Save the data to firestore
        try {
          await _payClientRepo.savePaymentRecord(
            newPayment,
          );

          // Get.snackbar('Success', 'Account created',backgroundColor: Colors.green);
        } catch (e) {
          Get.snackbar('Failed', 'No account created', backgroundColor: Colors.red);
        }
        // } else {
        //   Get.snackbar('Skipped', 'Data too short');
        // }
      }

      Get.snackbar(
        "Success!",
        result.toString(),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  ///Todo: upload expenses
  Future<void> uploadExpense() async {
    try {
      final uploadRepo = Get.put(UploadRepo());
      final setupRepo = Get.put(SetupRepo());
      final result = await uploadRepo.uploadFile();
      final lines = result?.readAsLinesSync(encoding: utf8);
      lines?.removeAt(0);

      for (var line in lines!) {
        final splitLine = line.split(',');

        final newExpense = ExpenseModel(
            transactionType: 'expense',
            transactionId: splitLine[1],
            category: splitLine[1],
            description: splitLine[4],
            dateCreated: DateFormat("dd/MM/yyyy").parse(splitLine[0]),
            currency: splitLine[2],
            amountPaid: double.tryParse(splitLine[3]) ?? 0.0);

        /// Save the data to firestore
        try {
          await _expenseRepo.recordExpense(
            newExpense,
          );

          // Get.snackbar('Success', 'Account created',backgroundColor: Colors.green);
        } catch (e) {
          Get.snackbar('Failed', 'No account created', backgroundColor: Colors.red);
        }
        // } else {
        //   Get.snackbar('Skipped', 'Data too short');
        // }
      }

      Get.snackbar(
        "Success!",
        result.toString(),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  ///Todo: upload receipts
  Future<void> uploadReceipts() async {
    try {
      final uploadRepo = Get.put(UploadRepo());
      final setupRepo = Get.put(SetupRepo());
      final result = await uploadRepo.uploadFile();
      final lines = result?.readAsLinesSync(encoding: utf8);
      lines?.removeAt(0);

      for (var line in lines!) {
        final splitLine = line.split(',');

        final newReceipt = ReceiveModel(
            transactionType: 'receipt',
            transactionId: splitLine[1],
            description: splitLine[5],
            dateCreated: DateFormat("dd/MM/yyyy").parse(splitLine[0]),
            currency: splitLine[3],
            amount: double.tryParse(splitLine[4]) ?? 0.0,
            depositorName: splitLine[1],
            receivingAccountName: splitLine[1],
            receivingAccountNo: '65975679587956');

        /// Save the data to firestore
        try {
          await _receiptRepo.recordReceipt(
            newReceipt,
          );

          // Get.snackbar('Success', 'Account created',backgroundColor: Colors.green);
        } catch (e) {
          Get.snackbar('Failed', 'No account created', backgroundColor: Colors.red);
        }
        // } else {
        //   Get.snackbar('Skipped', 'Data too short');
        // }
      }

      Get.snackbar(
        "Success!",
        result.toString(),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  ///Todo: upload withdrawals
  Future<void> uploadWithdrawals() async {
    try {
      final uploadRepo = Get.put(UploadRepo());
      final setupRepo = Get.put(SetupRepo());
      final result = await uploadRepo.uploadFile();
      final lines = result?.readAsLinesSync(encoding: utf8);
      lines?.removeAt(0);

      for (var line in lines!) {
        final splitLine = line.split(',');

        final newWithdrawal = WithdrawModel(
            transactionType: 'withdraw',
            transactionId: 'transaction12134nId',
            currency: 'currency',
            amount: 0,
            dateCreated: DateFormat("dd/MM/yyyy").parse(splitLine[0]),
            withdrawalType: 'Cheque',
            withdrawnBy: 'Abdullahi Abdi');

        /// Save the data to firestore
        try {
          await _withdrawalRepo.recordWithdrawal(
            newWithdrawal,
          );

          // Get.snackbar('Success', 'Account created',backgroundColor: Colors.green);
        } catch (e) {
          Get.snackbar('Failed', 'No account created', backgroundColor: Colors.red);
        }
        // } else {
        //   Get.snackbar('Skipped', 'Data too short');
        // }
      }

      Get.snackbar(
        "Success!",
        result.toString(),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  ///Todo: upload withdrawals
  Future<void> uploadDeposits() async {
    try {
      final uploadRepo = Get.put(UploadRepo());
      final setupRepo = Get.put(SetupRepo());
      final result = await uploadRepo.uploadFile();
      final lines = result?.readAsLinesSync(encoding: utf8);
      lines?.removeAt(0);

      for (var line in lines!) {
        final splitLine = line.split(',');

        final newDeposit = DepositModel(
            transactionType: 'deposit',
            transactionId: 'transaction12134nId',
            currency: 'USD',
            amount: 400,
            dateCreated: DateFormat("dd/MM/yyyy").parse(splitLine[0]),
            depositType: 'Cheque',
            depositedBy: 'Abdullahi Abdi');

        /// Save the data to firestore
        try {
          await _depositRepo.recordDeposit(
            newDeposit,
          );

          // Get.snackbar('Success', 'Account created',backgroundColor: Colors.green);
        } catch (e) {
          Get.snackbar('Failed', 'No account created', backgroundColor: Colors.red);
        }
        // } else {
        //   Get.snackbar('Skipped', 'Data too short');
        // }
      }

      Get.snackbar(
        "Success!",
        result.toString(),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  ///Todo: upload currency stock
  // Future<void> uploadCurrencyStock() async {
  //   try {
  //     final uploadRepo = Get.put(UploadRepo());
  //     final setupRepo = Get.put(SetupRepo());
  //     final result = await uploadRepo.uploadFile();
  //     final lines = result?.readAsLinesSync(encoding: utf8);
  //     lines?.removeAt(0);
  //     final date = DateTime.now();
  //     print(lines);
  //
  //     var accountNo = int.tryParse(
  //             '${date.millisecond}${date.second}${date.minute}${date.hour}${date.day}${date.month}${date.year}') ??
  //         0;
  //
  //     for (var line in lines!) {
  //       final splitLine = line.split(',');
  //       // if (splitLine.length > 5) {
  //       accountNo -= 1;
  //
  //       final newAccount = AccountModel(
  //           usdBalance: double.tryParse(splitLine[4]) ?? 0.0,
  //           kesBalance: double.tryParse(splitLine[5]) ?? 0.0,
  //           dateCreated: DateTime.now(),
  //           firstName: splitLine[0],
  //           lastName: splitLine[1],
  //           accountNo: '$accountNo',
  //           phoneNo: splitLine[2],
  //           email: splitLine[3]);
  //
  //       /// Save the data to firestore
  //       try {
  //         await _accountRepo.savaAccountData(
  //           newAccount,
  //         );
  //
  //         // Get.snackbar('Success', 'Account created',backgroundColor: Colors.green);
  //       } catch (e) {
  //         Get.snackbar('Failed', 'No account created', backgroundColor: Colors.red);
  //       }
  //       // } else {
  //       //   Get.snackbar('Skipped', 'Data too short');
  //       // }
  //     }
  //
  //     print(
  //         '//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////');
  //
  //     Get.snackbar(
  //       "Success!",
  //       result.toString(),
  //       backgroundColor: Colors.green,
  //       colorText: Colors.white,
  //     );
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }
}
