import 'dart:io';

import 'package:ciyebooks/features/stats/controllers/stats_controller.dart';
import 'package:ciyebooks/features/stats/models/stats_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/constants/colors.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    final controller = Get.put(StatsController());

    void showDialog() {
      Platform.isIOS ?


      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system
          // navigation bar.
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          // Provide a background color for the popup.
          color: AppColors.quinary,
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            child: CupertinoDatePicker(
              backgroundColor: AppColors.quinary,
              initialDateTime: DateTime.now(),
              mode: CupertinoDatePickerMode.date,
              use24hFormat: true,
              // This shows day of week alongside day of month
              showDayOfWeek: true,
              onDateTimeChanged: (DateTime value) {
                controller.selectedDate.value = DateFormat("d MMM yyyy").format(value);
              },
              // This is called when the user changes the date.
            ),
          ),
        ),
      ):showDatePicker(initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
              primary: AppColors.prettyBlue, // header background color
            onPrimary: AppColors.quinary, // header text color
            onSurface: AppColors.prettyDark, // body text color
          ),
          textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
          foregroundColor: CupertinoColors.systemBlue, ),)
              // dialogBackgroundColor: Colors.white,  // Entire dialog background
            ),
            child: child!,
          );
        },
      ).then((date) {
        if (date != null) {
          controller.selectedDate.value = DateFormat("d MMM yyyy").format(date);
        }
      });
    }

    return Scaffold(backgroundColor: AppColors.quinary,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.quinary,
              )),
          actions: [
            IconButton(
                onPressed: () => showDialog(),
                icon: Icon(
                  Icons.calendar_month,
                  color: AppColors.quinary,
                ))
          ],
          // automaticallyImplyLeading: false,
          backgroundColor: AppColors.prettyBlue,
          title: Text(
            'Daily report',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.quinary),
          ),
        ),
        body: Obx(
          () => StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('dailyReports').doc(controller.selectedDate.value).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Text("Loading"));
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('No report available for the selected date'));
              }

              final report = DailyReportModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(3, 20, 3, 0),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Report date',
                            style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.bold,fontSize: 18),
                          ),
                          Text(
                            controller.selectedDate.value,
                            style: TextStyle(
                              color: CupertinoColors.systemBlue,
                              fontWeight: FontWeight.bold,fontSize: 18
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Gap(6),
                      const Text(
                        'Payments',
                        style: TextStyle(
                          color: AppColors.prettyDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(10),
                      ...report.payments.entries.map((e) => Padding(
                            padding: const EdgeInsets.fromLTRB(2.0, 3, 2, 0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      e.key,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                    Text(
                                      formatter.format(
                                        e.value,
                                      ),
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CupertinoColors.systemRed),
                                    ),
                                  ],
                                ),
                                Divider()
                              ],
                            ),
                          )),
                      // Divider(),
                      Gap(10),
                      const Text(
                        'Receipts',
                        style: TextStyle(
                          color: AppColors.prettyDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(10),
                      ...report.received.entries.map((e) => Padding(
                            padding: const EdgeInsets.fromLTRB(2.0, 3, 2, 0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      e.key,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                    Text(
                                      formatter.format(
                                        e.value,
                                      ),
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CupertinoColors.activeGreen),
                                    ),
                                  ],
                                ),
                                Divider()
                              ],
                            ),
                          )),
                      Gap(10),
                      const Text(
                        'Deposits',
                        style: TextStyle(
                          color: AppColors.prettyDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(10),
                      ...report.deposits.entries.map((e) => Padding(
                            padding: const EdgeInsets.fromLTRB(2.0, 3, 2, 0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      e.key,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                    Text(
                                      formatter.format(
                                        e.value,
                                      ),
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CupertinoColors.systemBlue),
                                    ),
                                  ],
                                ),Divider()
                              ],
                            ),
                          )),
                      Gap(10),
                      const Text(
                        'Withdrawals',
                        style: TextStyle(
                          color: AppColors.prettyDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(10),
                      ...report.withdrawals.entries.map((e) => Padding(
                            padding: const EdgeInsets.fromLTRB(2.0, 3, 2, 0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      e.key,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                    Text(
                                      formatter.format(
                                        e.value,
                                      ),
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CupertinoColors.systemBlue),
                                    ),
                                  ],
                                ),Divider()
                              ],
                            ),
                          )),
                      Gap(10),
                      const Text(
                        'Expenses',
                        style: TextStyle(
                          color: AppColors.prettyDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(10),
                      ...report.expenses.entries.map((e) => Padding(
                            padding: const EdgeInsets.fromLTRB(2.0, 3, 2, 0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      e.key,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                    Text(
                                      formatter.format(
                                        e.value,
                                      ),
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CupertinoColors.systemRed),
                                    ),
                                  ],
                                ),Divider()
                              ],
                            ),
                          )),
                      Gap(20),
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Income',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.prettyDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatter.format(
                                report.dailyProfit,
                              ),
                              style: TextStyle(color: CupertinoColors.systemGreen, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                      ),                      Gap(10),
                      Divider(),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
