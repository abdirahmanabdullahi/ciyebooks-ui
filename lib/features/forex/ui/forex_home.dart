import 'package:ciyebooks/common/custom_appbar.dart';
import 'package:ciyebooks/features/bank/deposit/controller/deposit_cash_controller.dart';
import 'package:ciyebooks/features/bank/deposit/model/deposit_model.dart';
import 'package:ciyebooks/features/dashboard/controller/dashboard_controller.dart';
import 'package:ciyebooks/features/forex/controller/forex_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../../../../common/styles/custom_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../navigation_menu.dart';
import '../../../utils/formatters/formatter.dart';
import '../../bank/withdraw/screens/deposits.dart';
import '../../bank/withdraw/screens/withdrawals.dart';
import '../../calculator/calculator_screen.dart';
import '../../dashboard/widgets/bottom_sheet_button.dart';
import '../controller/new_currency_controller.dart';
import 'forex_transactions.dart';

class ForexHome extends StatelessWidget {
  const ForexHome({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForexController());
    final dashboardController = Get.put(DashboardController());
    final newCurrencyController = Get.put(NewCurrencyController());
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );

    return Scaffold(
      backgroundColor: AppColors.quarternary,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.prettyDark,
        shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.prettyDark, width: 2), borderRadius: BorderRadius.circular(100)),
        onPressed: () => showForexForm(context),
        child: Icon(
          Icons.add,
          color: AppColors.quinary,
          // size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () => Get.offAll(NavigationMenu()),
              icon: Icon(
                Icons.close,
                color: AppColors.prettyDark,
              )),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.quarternary,
        title: Text(
          'Forex',
          style: TextStyle(color: AppColors.prettyDark),
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
                        // style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Tab(
                      height: 35,
                      child: Text(
                        'Forex Transactions',
                        // style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
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
                        return SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
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
                                rows: dashboardController.currencies.map((currency) {
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

showForexForm(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final controller = Get.put(ForexController());
      final NumberFormat formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_us',
        decimalDigits: 2,
      );
      Future<void> vibrate() async {
        await SystemChannels.platform.invokeMethod<void>(
          'HapticFeedback.vibrate',
          'HapticFeedbackType.lightImpact',
        );
      }

      return GestureDetector(
        onLongPress: () {
          vibrate();
          if (context.mounted) {
            showCalculator(context);
          }
        },
        child: PopScope(
          canPop: false,
          child: AlertDialog(
            titlePadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.all(8),
            backgroundColor: AppColors.quarternary,
            contentPadding: EdgeInsets.all(6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            title: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.systemBlue),
              width: double.maxFinite,
              // height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Gap(30),
                      Icon(
                        Icons.currency_exchange,
                        color: AppColors.quinary,
                        // size: 25,
                      ),
                      Gap(15),
                      Text(
                        'Forex',
                        style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: AppColors.quinary,
                      ))
                ],
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gap(6),
                  Obx(
                    () => SizedBox(
                      height: 45,
                      child: Row(
                        children: [
                          Expanded(
                            child: FloatingActionButton(
                              heroTag: 'Forex Buy',
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1, color: AppColors.grey), borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))),
                              elevation: 0,
                              backgroundColor: controller.selectedTransaction.value == 'buyFx' ? CupertinoColors.systemBlue : AppColors.quinary,
                              // selected: controller.selectedTransaction.value == 'Buy',
                              onPressed: () {
                                controller.selectedTransaction.value = 'buyFx';
                                // controller.transactionType.text = 'buyFx';
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  controller.selectedTransaction.value == 'buyFx'
                                      ? Icon(
                                          Icons.task_alt_outlined,
                                          color: AppColors.quinary,
                                        )
                                      : SizedBox(),
                                  Gap(10),
                                  Text(
                                    'Buy',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: controller.selectedTransaction.value == 'buyFx' ? Colors.white : CupertinoColors.systemBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: FloatingActionButton(
                              heroTag: 'Forex sell',
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1, color: AppColors.grey), borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
                              backgroundColor: controller.selectedTransaction.value == 'sellFx' ? CupertinoColors.systemBlue : AppColors.quinary,
                              // selected: controller.selectedTransaction.value == 'Buy',
                              onPressed: () {
                                controller.selectedTransaction.value = 'sellFx';
                                // controller.transactionType.text = 'SellFx';
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  controller.selectedTransaction.value == 'sellFx'
                                      ? Icon(
                                          Icons.task_alt_outlined,
                                          color: AppColors.quinary,
                                        )
                                      : SizedBox(),
                                  Gap(10),
                                  Text(
                                    'Sell',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: controller.selectedTransaction.value == 'sellFx' ? Colors.white : CupertinoColors.systemBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gap(6),
                  DropdownMenu(
                    enableFilter: true,
                    controller: controller.currency,
                    trailingIcon: Icon(
                      Icons.search,
                      color: CupertinoColors.systemBlue,
                      size: 25,
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                      fillColor: AppColors.quinary,
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      constraints: BoxConstraints.tight(const Size.fromHeight(45)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    enableSearch: true,
                    requestFocusOnTap: true,
                    menuStyle: MenuStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 0, vertical: 6)),
                      backgroundColor: WidgetStateProperty.all(AppColors.quinary), // Adjust height here,
                      maximumSize: WidgetStateProperty.all(Size(double.infinity, 200)), // Adjust height here
                    ),
                    label: Text(
                      'Select currency',
                      style: const TextStyle(
                        letterSpacing: 2,
                      ),
                    ),
                    selectedTrailingIcon: Icon(Icons.search),
                    width: double.maxFinite,
                    onSelected: (value) {
                      // controller.currency.text = value;
                    },
                    dropdownMenuEntries: controller.currencyStock.map((currency) {
                      return DropdownMenuEntry(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                            side: WidgetStateProperty.all(
                              BorderSide(width: 2, color: AppColors.quarternary),
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(0)),
                              ),
                            ),
                          ),
                          value: currency.currencyCode,
                          label: '${currency.currencyCode}  ${currency.amount}');
                    }).toList(),
                  ),
                  Gap(6),

                  SizedBox(
                    height: 45,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            style: const TextStyle(
                              letterSpacing: 2,
                              // fontFamily: 'Oswald',
                              fontSize: 15,
                              // fontWeight: FontWeight.bold,
                              // color: CupertinoColors.systemBlue,
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            onTap: () => controller.selectedField.value = 'rate',
                            onChanged: (value) {
                              controller.onAmountChanged(value);
                            },

                            // cursorColor: CupertinoColors.systemBlue,
                            cursorWidth: 2,
                            // cursorHeight: 35,
                            textAlign: TextAlign.center,
                            controller: controller.rate,

                            inputFormatters: [
                              CustomFormatter()
                              // LengthLimitingTextInputFormatter(10),
                              // FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                            ],
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              label: Text(
                                'Rate',
                                style: const TextStyle(
                                  letterSpacing: 2,
                                  fontSize: 15,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 1, color: AppColors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 1, color: CupertinoColors.systemBlue),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: TextFormField(
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              onChanged: (value) {
                                controller.onAmountChanged(value);
                              },
                              controller: controller.amount,
                              cursorWidth: 2,
                              style: const TextStyle(
                                letterSpacing: 2,
                                fontFamily: 'Oswald',
                                fontSize: 15,
                              ),
                              inputFormatters: [
                                CustomFormatter()
                                // LengthLimitingTextInputFormatter(10),
                                // FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                              ],
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                // prefix: Text('Amnt:',style:  TextStyle(
                                //     color: CupertinoColors.systemBlue,fontSize: 12,fontWeight: FontWeight.w900)),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                label: Text(
                                  'Amount',
                                  // textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    letterSpacing: 2,
                                    // fontFamily: 'Oswald',
                                    fontSize: 15,
                                    // fontWeight: FontWeight.bold,
                                    // color: CupertinoColors.systemBlue,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(width: 1, color: AppColors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(width: 1, color: CupertinoColors.systemBlue),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(6),
                  // Amount Input Field
                  SizedBox(
                    height: 45,
                    child: TextFormField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onTap: () {
                        controller.selectedField.value = 'total';
                      },
                      onChanged: (value) {
                        controller.onTotalChanged(value);
                      },
                      controller: controller.total,
                      // canRequestFocus: false,
                      // cursorColor: CupertinoColors.systemBlue,
                      cursorWidth: 2,
                      // cursorHeight: 35,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        letterSpacing: 2,
                        // fontFamily: 'Oswald',
                        fontSize: 15,
                        // fontWeight: FontWeight.bold,
                        // color: CupertinoColors.systemBlue,
                      ),
                      inputFormatters: [
                        // ThousandsFormatter()
                        LengthLimitingTextInputFormatter(20),
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                      ],
                      decoration: InputDecoration(
                        // prefix: Text('Amnt:',style:  TextStyle(
                        //     color: CupertinoColors.systemBlue,fontSize: 12,fontWeight: FontWeight.w900)),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        label: Text(
                          'Total',
                          // textAlign: TextAlign.center,
                          style: const TextStyle(
                            letterSpacing: 2,
                            // fontFamily: 'Oswald',
                            fontSize: 15,
                            // fontWeight: FontWeight.bold,
                            // color: CupertinoColors.systemBlue,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1, color: AppColors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 1, color: CupertinoColors.systemBlue),
                        ),
                      ),
                    ),
                  ),
                  Gap(20),

                  Divider(
                    height: 0,
                    // indent: 30,
                    // endIndent: 30,
                  ),
                  Gap(10),
                  SizedBox(
                    height: 38,
                    child: Row(
                      children: [
                        Expanded(
                          child: FloatingActionButton(
                            elevation: 0,
                            backgroundColor: AppColors.quinary,
                            shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.prettyDark, width: 1), borderRadius: BorderRadius.circular(10)),
                            onPressed: () async {
                              final controller = Get.put(NewCurrencyController());
                              await controller.fetchCurrencies();

                              if (context.mounted) {
                                showAddNewCurrencyDialog(context, controller);
                              }
                            },
                            // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                            child: Icon(
                              Icons.add,
                              color: AppColors.prettyDark,
                            ),
                          ),
                        ),
                        Gap(4),
                        Expanded(
                          flex: 5,
                          child: Obx(
                            () => FloatingActionButton(
                              elevation: 0,
                              // style: ElevatedButton.styleFrom(
                              //   padding: EdgeInsets.symmetric(horizontal: 10),
                              //   disabledBackgroundColor: const Color(0xff35689fff),
                              backgroundColor: CupertinoColors.systemBlue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              // ),
                              onPressed: () {
                                showConfirmForexDialog(context);
                              },
                              // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                              child: Text(
                                controller.selectedTransaction.value,
                                style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

showAddNewCurrencyDialog(BuildContext context, NewCurrencyController controller) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(20),
        backgroundColor: AppColors.quinary,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.systemBlue),
          width: double.maxFinite,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Adding new currency',
                  style: TextStyle(
                    color: AppColors.quinary,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColors.quinary,
                  ))
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownMenu(
                  trailingIcon: Icon(
                    Icons.search,
                    color: CupertinoColors.systemBlue,
                    // size: 30,
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: AppColors.quinary,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    constraints: BoxConstraints.tight(const Size.fromHeight(38)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  enableSearch: true,
                  requestFocusOnTap: true,
                  enableFilter: true,
                  menuStyle: MenuStyle(
                    // side: WidgetStateProperty.all(BorderSide(color: Colors.grey,width: 2,)),
                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 0, vertical: 3)),
                    backgroundColor: WidgetStateProperty.all(AppColors.quinary), // Adjust height here,
                    maximumSize: WidgetStateProperty.all(Size(double.infinity, 200)), // Adjust height here
                  ),
                  label: Text('Select currency'),
                  selectedTrailingIcon: Icon(Icons.search),
                  width: double.maxFinite,
                  onSelected: (value) {
                    if (value != null) {
                      controller.currencyName.text = value[1];
                      controller.currencyCode.text = value[0];
                      controller.symbol.text = value[2];
                    }
                  },
                  dropdownMenuEntries: controller.currencyList.entries.where((currency) => currency.value['code'] != controller.baseCurrency.value).map((currency) {
                    return DropdownMenuEntry(
                        labelWidget: Text('${currency.value['name']}, CODE: ${currency.value['code']}, SYMBOL: ${currency.value['symbol']}'),
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                            side: WidgetStateProperty.all(
                              BorderSide(width: 2, color: AppColors.quarternary),
                            ),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(0)),
                            ))),
                        value: [currency.value['code'], currency.value['name'], currency.value['symbol']],
                        label: '${currency.value['name']} CODE: ${currency.value['code']} SYMBOL: ${currency.value['symbol']}');
                  }).toList()),
              Gap(15),
              SizedBox(
                height: 38,
                width: double.maxFinite,
                child: FloatingActionButton(
                    elevation: 0,
                    backgroundColor: CupertinoColors.systemBlue,
                    shape: RoundedRectangleBorder(side: BorderSide(color: CupertinoColors.systemBlue, width: 1), borderRadius: BorderRadius.circular(10)),
                    onPressed: () => controller.addNewCurrency(context),
                    child: Text(
                      'Add currency',
                      style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        ),
      );
    },
  );
}

showConfirmForexDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final NumberFormat formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_us',
        decimalDigits: 2,
      );
      final controller = Get.put(ForexController());
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(8),
        backgroundColor: AppColors.quinary,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.systemBlue),
          width: double.maxFinite,
          // height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Obx(
                  () => Text(
                    ' Confirm ${controller.selectedTransaction.value}ing ${controller.currency.text.trim()}',
                    style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: AppColors.quinary,
                  ))
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text("Transaction type", style: TextStyle()),
                      ),
                      Obx(
                        () => Text(
                          controller.selectedTransaction.value,
                        ),
                      ),
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Currency", style: TextStyle()),
                      ),
                      Text(controller.currency.text.trim()),
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rate',
                      ),
                      Text(controller.rate.text.trim())
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Amount", style: TextStyle()),
                      Text(
                        controller.amount.text.trim(),
                      ),
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Gap(5),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Total", style: TextStyle()),
                      ),
                      Text(
                        formatter.format(double.parse(controller.total.text.replaceAll(',', ''))),
                      ),
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Gap(5),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Description", style: TextStyle()),
                      ),
                      Text(
                        controller.description.text.trim(),
                      ),
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Gap(5),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Date & Time", style: TextStyle(fontWeight: FontWeight.normal)),
                      ),
                      Text(
                        DateFormat('dd MMM yyyy   HH:mm').format(DateTime.now()),
                      ),
                    ],
                  ),
                  Gap(10),
                ],
              ),
            ),
            Divider(
              height: 0,
            ),
            Gap(10),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: SizedBox(
                height: 38,
                width: double.maxFinite,
                child: FloatingActionButton(
                    elevation: 0,
                    // style: ElevatedButton.styleFrom(
                    //   padding: EdgeInsets.symmetric(horizontal: 10),
                    //   disabledBackgroundColor: const Color(0xff35689fff),
                    backgroundColor: CupertinoColors.systemBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    // ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      controller.createForexTransaction(context);
                    },

                    // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: AppColors.quinary, fontSize: 15),
                    )),
              ),
            ),
          ],
        ),
      );
    },
  );
}

showCalculator(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          titlePadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.fromLTRB(70, 0, 30, 0),
          backgroundColor: AppColors.quarternary,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 16),
                child: CalculatorScreen(),
              )));
    },
  ).then((value) {
    // controller.enableOverlayButton.value = true;
  });
}
