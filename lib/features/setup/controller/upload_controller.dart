import 'dart:convert';

import 'package:ciyebooks/features/accounts/model/model.dart';
import 'package:ciyebooks/features/accounts/repo/repo.dart';
import 'package:ciyebooks/features/setup/models/setup_model.dart';
import 'package:ciyebooks/features/setup/repo/upload_repo.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repo/setup_repo.dart';

class UploadController extends GetxController {
  static UploadController get instance => Get.find();
  final _accountRepo = Get.put(AccountsRepo());
  final _setupRepo = Get.put(SetupRepo());

  ///Todo: upload totals
  Future<void> uploadTotals() async {
    try {
      final uploadRepo = Get.put(UploadRepo());
      final setupRepo = Get.put(SetupRepo());
      final result = await uploadRepo.uploadFile();
      final lines = result?.readAsLinesSync(encoding: utf8);
      // lines?.removeAt(0);
      final date = DateTime.now();
      print(lines);

      // var accountNo = int.tryParse(
      //     '${date.millisecond}${date.second}${date.minute}${date.hour}${date.day}${date.month}${date.year}') ??
      //     0;
      Map<String, double> parsedTotals = {};

      for (var line in lines!) {
        print(line);
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
          parsedTotals['shillingPayable']! ;


      final totals = BalancesModel(
        shillingAtBank: parsedTotals['shillingAtBank'] ?? 0.0,
        shillingCashInHand: parsedTotals['shillingCashInHand'] ?? 0.0,
        shillingReceivable: parsedTotals['shillingReceivable'] ?? 0.0,
        shillingPayable: parsedTotals['shillingPayable'] ?? 0.0,
        dollarAtBank: parsedTotals['dollarAtBank'] ?? 0.0,
        dollarCashInHand: parsedTotals['dollarCashInHand'] ?? 0.0,
        dollarReceivable: parsedTotals['dollarReceivable'] ?? 0.0,
        dollarPayable: parsedTotals['dollarPayable'] ?? 0.0,
        averageRateOfDollar: parsedTotals['averageRateOfDollar'] ?? 0.0,
        workingCapital: convertedDollarTotal+shillingTotal,
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
    try {
      final uploadRepo = Get.put(UploadRepo());
      final setupRepo = Get.put(SetupRepo());
      final result = await uploadRepo.uploadFile();
      final lines = result?.readAsLinesSync(encoding: utf8);
      lines?.removeAt(0);
      final date = DateTime.now();
      print(lines);

      var accountNo = int.tryParse(
              '${date.millisecond}${date.second}${date.minute}${date.hour}${date.day}${date.month}${date.year}') ??
          0;

      for (var line in lines!) {
        final splitLine = line.split(',');
        // if (splitLine.length > 5) {
        accountNo -= 1;

        final newAccount = AccountModel(
            currencies: {
              'USD': double.tryParse(splitLine[4]) ?? 0.0,
              'KES': double.tryParse(splitLine[5]) ?? 0.0
            },
            dateCreated: DateTime.now(),
            firstName: splitLine[0],
            lastName: splitLine[1],
            accountNo: '$accountNo',
            phoneNo: splitLine[2],
            email: splitLine[3]);

        /// Save the data to firestore
        try {
          await _accountRepo.savaAccountData(
            newAccount,
          );

          // Get.snackbar('Success', 'Account created',backgroundColor: Colors.green);
        } catch (e) {
          Get.snackbar('Failed', 'No account created',
              backgroundColor: Colors.red);
        }
        // } else {
        //   Get.snackbar('Skipped', 'Data too short');
        // }
      }

      print(
          '//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////');

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

  ///Todo: upload transaction
  // Future<void> uploadTransactions() async {
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
  //           currencies: {
  //             'USD': double.tryParse(splitLine[4]) ?? 0.0,
  //             'KES': double.tryParse(splitLine[5]) ?? 0.0
  //           },
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
  //         Get.snackbar('Failed', 'No account created',
  //             backgroundColor: Colors.red);
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

  ///Todo: upload expenses
  // Future<void> uploadExpenses() async {
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
  //           currencies: {
  //             'USD': double.tryParse(splitLine[4]) ?? 0.0,
  //             'KES': double.tryParse(splitLine[5]) ?? 0.0
  //           },
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
  //         Get.snackbar('Failed', 'No account created',
  //             backgroundColor: Colors.red);
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
  //           currencies: {
  //             'USD': double.tryParse(splitLine[4]) ?? 0.0,
  //             'KES': double.tryParse(splitLine[5]) ?? 0.0
  //           },
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
  //         Get.snackbar('Failed', 'No account created',
  //             backgroundColor: Colors.red);
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

  ///Todo: upload notes
  // Future<void> uploadNotes() async {
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
  //           currencies: {
  //             'USD': double.tryParse(splitLine[4]) ?? 0.0,
  //             'KES': double.tryParse(splitLine[5]) ?? 0.0
  //           },
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
  //         Get.snackbar('Failed', 'No account created',
  //             backgroundColor: Colors.red);
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

  ///Todo: upload reminders
  // Future<void> uploadReminders() async {
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
  //           currencies: {
  //             'USD': double.tryParse(splitLine[4]) ?? 0.0,
  //             'KES': double.tryParse(splitLine[5]) ?? 0.0
  //           },
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
  //         Get.snackbar('Failed', 'No account created',
  //             backgroundColor: Colors.red);
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
