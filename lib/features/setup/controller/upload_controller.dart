import 'dart:core';

import 'package:ciyebooks/common/widgets/error_dialog.dart';
import 'package:ciyebooks/features/setup/models/setup_model.dart';
import 'package:ciyebooks/features/setup/repo/upload_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../accounts/model/model.dart';
import '../../forex/model/new_currency_model.dart';


class UploadController extends GetxController {
  static UploadController get instance => Get.find();

  Rx<BalancesModel> totals = BalancesModel.empty().obs;
  final counters = {}.obs;
  final _db = FirebaseFirestore.instance;
  final uploadRepo = Get.put(UploadRepo());
  final currencyList = {}.obs;
  final overDrawn = false.obs;

  /// Headers checklists
  final totalsFieldChecklist = [
    'shillingAtBank',
    'shillingCashInHand',
    'shillingReceivable',
    'shillingPayable',
    'dollarAtBank',
    'dollarCashInHand',
    'dollarReceivable',
    'dollarPayable',
    'currenciesAtCost'
  ];
  // final depositsCheckList = ['Date', 'Deposited_By', 'Currency', 'Amount', 'Narrative'];
  // final transfersCheckList = ['Date', 'Currency', 'Receiver', 'Amount', 'Narrative'];
  // final withdrawalsCheckList = ['Date', 'Currency', 'Amount', 'Withdrawn_By', 'Narrative'];
  final totalsHeadersCheckList = ['Name', 'Amount'];
  // final receiptsCheckList = ['Date', 'Received_From', 'Receiving_Account', 'Currency', 'Amount', 'Description'];
  // final paymentsCheckList = ['Date', 'Account_From', 'Receiver', 'Currency', 'Amount', 'Description'];
  final accountsCheckList = ['First_Name', 'Last_Name', 'Phone_No', 'Email', 'USD', 'KES'];
  final currenciesCheckList = ['CODE','AMOUNT', 'TOTAL'];



  ///Todo: upload totals
  Future<void> uploadTotals(BuildContext context) async {
    final List? lines = await uploadRepo.uploadData(context: context, checkList: totalsHeadersCheckList, fileName: 'Totals template');

    ///Todo: Check if all required fields are there.
    if (lines != null && lines.isNotEmpty) {
      /// Remove the headers
      lines.removeAt(0);

      ///Parse the data to a map.
      Map<String, dynamic> parsedTotals = {};
      final List fieldNames = [];
      for (var line in lines) {
        final key = line.split(',')[0].replaceAll('"', '');
        fieldNames.add(key);

        final value = double.tryParse(line.split(',')[1].replaceAll('"', '').trim()) ?? 0.0;

        parsedTotals[key] = value;
      }

      if (!listEquals(fieldNames, totalsFieldChecklist)) {
        if (context.mounted) {
          showErrorDialog(context: context,errorTitle:  "Oops! Unsupported data format!.",errorText:  ' Please use the provided "Totals template" excel sheet to upload your data');
        }
        return;
      }

      /// Save the data to firestore
      ///Todo: Upload the data to firestore
    }
  }

  Future<void> uploadAccounts(BuildContext context) async {
    //     // ///Upload the file
    final List? lines = await uploadRepo.uploadData(context: context, checkList: accountsCheckList, fileName: 'Accounts template');

    ///Todo: Check if all required fields are there.
    if (lines != null && lines.isNotEmpty) {
      /// Remove the headers
      lines.removeAt(0);

      ///Process the content

      int accountsCounter = 1000;

      ///PROCESSING
      final batch = _db.batch();
      ///Reference to the counter
      final counterRef = _db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('setup').doc('balances');
      for (var line in lines) {
        final splitLine = line.split(',');
        if (splitLine.length < 5) {
          return;
        }
        if(splitLine[4] -0 || splitLine[5]){
          overDrawn.value=true;
        }
        final newAccount = AccountModel(
            currencies: {
              'USD': double.tryParse(splitLine[4]) ?? 0.0,
              'KES': double.tryParse(splitLine[5]) ?? 0.0,
            },
            dateCreated: DateTime.now(),
            firstName: splitLine[0],
            lastName: splitLine[1],
            accountNo: '$accountsCounter',
            phoneNo: splitLine[2],
            email: splitLine[3],
            accountName: '${splitLine[0]} ${splitLine[1]}', overDrawn: overDrawn.value);

        ///Point where to create each new account
        final newAccountRef = _db.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection("accounts").doc('$accountsCounter');

        ///CREATE THE ACCOUNT
        batch.set(newAccountRef, newAccount.toJson());

        ///UPDATE THE COUNTER
        accountsCounter++;
      }

      ///After accounts are created, update the firestore counter
      batch.update(counterRef, {"transactionCounters.accountsCounter": accountsCounter});

      await batch.commit().then((_) {
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Success!",
          '${accountsCounter - 1000} accounts uploaded',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      });
    }
  }

//   ///Todo: upload payments
//   Future<void> uploadPayments(BuildContext context) async {
//     //     // ///Upload the file
//     final List? lines = await uploadRepo.uploadData(context: context, checkList: paymentsCheckList, fileName: 'Payments template');
//
//     ///Todo: Check if all required fields are there.
//     if (lines != null && lines.isNotEmpty) {
//       /// Remove the headers
//       lines.removeAt(0);
//
//       ///Process the content
//
//       int paymentsCounter = 1000;
//
//       ///PROCESSING
//       final batch = _db.batch();
//
//       ///Reference to the counter
//       final counterRef = _db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('setup').doc('balances');
//       for (var line in lines) {
//         final splitLine = line.split(',');
//         if (splitLine.length < 5) {
//           return;
//         }
//         final newPayment = PayClientModel(
//           transactionId: 'PAY-$paymentsCounter',
//           accountFrom: splitLine[1],
//           paymentType: '',
//           accountNo: '',
//           currency: splitLine[3],
//           amountPaid: double.tryParse(splitLine[4]) ?? 0.0,
//           receiver: splitLine[2],
//           dateCreated: DateFormat("dd/MM/yyyy").parse(splitLine[0]),
//           description: splitLine[5],
//           transactionType: 'payment',
//         );
//
//         ///Point where to create each new account
//         final newPaymentRef = _db.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection("transactions").doc('PAY-$paymentsCounter');
//
//         ///CREATE THE TRANSACTION
//         batch.set(newPaymentRef, newPayment.toJson());
//
//         ///UPDATE THE COUNTER
//         paymentsCounter++;
//       }
//
//       ///After accounts are created, update the firestore counter
//       batch.update(counterRef, {"transactionCounters.paymentsCounter": paymentsCounter});
//
//       await batch.commit().then((_) {
//         Get.snackbar(
//           icon: Icon(
//             Icons.cloud_done,
//             color: Colors.white,
//           ),
//           shouldIconPulse: true,
//           "Success!",
//           '${paymentsCounter - 1000} payments uploaded',
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       });
//     }
//   }
//
//   ///Todo: upload expenses
//   Future<void> uploadExpenses(BuildContext context) async {
//     //     // ///Upload the file
//     final List? lines = await uploadRepo.uploadData(context: context, checkList: expensesCheckList, fileName: 'Expenses template');
//
//     ///Todo: Check if all required fields are there.
//     if (lines != null && lines.isNotEmpty) {
//       /// Remove the headers
//       lines.removeAt(0);
//
//       ///Process the content
//
//       int expenseCounter = 1000;
//
//       ///PROCESSING
//       final batch = _db.batch();
//
//       ///Reference to the counter
//       final counterRef = _db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('setup').doc('balances');
//       for (var line in lines) {
//         final splitLine = line.split(',');
//         if (splitLine.length < 5) {
//           return;
//         }
//         final newExpense = ExpenseModel(
//             transactionType: 'expense',
//             transactionId: 'EXP-$expenseCounter',
//             category: splitLine[1],
//             description: splitLine[4],
//             dateCreated: DateFormat("dd/MM/yyyy").parse(splitLine[0]),
//             currency: splitLine[2],
//             amountPaid: double.tryParse(splitLine[3]) ?? 0.0, paymentType: 'Cash');
//
//         ///Point where to create each new account
//         final newExpenseRef = _db.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection("transactions").doc('EXP-$expenseCounter');
//
//         ///CREATE THE ACCOUNT
//         batch.set(newExpenseRef, newExpense.toJson());
//
//         ///UPDATE THE COUNTER
//         expenseCounter++;
//       }
//
//       ///After accounts are created, update the firestore counter
//       batch.update(counterRef, {"transactionCounters.expenseCounter": expenseCounter});
//
//       await batch.commit().then((_) {
//         Get.snackbar(
//           icon: Icon(
//             Icons.cloud_done,
//             color: Colors.white,
//           ),
//           shouldIconPulse: true,
//           "Success!",
//           '${expenseCounter - 1000} expenses uploaded',
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       });
//     }
//   }
//
//   // ///Todo: upload receipts
//   Future<void> uploadReceipts(BuildContext context) async {
//     //     // ///Upload the file
//     final List? lines = await uploadRepo.uploadData(context: context, checkList: receiptsCheckList, fileName: 'Receipts template');
//
//     ///Todo: Check if all required fields are there.
//     if (lines != null && lines.isNotEmpty) {
//       /// Remove the headers
//       lines.removeAt(0);
//
//       ///Process the content
//
//       int receiptsCounter = 1000;
//
//       ///PROCESSING
//       final batch = _db.batch();
//
//       ///Reference to the counter
//       final counterRef = _db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('setup').doc('balances');
//       for (var line in lines) {
//         final splitLine = line.split(',');
//         if (splitLine.length < 5) {
//           return;
//         }
//         final newReceipt = ReceiveModel(
//             transactionType: 'receipt',
//             depositType: 'cash',
//             transactionId: 'RCPT-$receiptsCounter',
//             depositorName: splitLine[1],
//             receivingAccountName: splitLine[2],
//             currency: splitLine[3],
//             amount: double.tryParse(splitLine[4]) ?? 0.0,
//             dateCreated: DateFormat("dd/MM/yyyy").parse(splitLine[0]),
//             description: splitLine[5],
//             ///Todo: Add account no here
//             receivingAccountNo: '');
//
//         ///Point where to create each new account
//         final newReceiptRef = _db.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection("transactions").doc('RCPT-$receiptsCounter');
//
//         ///CREATE THE ACCOUNT
//         batch.set(newReceiptRef, newReceipt.toJson());
//
//         ///UPDATE THE COUNTER
//         receiptsCounter++;
//       }
//
//       ///After accounts are created, update the firestore counter
//       batch.update(counterRef, {"transactionCounters.receiptsCounter": receiptsCounter});
//
//       await batch.commit().then((_) {
//         Get.snackbar(
//           icon: Icon(
//             Icons.cloud_done,
//             color: Colors.white,
//           ),
//           shouldIconPulse: true,
//           "Success!",
//           '${receiptsCounter - 1000} receipts uploaded',
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       });
//     }
//   }
//
//   // ///Todo: upload withdrawals
//   Future<void> uploadWithdrawals(BuildContext context) async {
//     //     // ///Upload the file
//     final List? lines = await uploadRepo.uploadData(context: context, checkList: withdrawalsCheckList, fileName: 'Withdrawals template');
//
//     ///Todo: Check if all required fields are there.
//     if (lines != null && lines.isNotEmpty) {
//       /// Remove the headers
//       lines.removeAt(0);
//
//       ///Process the content
//
//       int bankWithdrawCounter = 1000;
//
//       ///PROCESSING
//       final batch = _db.batch();
//
//       ///Reference to the counter
//       final counterRef = _db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('setup').doc('balances');
//       for (var line in lines) {
//         final splitLine = line.split(',');
//         if (splitLine.length < 5) {
//           return;
//         }
//         final newWithdrawal = WithdrawModel(
//             transactionType: 'withdraw',
//             transactionId: 'WDR$bankWithdrawCounter',
//             currency: splitLine[1],
//             amount: double.tryParse(splitLine[2]) ?? 0.0,
//             dateCreated: DateFormat("dd/MM/yyyy").parse(splitLine[0]),
//             withdrawalType: 'cash',
//             withdrawnBy: splitLine[3],
//             description: splitLine[4]);
//
//         ///Point where to create each new account
//         final newReceiptRef = _db.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection("transactions").doc('WDR-$bankWithdrawCounter');
//
//         ///CREATE THE ACCOUNT
//         batch.set(newReceiptRef, newWithdrawal.toJson());
//
//         ///UPDATE THE COUNTER
//         bankWithdrawCounter++;
//       }
//
//       ///After accounts are created, update the firestore counter
//       batch.update(counterRef, {"transactionCounters.bankWithdrawCounter": bankWithdrawCounter});
//
//       await batch.commit().then((_) {
//         Get.snackbar(
//           icon: Icon(
//             Icons.cloud_done,
//             color: Colors.white,
//           ),
//           shouldIconPulse: true,
//           "Success!",
//           '${bankWithdrawCounter - 1000} withdrawals uploaded',
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       });
//     }
//   }
//
//   Future<void> uploadDeposits(BuildContext context) async {
//     //     // ///Upload the file
//     final List? lines = await uploadRepo.uploadData(context: context, checkList: depositsCheckList, fileName: 'Deposits template');
//
//     ///Todo: Check if all required fields are there.
//     if (lines != null && lines.isNotEmpty) {
//       /// Remove the headers
//       lines.removeAt(0);
//
//       ///Process the content
//
//       int bankDepositCounter = 1000;
//
//       ///PROCESSING
//       final batch = _db.batch();
//
//       ///Reference to the counter
//       final counterRef = _db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('setup').doc('balances');
//       for (var line in lines) {
//         final splitLine = line.split(',');
//         if (splitLine.length < 5) {
//           return;
//         }
//         final newDeposit = DepositModel(
//           transactionType: 'deposit',
//           transactionId: 'DPST-$bankDepositCounter',
//           depositedBy: splitLine[1],
//           currency: splitLine[2],
//           amount: double.tryParse(splitLine[3]) ?? 0.0,
//           dateCreated: DateFormat("dd/MM/yyyy").parse(splitLine[0]), description: '',
//         );
//
//         ///Point where to create each new account
//         final newDepositRef = _db.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection("transactions").doc('DPST-$bankDepositCounter');
//
//         ///CREATE THE ACCOUNT
//         batch.set(newDepositRef, newDeposit.toJson());
//
//         ///UPDATE THE COUNTER
//         bankDepositCounter++;
//       }
//
//       ///After accounts are created, update the firestore counter
//       batch.update(counterRef, {"transactionCounters.bankDepositCounter": bankDepositCounter});
//
//       await batch.commit().then((_) {
//         Get.snackbar(
//           icon: Icon(
//             Icons.cloud_done,
//             color: Colors.white,
//           ),
//           shouldIconPulse: true,
//           "Success!",
//           '${bankDepositCounter - 1000} withdrawals uploaded',
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//       });
//     }
//   }
//
//
  ///Todo: upload currency stock

  Future<void> uploadCurrencyStock(BuildContext context) async {
    //     // ///Upload the file
    final List? lines = await uploadRepo.uploadData(context: context, checkList: currenciesCheckList, fileName: 'Currency stock');

    ///Todo: Check if all required fields are there.
    if (lines != null && lines.isNotEmpty) {
      /// Remove the headers
      lines.removeAt(0);

      ///Process the content
      int buyFxCounter = 1000;

      ///PROCESSING
      final batch = _db.batch();

      ///Reference to the counter
      // final counterRef = _db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('currencyStock');
      for (var line in lines) {

        final splitLine = line.split(',');
        // if (splitLine.length != 2) {
        //   return;
        // }
        final newCurrency = CurrencyModel(currencyName: '', amount: double.parse(splitLine[1]), totalCost: double.parse(splitLine[2]), symbol: '', currencyCode: splitLine[0].toUpperCase());
        // final buyCurrency = ForexModel(
        //     currencyCode: splitLine[2].toUpperCase(),
        //     forexType: '',
        //     type: '',
        //     rate: double.parse(splitLine[3]),
        //     amount: double.parse(splitLine[4]),
        //     totalCost: double.parse(splitLine[5]),
        //     dateCreated: DateFormat("dd/MM/yyyy").parse(splitLine[0]),
        //     transactionType: 'forex',
        //     transactionId: 'FXBY-$buyFxCounter', revenueContributed: 0);
        // final newCurrencyAccount = CurrencyModel( currencyName: splitLine[1], currencyCode: splitLine[2].toUpperCase(), symbol: '', amount: 0, totalCost: 0);

        ///Update the total cost of currencies field
        final totalsRef = _db.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection("setup").doc('balances');

        ///Point where to create each new currency account
        final newCurrencyRef = _db.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection("currencyStock").doc(splitLine[0]);

        ///CREATE THE FX TRANSACTION
        // batch.set(buyFxTransactionRef, buyCurrency.toJson());

        ///Create the new currency
        batch.set(newCurrencyRef, newCurrency.toJson());

        ///UPDATE THE COUNTER
        batch.update(totalsRef, {"currenciesAtCost": FieldValue.increment(double.parse(splitLine[2]))});
      }

      ///After accounts are created, update the firestore counter

      await batch.commit().then((_) {
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Success!",
          '${buyFxCounter - 1000} currencies uploaded',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      });
    }
  }
}
