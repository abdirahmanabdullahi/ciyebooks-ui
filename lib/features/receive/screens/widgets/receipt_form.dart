import 'package:ciyebooks/features/accounts/screens/widgets/create_account_form.dart';
import 'package:ciyebooks/features/receive/screens/widgets/confirm_receipt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controller/receipt.dart';

showReceiptForm(BuildContext context) {
  final controller = Get.put(ReceiptController());

  return showDialog(
    context: context,
    builder: (context) {
      final NumberFormat formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_us',
        decimalDigits: 2,
      );
      // Future<void> vibrate() async {
      //   await SystemChannels.platform.invokeMethod<void>(
      //     'HapticFeedback.vibrate',
      //     'HapticFeedbackType.lightImpact',
      //   );
      // }

      return PopScope(
        canPop: false,
        child: AlertDialog(
          titlePadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.all(6),
          backgroundColor: AppColors.quarternary,
          contentPadding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)), color: AppColors.quinary),
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
                          'Receipt',
                          style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Row(children: [IconButton(
                          onPressed: () => showCreateAccountDialog(context),
                          icon: Icon(
                            Icons.add,
                            color: AppColors.prettyDark,
                          )),Gap(20), IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.close,
                            color: AppColors.prettyDark,
                          )),Gap(20),],)
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
                  controller: controller.receivingAccountName,
                  trailingIcon: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: CupertinoColors.systemBlue,
                  ),
                  expandedInsets: EdgeInsets.zero,
                  inputDecorationTheme: InputDecorationTheme(
                    fillColor: AppColors.quinary,
                    filled: true,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
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
                    maximumSize: WidgetStateProperty.all(Size(double.infinity, 200)), // Adjust height here
                  ),
                  label: Text('Select receiving account'),
                  selectedTrailingIcon: Icon(
                    Icons.search,
                    color: CupertinoColors.systemBlue,
                  ),
                  onSelected: (value) {
                    if (value != null) {
                      controller.receivingAccountNo.text = value[0].toString();
                      controller.receivingAccountName.text = value[2].toString();
                      final currencyMap = value[1] as Map<String, dynamic>;
                      controller.currency.value = currencyMap.entries.map((entry) => [entry.key, entry.value]).toList();
                      controller.updateButtonStatus();
                    }
                  },
                  dropdownMenuEntries: controller.accounts.map((account) {
                    return DropdownMenuEntry(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                            side: WidgetStateProperty.all(
                              BorderSide(width: 2, color: AppColors.quarternary),
                            ),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(0)),
                            ))),
                        value: [account.accountNo, account.currencies, account.accountName],
                        label: '${account.fullName} Account no:  ${account.accountNo}');
                  }).toList(),
                ),
              ),
              Gap(AppSizes.spaceBtwItems),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: DropdownMenu(
                        controller: controller.receiptType,
                        trailingIcon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: CupertinoColors.systemBlue,
                        ),
                        expandedInsets: EdgeInsets.zero,
                        inputDecorationTheme: InputDecorationTheme(
                          fillColor: AppColors.quinary,
                          filled: true,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
                          maximumSize: WidgetStateProperty.all(Size(double.infinity, 200)), // Adjust height here
                        ),
                        label: Text('Deposit type'),
                        selectedTrailingIcon: Icon(Icons.search),
                        onSelected: (value) {
                          if (value != null) {
                            controller.receiptType.text = value.trim();
                            controller.updateButtonStatus();

                            // print(value);
                            // controller.paymentType.value = value.trim();
                            // controller.paymentTypeController.text = value.trim();
                            // print(   controller.paymentTypeController.text);
                            // controller.updateNewCategoryButton();
                          }
                        },
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
                              value: 'Bank',
                              label: 'Bank'),
                          DropdownMenuEntry(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                                  side: WidgetStateProperty.all(
                                    BorderSide(width: 2, color: AppColors.quarternary),
                                  ),
                                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(0)),
                                  ))),
                              value: 'Mobile money',
                              label: 'Mobile money'),
                        ]),
                  ),
                  Gap(AppSizes.spaceBtwItems),
                  Expanded(
                    flex: 5,
                    child: Obx(
                      () => DropdownMenu(
                        controller: controller.receivedCurrency,
                        trailingIcon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: CupertinoColors.systemBlue,
                        ),
                        expandedInsets: EdgeInsets.zero,
                        inputDecorationTheme: InputDecorationTheme(
                          fillColor: AppColors.quinary,
                          filled: true,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
                          maximumSize: WidgetStateProperty.all(Size(double.infinity, 200)), // Adjust height here
                        ),
                        label: Text('Currency'),
                        selectedTrailingIcon: Icon(Icons.search),
                        onSelected: (value) {
                          if (value != null) {
                            controller.receivedCurrency.text = value;
                            controller.updateButtonStatus();
                          }
                        },
                        dropdownMenuEntries: controller.currency.map((currency) {
                          // Ensure valid data structure

                          // Convert first item to a proper currency string
                          String currencyName = currency[0].toString().toUpperCase(); // Ensure consistency
                          num balance = num.tryParse(currency[1].toString()) ?? 0;
                          return DropdownMenuEntry(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                                  side: WidgetStateProperty.all(
                                    BorderSide(width: 2, color: AppColors.quarternary),
                                  ),
                                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(0)),
                                  ))),
                              value: currencyName,
                              label: '$currencyName     ${formatter.format(balance)}',
                              labelWidget: Text(
                                '$currencyName     ${formatter.format(balance)}',
                                style: TextStyle(color: balance <= 0 ? Colors.red : null),
                              ));
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),

              Gap(AppSizes.spaceBtwItems),
              DropdownMenu(
                  controller: controller.receivedFrom,
                  trailingIcon: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: CupertinoColors.systemBlue,
                  ),
                  expandedInsets: EdgeInsets.zero,
                  inputDecorationTheme: InputDecorationTheme(
                    fillColor: AppColors.quinary,
                    filled: true,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
                    maximumSize: WidgetStateProperty.all(Size(double.infinity, 200)), // Adjust height here
                  ),
                  label: Text('Received from'),
                  selectedTrailingIcon: Icon(Icons.search),
                  onSelected: (value) {
                    controller.updateButtonStatus();
                    if (value != null) {
                      controller.receivedFromOwner.value = value;
                      value
                          ? (controller.depositorName.text = controller.receivingAccountName.text.trim(),
                      controller.receivedFrom.text = controller.receivingAccountName.text.trim())
                          : controller.depositorName.text = '';
                    }
                  },
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
                        value: true,
                        label: 'Owner'),
                    DropdownMenuEntry(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                            side: WidgetStateProperty.all(
                              BorderSide(width: 2, color: AppColors.quarternary),
                            ),
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(0)),
                            ))),
                        value: false,
                        label: 'Other'),
                  ]),
              Gap(AppSizes.spaceBtwItems),
              Obx(
                () => controller.receivedFromOwner.value
                    ? SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.spaceBtwItems),
                        child: SizedBox(
                          height: 45,
                          child: TextFormField(
                            onChanged: (value) {
                              controller.updateButtonStatus();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Depositor's name is required";
                              }
                              return null;
                            },
                            controller: controller.depositorName,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                              labelText: "Depositor name",
                              // constraints: BoxConstraints.tight(
                              // const Size.fromHeight(50),
                              // ),
                            ),
                          ),
                        ),
                      ),
              ),
              // Gap(AppSizes.spaceBtwItems),
              SizedBox(
                height: 45,
                child: TextFormField(
                  onChanged: (value) {
                    controller.updateButtonStatus();
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Amount";
                    }
                    return null;
                  },
                  controller: controller.amount,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    labelText: "Amount",
                    // constraints: BoxConstraints.tight(
                    // const Size.fromHeight(50),
                    // ),
                  ),
                ),
              ),
              Gap(AppSizes.spaceBtwItems),
              TextFormField(
                maxLength: 20,
            
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Description";
                  }
                  return null;
                },
                controller: controller.description,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical:16 ),
                  labelText: "Description",
                  // constraints: BoxConstraints.tight(
                  // const Size.fromHeight(50),
                  // ),
                ),
              ),
              Gap(AppSizes.spaceBtwItems),
              SizedBox(
                height: AppSizes.buttonHeight,
                width: double.maxFinite,
                child: Obx(
                  () => FloatingActionButton(
                      elevation: 0,
                      // style: ElevatedButton.styleFrom(
                      //   padding: EdgeInsets.symmetric(horizontal: 10),
                      //   disabledBackgroundColor: const Color(0xff35689fff),
                      backgroundColor: controller.isButtonEnabled.value ? AppColors.prettyBlue : AppColors.prettyGrey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      // ),
                      onPressed: controller.isButtonEnabled.value
                          ? () {
                              showConfirmClientDeposit(context);
                            }
                          : null, // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                      child: Text(
                        'Receive',
                        style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w600),
                      )),
                ),
              ),Gap(3)
            ],
          ),
        ),
      );
    },
  ).then((_) {
    controller.clearControllers();
  });
}
