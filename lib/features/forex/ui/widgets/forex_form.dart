import 'package:ciyebooks/features/bank/deposit/screens/deposits.dart';
import 'package:ciyebooks/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/colors.dart';
import '../../../common/widgets/calculator.dart';
import '../../controller/forex_controller.dart';
import '../../controller/new_currency_controller.dart';

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
            backgroundColor: AppColors.quarternary,
            insetPadding: EdgeInsets.all(16),
            contentPadding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            title: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: AppColors.quinary),
              width: double.maxFinite,
              // height: 30,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Forex',
                            style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w400),
                          ),
                        ),
                        IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              Icons.close,
                              color: AppColors.prettyDark,
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: FloatingActionButton(
                            heroTag: 'Forex Buy',
                            shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: AppColors.prettyGrey), borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))),
                            elevation: 0,
                            backgroundColor: controller.selectedTransaction.value == 'BUYFX' ? CupertinoColors.systemBlue : AppColors.quinary,
                            // selected: controller.selectedTransaction.value == 'Buy',
                            onPressed: () {
                              controller.selectedTransaction.value = 'BUYFX';
                              // controller.transactionType.text = 'BUYFX';
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                controller.selectedTransaction.value == 'BUYFX'
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
                                    color: controller.selectedTransaction.value == 'BUYFX' ? Colors.white : AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: FloatingActionButton(
                            heroTag: 'Forex sell',
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: AppColors.prettyGrey), borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
                            backgroundColor: controller.selectedTransaction.value == 'SELLFX' ? AppColors.red : AppColors.quinary,
                            // selected: controller.selectedTransaction.value == 'Buy',
                            onPressed: () {
                              controller.selectedTransaction.value = 'SELLFX';
                              // controller.transactionType.text = 'SELLFX';
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                controller.selectedTransaction.value == 'SELLFX'
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
                                    color: controller.selectedTransaction.value == 'SELLFX' ? Colors.white : AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(AppSizes.spaceBtwItems),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownMenu(
                        enableFilter: true,
                        controller: controller.currencyCode,
                        trailingIcon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: CupertinoColors.systemBlue,
                        ),
                        expandedInsets: EdgeInsets.zero,
                        inputDecorationTheme: InputDecorationTheme(
                          fillColor: AppColors.quinary,
                          filled: true,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                          maximumSize: WidgetStateProperty.all(Size(double.infinity, 500)), // Adjust height here
                        ),

                        label: Text(
                          'Currency',
                          style: const TextStyle(
                            letterSpacing: 2,
                          ),
                        ),
                        selectedTrailingIcon: Icon(Icons.search,color: CupertinoColors.systemBlue,),
                        onSelected: (value) {
                          if (value != null) {
                            controller.currencyCode.text = value[0].toString();
                            controller.currencyStockAmount.text = value[1].toString();
                            print(value[1]);
                            controller.currencyStockTotalCost.text = value[2].toString();
                          }
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
                              value: [currency.currencyCode, currency.amount, currency.totalCost],
                              label: '${currency.currencyCode}  ${currency.amount}');
                        }).toList(),
                      ),
                    ),
                    Gap(AppSizes.spaceBtwItems),
                    Expanded(
                      flex: 2,
                      child: DropdownMenu(
                          controller: controller.type,
                          trailingIcon: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: CupertinoColors.systemBlue,
                          ),
                          expandedInsets: EdgeInsets.zero,
                          inputDecorationTheme: InputDecorationTheme(
                            fillColor: AppColors.quinary,
                            filled: true,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            constraints: BoxConstraints.tight(const Size.fromHeight(45)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          enableSearch: true,
                          requestFocusOnTap: true,
                          enableFilter: true,
                          menuStyle: MenuStyle(
                            padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 0, vertical: 6)),
                            backgroundColor: WidgetStateProperty.all(AppColors.quinary), // Adjust height here,
                            maximumSize: WidgetStateProperty.all(Size(double.infinity, 500)), // Adjust height here
                          ),
                          label: Text(' Type'),
                          selectedTrailingIcon: Icon(Icons.search,color: CupertinoColors.systemBlue,),
                          onSelected: (value) {},
                          dropdownMenuEntries: [
                            DropdownMenuEntry(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                                    side: WidgetStateProperty.all(
                                      BorderSide(width: 2, color: AppColors.quarternary),
                                    ),
                                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(0)),
                                    ))),
                                value: 'Cash',
                                label: 'Cash'),

                            DropdownMenuEntry(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                                    side: WidgetStateProperty.all(
                                      BorderSide(width: 2, color: AppColors.quarternary),
                                    ),
                                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(0)),
                                    ))),
                                value: 'Bank transfer',
                                label: 'Bank transfer'),
                          ]),
                    )
                  ],
                ),
                Gap(AppSizes.spaceBtwItems),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        ],
                        style: const TextStyle(
                          letterSpacing: 2,
                          // fontFamily: 'Oswald',
                          fontSize: 15,

                        ),
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        // ],                            // onTap: () => controller.selectedField.value = 'rate',
                        onChanged: (value) {
                          controller.onAmountChanged(value);
                        },

                        // cursorColor: CupertinoColors.systemBlue,
                        // cursorWidth: 2,
                        // cursorHeight: 35,
                        textAlign: TextAlign.center,
                        controller: controller.sellingRate,

                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        // ],
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
                            borderSide: BorderSide(width: 1, color: AppColors.prettyGrey),
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
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                          ],
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                          // ],
                          onChanged: (value) {
                            controller.onAmountChanged(value);
                          },
                          controller: controller.sellingAmount,
                          cursorWidth: 2,
                          style: const TextStyle(
                            letterSpacing: 2,
                            fontFamily: 'Oswald',
                            fontSize: 15,
                          ),
                          // inputFormatters: [
                          //   // CustomFormatter()
                          //   LengthLimitingTextInputFormatter(10),
                          //   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                          // ],
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


                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(AppSizes.spaceBtwItems),
                // Amount Input Field
                SizedBox(
                  height: 45,
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    ],
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    // ],
                    onTap: () {
                      controller.selectedField.value = 'total';
                    },
                    onChanged: (value) {
                      controller.onTotalChanged(value);
                    },
                    controller: controller.sellingTotal,
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
                    // inputFormatters: [
                    //   // ThousandsFormatter()
                    //   LengthLimitingTextInputFormatter(20),
                    //   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    // ],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                        borderSide: BorderSide(width: 1, color: AppColors.prettyGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 1, color: CupertinoColors.systemBlue),
                      ),
                    ),
                  ),
                ),
                Gap(AppSizes.spaceBtwItems),

                // Divider(
                //   height: 0,
                //   // indent: 30,
                //   // endIndent: 30,
                // ),
                Gap(AppSizes.spaceBtwItems * 2),
                SizedBox(
                  width: double.maxFinite,
                  height: 45,
                  child: Obx(
      ()=> FloatingActionButton(
                      disabledElevation: 0,
                      // style: ElevatedButton.styleFrom(
                      //   padding: EdgeInsets.symmetric(horizontal: 10),
                      //   disabledBackgroundColor: const Color(0xff35689fff),
                      backgroundColor: controller.isButtonEnabled.value?AppColors.prettyBlue:AppColors.prettyGrey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      // ),
                      onPressed:controller.isButtonEnabled.value? () => controller.checkBalances(context):null,
                      // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                      child: Text(
                        'Submit',
                        style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
