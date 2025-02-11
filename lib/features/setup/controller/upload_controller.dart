import 'dart:convert';
import 'dart:io';

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
import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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

  ///Method to update the counters
  // Future<void> updateCounter(String counterToUpdate) async {
  //   await FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(FirebaseAuth.instance.currentUser?.uid)
  //       .collection('Setup')
  //       .doc('Balances')
  //       .update({"transactionCounters.$counterToUpdate": FieldValue.increment(1)});
  // }

  ///Todo: upload totals
  Future<void> uploadTotals(BuildContext context) async {
    final totalsList = [
      'shillingAtBank',
      'shillingCashInHand',
      'shillingReceivable',
      'shillingPayable',
      'dollarAtBank',
      'dollarCashInHand',
      'dollarReceivable',
      'dollarPayable',
      'currenciesAtCost',
      'expenses'
    ];

    try {
      ///Upload the file
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['CSV']);
      if (result != null) {
        File file = File(result.files.single.path!);

        ///Process the content
        final lines = file.readAsLinesSync(encoding: utf8);
        print(lines);

        // final dataList2 = lines.map((line)=>line.split(',')).toList();
        //
        // final dataList = lines.map((line)=>line.split(',')).toList().expand((pair) => pair).toList();
        // print('---------------------------------------------------------------------datalist-----------------------------------------------------------');
        // print(dataList[0]);
        // print(dataList[1]);

        List content = [];
        for (var line in lines) {
          print(line.split(','));
          print(
              '---------------------------------------------------------------------splitting-----------------------------------------------------------');
          content.add(line.split(',')[0].replaceAll('"', '').trim());
        }

        if (!content.every((item) => totalsList.contains(item))) {
          print(content);
          print(totalsList);
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                title: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.block,
                          color: Colors.red,
                          size: 30,
                        ),
                        Gap(10),
                        Text(
                          "Wrong format!",
                          style: TextStyle(color: Colors.red.shade800),
                        ),
                      ],
                    ),
                    Divider()
                  ],
                ),
                content: Text(
                  "Please use the totals excel sheet template provided to upload your data.",
                  style: TextStyle(fontSize: 18),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "OK",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.prettyDark, fontSize: 15),
                    ),
                  ),
                ],
              ),
            );
          }
          return;
        }

        // if (dataList.contains('KesBankBalance')) {
        //   print('yessssssssssssss');
        // } else {
        //   print('????????????????????????');
        // }

        Map<String, double> parsedTotals = {};

        for (var line in lines) {
          final splitLine = line.split(',');
          print(
              '<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
          print(line);
          print(splitLine);

          final key = splitLine[0];
          final value = double.tryParse(splitLine[1]) ?? 0.0;
          parsedTotals[key] = value;
        }
        print(parsedTotals);

        // final convertedDollarTotal = (parsedTotals['dollarAtBank']! +
        //         parsedTotals['dollarCashInHand']! +
        //         parsedTotals['dollarReceivable']! -
        //         parsedTotals['dollarPayable']!) *
        //     parsedTotals['averageRateOfDollar']!;
        //
        // final shillingTotal = parsedTotals['shillingAtBank']! +
        //     parsedTotals['shillingCashInHand']! +
        //     parsedTotals['shillingReceivable']! -
        //     parsedTotals['shillingPayable']!;

        final totals = BalancesModel(
          shillingAtBank: parsedTotals['shillingAtBank'] ?? 0.0,
          shillingCashInHand: parsedTotals['shillingCashInHand'] ?? 0.0,
          shillingReceivable: parsedTotals['shillingReceivable'] ?? 0.0,
          shillingPayable: parsedTotals['shillingPayable'] ?? 0.0,
          dollarAtBank: parsedTotals['dollarAtBank'] ?? 0.0,
          dollarCashInHand: parsedTotals['dollarCashInHand'] ?? 0.0,
          dollarReceivable: parsedTotals['dollarReceivable'] ?? 0.0,
          dollarPayable: parsedTotals['dollarPayable'] ?? 0.0,
          currenciesAtCost: parsedTotals['currenciesAtCost'] ?? 0.0,
          workingCapital: 0.0,
          expenses: {'USD': 0.0, 'KES': 0.0},
          receipts: {'USD': 0.0, 'KES': 0.0},
          transfers: {'USD': 0.0, 'KES': 0.0},
          withdrawals: {'USD': 0.0, 'KES': 0.0},
          payments: {'USD': 0.0, 'KES': 0.0},
          deposits: {'USD': 0.0, 'KES': 0.0},
          inflows: {'USD': 0.0, 'KES': 0.0},
          outflows: {'USD': 0.0, 'KES': 0.0},
          transactionCounters: {
            'paymentsCounter': 0,
            'receiptsCounter': 0,
            'transfersCounter': 0,
            'expenseCounter': 0,
            'buyFxCounter': 0,
            'sellFxCounter': 0,
            'accountsCounter': 0,
            'bankDepositCounter': 0,
            'bankWithdrawCounter': 0,
            'bankTransferCounter': 0,
            'internalTransferCounter': 0,
          },
        );

        /// Save the data to firestore

        await _setupRepo.saveSetupData(
          totals
        );

        Get.snackbar(
          "Success!",
          'Balances update complete',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Selection cancelled!', 'No file was selected',
            backgroundColor: Colors.orange);
      }
    } catch (e) {
      Get.snackbar('Selection cancelled!', 'No file was selected', backgroundColor: Colors.orange);
      throw e.toString();
    }
  }

  ///Todo: upload accounts
  Future<void> uploadAccounts() async {
    try {
      // ///Upload the file
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
      if (result != null) {
        File file = File(result.files.single.path!);
        //
        //   ///Process the content
        final lines = file.readAsLinesSync(encoding: utf8);
        // if (!lines[0].toLowerCase().contains('accounts')) {
        //   Get.snackbar(
        //     icon: Icon(
        //       Icons.cloud_done,
        //       color: Colors.white,
        //     ),
        //     shouldIconPulse: true,
        //     "Failed!",
        //     'Please upload a file with accounts',
        //     backgroundColor: Colors.redAccent,
        //     colorText: Colors.white,
        //   );
        //   return;
        // }

        lines.removeAt(0);
        int accountsCounter = 1000;

        ///PROCESSING
        final batch = _db.batch();

        ///Reference to the counter
        final counterRef = _db
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('Setup')
            .doc('Balances');

        for (var line in lines) {
          print(line);
          print(
              '---------------------------------------------------------------------splitting accounts-----------------------------------------------------------');

          final splitLine = line.split(',');
          if (splitLine.length < 5) {
            return;
          }
          final newAccount = AccountModel(
              usdBalance: double.tryParse(splitLine[4]) ?? 0.0,
              kesBalance: double.tryParse(splitLine[5]) ?? 0.0,
              dateCreated: DateTime.now(),
              firstName: splitLine[0],
              lastName: splitLine[1],
              accountNo: 'PA-$accountsCounter',
              phoneNo: splitLine[2],
              email: splitLine[3],
              accountName: '${splitLine[0]} ${splitLine[1]}');

          ///Point where to create each new account
          final newAccountRef = _db
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection("Accounts")
              .doc('PA-$accountsCounter');

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
      } else {
        Get.snackbar(
          icon: Icon(
            Icons.file_upload_off,
            color: Colors.red,
          ),
          shouldIconPulse: true,
          "Process cancelled!",
          'No file was uploaded',
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      throw e.toString();
    }
  }

  ///Todo: upload payments
  Future<void> uploadPayments() async {
    try {
      final uploadRepo = Get.put(UploadRepo());
      final result = await uploadRepo.uploadFile();
      final lines = result?.readAsLinesSync(encoding: utf8);
      lines?.removeAt(0);

      /// Create the counter
      int paymentCounter = 1;
      final db = FirebaseFirestore.instance;

      /// Get the uid of the current logged in user
      final uid = FirebaseAuth.instance.currentUser?.uid;

      final paymentCounterRef = db.collection('Users').doc(uid).collection('Setup').doc('Balances');

      ///Initialize the batch

      final batch = db.batch();

      for (var line in lines!) {
        final splitLine = line.split(',');

        final newPayment = PayClientModel(
          transactionId: 'pymnt-$paymentCounter',
          accountFrom: splitLine[1],
          currency: splitLine[3],
          amountPaid: double.tryParse(splitLine[4]) ?? 0.0,
          receiver: splitLine[2],
          dateCreated: DateFormat("dd/MM/yyyy").parse(splitLine[0]),
          description: splitLine[5],
          transactionType: 'payment',
        );

        final newPaymentRef =
            db.collection('Users').doc(uid).collection('transactions').doc('pymnt-$paymentCounter');

        /// Save the data to firestore
        batch.set(newPaymentRef, newPayment.toJson());
        paymentCounter++;
      }
      batch.update(paymentCounterRef, {'transactionCounters.paymentsCounter': paymentCounter});
      await batch.commit();

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
