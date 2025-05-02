import 'package:ciyebooks/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../../common/widgets/calculator.dart';
import '../../controller/forex_controller.dart';
import '../../controller/new_currency_controller.dart';
import '../forex_home.dart';
import 'confirm_fx_transaction.dart';
import 'new_currency_form.dart';

showForexForm(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final controller = Get.put(ForexController());
      final newCurrencyController = Get.put(NewCurrencyController());

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
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: AppColors.secondary),
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
                            style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w400),
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
                  ],
                ),
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
                              backgroundColor: controller.selectedTransaction.value == 'buyFx' ? AppColors.secondary : AppColors.quinary,
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
                                      color: controller.selectedTransaction.value == 'buyFx' ? Colors.white : AppColors.secondary,
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
                              backgroundColor: controller.selectedTransaction.value == 'sellFx' ? AppColors.secondary : AppColors.quinary,
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
                                      color: controller.selectedTransaction.value == 'sellFx' ? Colors.white : AppColors.secondary,
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
                  Gap(AppSizes.spaceBtwItems),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownMenu(
                          enableFilter: true,
                          controller: controller.currencyCode,
                          trailingIcon: Icon(
                            Icons.search,
                            color: CupertinoColors.systemBlue,
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
                            'Currency',
                            style: const TextStyle(
                              letterSpacing: 2,
                            ),
                          ),
                          selectedTrailingIcon: Icon(Icons.search),
                          width: double.maxFinite,
                          onSelected: (value) {
                            if (value != null) {
                              controller.currencyCode.text = value;
                            }
                          },
                          // dropdownMenuEntries: [
                          //   DropdownMenuEntry(value: 'value', label: 'label'),
                          //   DropdownMenuEntry(value: 'value', label: 'label'),
                          //   DropdownMenuEntry(value: 'value', label: 'label'),
                          //   DropdownMenuEntry(value: 'value', label: 'label')
                          // ],
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
                      ),
                      Gap(AppSizes.spaceBtwItems),
                      Expanded(
                        child: DropdownMenu(
                            controller: controller.type,
                            trailingIcon: Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: CupertinoColors.systemBlue,
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              fillColor: AppColors.quinary,
                              filled: true,
                              isDense: true,
                              // contentPadding: const EdgeInsets.symmetric(horizontal: 0),
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
                            selectedTrailingIcon: Icon(Icons.search),
                            width: double.maxFinite,
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
                              // DropdownMenuEntry(
                              //     style: ButtonStyle(
                              //         backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                              //         side: WidgetStateProperty.all(
                              //           BorderSide(width: 2, color: AppColors.quarternary),
                              //         ),
                              //         shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.all(Radius.circular(0)),
                              //         ))),
                              //     value: 'Mobile money',
                              //     label: 'Mobile money'),
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
                            // onTap: () => controller.selectedField.value = 'rate',
                            onChanged: (value) {
                              controller.onAmountChanged(value);
                            },

                            // cursorColor: CupertinoColors.systemBlue,
                            cursorWidth: 2,
                            // cursorHeight: 35,
                            textAlign: TextAlign.center,
                            controller: controller.rate,

                            inputFormatters: [
                              // CustomFormatter()
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
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
                                // CustomFormatter()
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
                  Gap(AppSizes.spaceBtwItems),
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
                  Gap(AppSizes.spaceBtwItems),

                  // Divider(
                  //   height: 0,
                  //   // indent: 30,
                  //   // endIndent: 30,
                  // ),
                  Gap(AppSizes.spaceBtwItems),
                  SizedBox(
                    height: 45,
                    child: Row(
                      children: [
                        Expanded(
                          child: FloatingActionButton(
                            elevation: 0,
                            backgroundColor: AppColors.quinary,
                            shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.prettyDark, width: 1), borderRadius: BorderRadius.circular(10)),
                            onPressed: () async {

                              if (context.mounted) {
                                showAddNewCurrencyDialog(context,newCurrencyController);
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
                          child:  FloatingActionButton(
                              elevation: 0,
                              // style: ElevatedButton.styleFrom(
                              //   padding: EdgeInsets.symmetric(horizontal: 10),
                              //   disabledBackgroundColor: const Color(0xff35689fff),
                              backgroundColor: AppColors.secondary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              // ),
                              onPressed: () {
                                showConfirmForexTransaction(context);
                              },
                              // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                              child: Text(
                                'Submit',
                                style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w900),
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
