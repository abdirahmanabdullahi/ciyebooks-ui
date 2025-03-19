import 'package:ciyebooks/features/forex/controller/new_currency_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/formatters/formatter.dart';
import '../../bank/deposit/deposit_form.dart';
import '../../calculator/calculator_screen.dart';
import '../controller/forex_controller.dart';

showForexForm(BuildContext context) {
  final controller = Get.put(ForexController());
  final newCurrencyController = Get.put(NewCurrencyController());
  final NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 2,
  );

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
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
                          shape:
                              RoundedRectangleBorder(side: BorderSide(width: 1, color: AppColors.grey), borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))),
                          elevation: 0,
                          backgroundColor: controller.selectedTransaction.value == 'Buy' ? CupertinoColors.systemBlue : AppColors.quinary,
                          // selected: controller.selectedTransaction.value == 'Buy',
                          onPressed: () {
                            controller.selectedTransaction.value = 'Buy';
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              controller.selectedTransaction.value == 'Buy'
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
                                  color: controller.selectedTransaction.value == 'Buy' ? Colors.white : CupertinoColors.systemBlue,
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
                          backgroundColor: controller.selectedTransaction.value == 'Sell' ? CupertinoColors.systemBlue : AppColors.quinary,
                          // selected: controller.selectedTransaction.value == 'Buy',
                          onPressed: () {
                            controller.selectedTransaction.value = 'Sell';
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              controller.selectedTransaction.value == 'Sell'
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
                                  color: controller.selectedTransaction.value == 'Sell' ? Colors.white : CupertinoColors.systemBlue,
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
                // controller: controller.category,
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
                    // fontFamily: 'Oswald',
                    // fontSize: 15,
                    // fontWeight: FontWeight.bold,
                    // color: CupertinoColors.systemBlue,
                  ),
                ),
                selectedTrailingIcon: Icon(Icons.search),
                width: double.maxFinite,
                onSelected: (value) {
                  if (value != null && value == 'AddNew') {
                    showAddExpenseCategoryDialog(context);
                  } else {}
                },
                dropdownMenuEntries: controller.currencyStock.map((currency) {
                  return DropdownMenuEntry(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                          side: WidgetStateProperty.all(
                            BorderSide(width: 2, color: AppColors.quarternary),
                          ),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                          ))),
                      value: currency.currencyCode,
                      label: '${currency.currencyCode}  ${currency.currencyName}');
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
                        onChanged: (value) {},
                        // cursorColor: CupertinoColors.systemBlue,
                        cursorWidth: 2,
                        // cursorHeight: 35,
                        textAlign: TextAlign.center,
                        controller: controller.rateController,

                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        ],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          // prefix: Text('Rate:',style:  TextStyle(
                          //     color: CupertinoColors.systemBlue,fontSize: 12,fontWeight: FontWeight.w900)),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          label: Text(
                            'Rate',
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
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: TextFormField(
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          onTap: () {
                            controller.selectedField.value = 'amount';
                          },
                          onChanged: (value) {
                            controller.onAmountChanged(value);
                          },
                          controller: controller.amountController,
                          // canRequestFocus: false,
                          // cursorColor: CupertinoColors.systemBlue,
                          cursorWidth: 2,
                          // cursorHeight: 35,
                          // textAlign: TextAlign.center,
                          // controller: controller.amount,
                          style: const TextStyle(
                            letterSpacing: 2,
                            // fontFamily: 'Oswald',
                            fontSize: 15,
                            // fontWeight: FontWeight.bold,
                            // color: CupertinoColors.systemBlue,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
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
                  controller: controller.totalController,
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

                          // style: FloatingActionButton.styleFrom(
                          //   padding: EdgeInsets.symmetric(horizontal: 10),
                          //   disabledBackgroundColor: const Color(0xff35689fff),
                          //  ),
                          onPressed: () async {
                            final controller = Get.put(NewCurrencyController());
                            await controller.fetchCurrencies();

                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) {
final newCurrencyController = Get.put(NewCurrencyController);
                                  return AlertDialog(
                                    titlePadding: EdgeInsets.zero,
                                    insetPadding: EdgeInsets.all(20),
                                    backgroundColor: AppColors.quinary,
                                    contentPadding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    title: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.systemBlue),
                                      width: double.maxFinite,
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Gap(20),
                                          Text(
                                            'Adding new currency',
                                            style: TextStyle(
                                              color: AppColors.quinary,
                                            ),
                                          ),
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
                                          Gap(10),
                                          SizedBox(
                                            height: 38,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                FloatingActionButton(
                                                    elevation: 0,
                                                    backgroundColor: AppColors.quinary,
                                                    shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.prettyDark, width: 1), borderRadius: BorderRadius.circular(10)),
                                                    onPressed: () {
                                                      if (context.mounted) {
                                                        Navigator.of(context).pop();
                                                      }
                                                    },
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.bold),
                                                    )),
                                                Gap(4),
                                                FloatingActionButton(
                                                    elevation: 0,
                                                    backgroundColor: AppColors.prettyDark,
                                                    shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.prettyDark, width: 1), borderRadius: BorderRadius.circular(10)),
                                                    onPressed: () => controller.addNewCurrency(context),
                                                    child: Text(
                                                      'Add ',
                                                      style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.bold),
                                                    )),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                          child: Icon(
                            Icons.add,
                            color: AppColors.prettyDark,
                          )),
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
                            backgroundColor: CupertinoColors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            // ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    titlePadding: EdgeInsets.zero,
                                    insetPadding: EdgeInsets.all(8),
                                    backgroundColor: AppColors.quinary,
                                    contentPadding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    title: Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.systemBlue),
                                      width: double.maxFinite,
                                      height: 70,
                                      child: Center(
                                        child: Text(
                                          'Confirm expense payment',
                                          style: TextStyle(color: AppColors.quinary, fontSize: 24),
                                        ),
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
                                                  Text('Expenses', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                                                ],
                                              ),
                                              Gap(5),
                                              Divider(thickness: 1, color: Colors.grey[300]),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text("Expense category", style: TextStyle()),
                                                  ),
                                                  Text('controller.category.text', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                                                ],
                                              ),
                                              Gap(5),
                                              Divider(thickness: 1, color: Colors.grey[300]),
                                              Gap(5),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text("Currency", style: TextStyle()),
                                                  ),
                                                  Text('controller.paidCurrency.text', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                                                ],
                                              ),
                                              Gap(5),
                                              Divider(thickness: 1, color: Colors.grey[300]),
                                              Gap(5),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text("Amount", style: TextStyle()),
                                                  ),
                                                  Text(formatter.format(double.parse(controller.amountController.text.replaceAll(',', ''))),
                                                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                                                  Text('controller.description.text.trim()', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                                                  Text(DateFormat('dd MMM yyyy   HH:mm').format(DateTime.now()), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                                                ],
                                              ),
                                              Gap(10),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height: 0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                height: 45,
                                                child: Obx(
                                                  () => ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        padding: EdgeInsets.zero,
                                                        disabledBackgroundColor: const Color(0xff35689fff),
                                                        backgroundColor: CupertinoColors.systemBlue,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                      ),
                                                      onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                                                      child: Text(
                                                        'Pay',
                                                        style: TextStyle(color: AppColors.quinary),
                                                      )),
                                                ),
                                              ),
                                              Gap(10),
                                              SizedBox(
                                                width: 70,
                                                height: 45,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    padding: EdgeInsets.zero,
                                                    foregroundColor: AppColors.quinary,
                                                    backgroundColor: CupertinoColors.destructiveRed,
                                                    disabledBackgroundColor: const Color(0xff35689fff),
                                                  ),
                                                  // elevation: 0,
                                                  // backgroundColor: CupertinoColors.destructiveRed,
                                                  onPressed: () => Navigator.pop(context),
                                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.quinary, fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                            child: Text(
                              controller.selectedTransaction.value,
                              style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w900),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
