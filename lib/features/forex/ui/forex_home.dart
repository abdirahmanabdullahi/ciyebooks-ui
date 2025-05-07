import 'package:ciyebooks/features/forex/controller/forex_controller.dart';
import 'package:ciyebooks/features/forex/ui/widgets/forex_form.dart';
import 'package:ciyebooks/features/forex/ui/widgets/new_currency_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../navigation_menu.dart';
import '../controller/new_currency_controller.dart';
import 'forex_transactions.dart';

class ForexHome extends StatelessWidget {
  const ForexHome({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForexController());

    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );

    return Scaffold(
      backgroundColor: AppColors.quarternary,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.prettyDark,
        shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.quinary, width: 2.5), borderRadius: BorderRadius.circular(100)),
        onPressed: () => showForexForm(context),
        child: Icon(
          Icons.add,
          color: AppColors.quinary,
          // size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(


        // leading: IconButton(
        //     onPressed: () =>Navigator.pop(context),
        //     icon: Icon(
        //       Icons.arrow_back_ios,
        //       color: AppColors.prettyDark,
        //     )),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(    onPressed: () => showAddNewCurrencyDialog(context),
                icon:Icon(
                  Icons.add,
                  color: AppColors.prettyDark,
                )
            ),
          ),


        ],
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.quarternary,
        title: Text(
          'Forex',
          style: TextStyle(fontWeight: FontWeight.w400, color: AppColors.prettyDark),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                color: AppColors.quinary,
                child: TabBar(
                  padding: EdgeInsets.zero,
                  indicatorColor: CupertinoColors.systemBlue,
                  labelPadding: EdgeInsets.zero,
                  labelStyle: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(
                      height: 35,
                      child: Text(
                        'Currency stock',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Tab(
                      height: 35,
                      child: Text(
                        'Forex transactions',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Obx(
                      () {
                        return SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: double.parse(controller.totals.value.currenciesAtCost.toString()) == 0
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: MediaQuery.sizeOf(context).height / 3, horizontal: MediaQuery.sizeOf(context).width / 4),
                                  child: Text("No foreign currencies available.\n  "
                                      "  Tap '+' to buy currencies."),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 7),
                                      color: AppColors.quinary,
                                      width: MediaQuery.sizeOf(context).width,
                                      child: DataTable(
                                          dataRowMaxHeight: 40,
                                          dataRowMinHeight: 40,
                                          showBottomBorder: true,
                                          headingTextStyle: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w600),
                                          columnSpacing: 30,
                                          headingRowHeight: 40,
                                          horizontalMargin: 0,
                                          columns: [
                                            DataColumn(label: Text(' Name')),
                                            DataColumn(label: Text('Amount')),
                                            DataColumn(label: Text('Rate')),
                                            DataColumn(label: Text('Total ')),
                                          ],
                                          rows: controller.currencyStock.map((currency) {
                                            return DataRow(cells: [
                                              DataCell(Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                  currency.currencyCode,
                                                  style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w400),
                                                ),
                                              )),
                                              DataCell(
                                                Text(
                                                  formatter.format(
                                                    currency.amount,
                                                  ),
                                                ),
                                              ),
                                              DataCell(Text(
                                                currency.amount <= 0 ? '0.0' : formatter.format(currency.totalCost / currency.amount),
                                              )),
                                              DataCell(Text(
                                                formatter.format(currency.totalCost),
                                              )),
                                            ]);
                                          }).toList()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16.0, 24, 12, 24),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text("Cost of currencies", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: CupertinoColors.systemBlue)),
                                          Padding(
                                              padding: const EdgeInsets.only(left: 80.0),
                                              child: Text(formatter.format(double.parse(controller.totals.value.currenciesAtCost.toString())),
                                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: CupertinoColors.systemBlue))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        );
                      },
                    ),
                    ForexTransactions()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ForexStock extends StatelessWidget {
  const ForexStock({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForexController());

    return Scaffold(
      body: SafeArea(
        child: Obx(
          () {
            return SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Container(
                color: AppColors.quinary,
                child: DataTable(
                    dataRowMaxHeight: 40,
                    dataRowMinHeight: 40,
                    showBottomBorder: true,
                    headingTextStyle: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w600),
                    columnSpacing: 30,
                    headingRowHeight: 40,
                    horizontalMargin: 0,
                    columns: [
                      DataColumn(label: Text(' Name')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Rate')),
                      DataColumn(label: Text('Total ')),
                    ],
                    rows: controller.currencyStock.map((currency) {
                      return DataRow(cells: [
                        DataCell(Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            currency.currencyCode,
                            style: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.w600),
                          ),
                        )),
                        DataCell(
                          Text(
                            formatter.format(
                              currency.amount,
                            ),
                          ),
                        ),
                        DataCell(Text(
                          currency.amount <= 0 ? '0.0' : formatter.format(currency.totalCost / currency.amount),
                        )),
                        DataCell(Text(
                          formatter.format(currency.totalCost),
                        )),
                      ]);
                    }).toList()),
              ),
            );
          },
        ),
      ),
    );
  }
}
