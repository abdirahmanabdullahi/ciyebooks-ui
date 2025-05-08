import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../common/widgets/calculator.dart';
import '../../controller/deposit_cash_controller.dart';

showBankDepositForm(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final controller = Get.put(DepositCashController());
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
            titlePadding: EdgeInsets.zero, insetPadding: EdgeInsets.all(16),
            contentPadding: EdgeInsets.all(16),
            backgroundColor: AppColors.quarternary,
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
                            'Deposit cash at bank',
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
                      () => DropdownMenu(
                    controller: controller.depositedCurrency,
                    trailingIcon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: CupertinoColors.systemBlue,
                    ),
                        expandedInsets: EdgeInsets.zero,
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
                        enableFilter: true,
                        menuStyle: MenuStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 0, vertical: 6)),
                          backgroundColor: WidgetStateProperty.all(AppColors.quinary), // Adjust height here,
                          maximumSize: WidgetStateProperty.all(Size(double.infinity, 500)), // Adjust height here
                        ),

                        label: Text('Select currency'),
                    selectedTrailingIcon: Icon(Icons.search),
                    onSelected: (value) {
                      if (value != null) {
                        controller.depositedCurrency.text = value;
                      }
                    },
                    dropdownMenuEntries: controller.cashBalances.entries.map((currency) {
                      return DropdownMenuEntry(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                              side: WidgetStateProperty.all(
                                BorderSide(width: 2, color: AppColors.quarternary),
                              ),
                              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(0)),
                              ))),
                          value: currency.key,
                          label: currency.key,
                          labelWidget: Text(
                            '${currency.key}  ${formatter.format(currency.value)}',
                            style: TextStyle(color: currency.value == 0 ? Colors.red : null),
                          ));
                    }).toList(),
                  ),
                ),

                Gap(AppSizes.spaceBtwItems),
                SizedBox(
                  height: 45,
                  child: TextFormField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Amount deposited";
                      }
                      return null;
                    },
                    controller: controller.amount,
                    decoration: InputDecoration(                    contentPadding: EdgeInsets.symmetric(horizontal: 16),

                      labelText: "Amount deposited",
                      // constraints: BoxConstraints.tight(
                      // const Size.fromHeight(50),
                      // ),
                    ),
                  ),
                ),
                Gap(AppSizes.spaceBtwItems),
                TextFormField(
                  maxLength: 40,
                  maxLines: 2,
                  minLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Description";
                    }
                    return null;
                  },
                  controller: controller.description,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    labelText: "Description",
                    // constraints: BoxConstraints.tight(
                    // const Size.fromHeight(50),
                    // ),
                  ),
                ),
                Gap(AppSizes.spaceBtwItems),
                SizedBox(
                  height: 45,
                  width: double.maxFinite,
                  child: Obx(
                      ()=> FloatingActionButton(
                        elevation: 0,
                        // style: ElevatedButton.styleFrom(
                        //   padding: EdgeInsets.symmetric(horizontal: 10),
                        //   disabledBackgroundColor: const Color(0xff35689fff),
                        backgroundColor:controller.isButtonEnabled.value?AppColors.prettyBlue:AppColors.prettyGrey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        // ),
                        onPressed:controller.isButtonEnabled.value? () {
                          controller.checkBalances(context);
                        }:null,
                        // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                        child: Text(
                          'Deposit',
                          style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w600),
                        )),
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
