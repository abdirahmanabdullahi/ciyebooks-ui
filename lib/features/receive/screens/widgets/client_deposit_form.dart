import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../common/widgets/calculator.dart';
import '../../controller/receive_from_client_controller.dart';
import 'confirm_client_deposit.dart';

showReceiptForm(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final controller = Get.put(ReceiveFromClientController());
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
            insetPadding: EdgeInsets.all(AppSizes.padding),
            backgroundColor: AppColors.quarternary,
            contentPadding: EdgeInsets.all(AppSizes.padding),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),),
            title: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: AppColors.secondary),
              width: double.maxFinite,
              // height: 30,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Receiving a deposit from client',
                            style: TextStyle(color: AppColors.quinary,fontWeight: FontWeight.w400 ),
                          ),
                        ),IconButton(onPressed: ()=>Navigator.of(context).pop(), icon: Icon(Icons.close,color: AppColors.quinary,))
                      ],
                    ),
                  ],
                ),
              ),
            ),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(AppSizes.spaceBtwItems),
                Obx(
                      () => DropdownMenu(
                    controller: controller.receivingAccountName,
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
                    enableFilter: true,
                    menuStyle: MenuStyle(
                      padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 0, vertical: 6)),
                      backgroundColor: WidgetStateProperty.all(AppColors.quinary), // Adjust height here,
                      maximumSize: WidgetStateProperty.all(Size(double.infinity, 500)), // Adjust height here
                    ),
                    label: Text('Select receiving account'),
                    selectedTrailingIcon: Icon(Icons.search),
                    width: double.maxFinite,
                    onSelected: (value) {
                      if (value != null) {
                        controller.receivingAccountNo.text = value[0].toString();
                        controller.receivingAccountName.text = value[2].toString();

                        final currencyMap = value[1] as Map<String, dynamic>;

                        controller.currency.value = currencyMap.entries.map((entry) => [entry.key, entry.value]).toList();
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
                      child: Obx(
                            () => DropdownMenu(
                          controller: controller.receivedCurrency,
                          trailingIcon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: CupertinoColors.systemBlue,
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: AppColors.quinary,
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
                            // side: WidgetStateProperty.all(BorderSide(color: Colors.grey,width: 2,)),
                            padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 0, vertical: 3)),
                            backgroundColor: WidgetStateProperty.all(AppColors.quinary), // Adjust height here,
                            maximumSize: WidgetStateProperty.all(Size(double.infinity, 500)), // Adjust height here
                          ),
                          label: Text('Currency'),
                          selectedTrailingIcon: Icon(Icons.search),
                          width: double.maxFinite,
                          onSelected: (value) {
                            if (value != null) {
                              controller.receivedCurrency.text = value;
                              print(controller.receivedCurrency.text);
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
                    Gap(10),
                    Expanded(
                      child: DropdownMenu(
                          controller: controller.receiptType,
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
                          label: Text('Deposit type'),
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
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Amount";
                      }
                      return null;
                    },
                    controller: controller.amount,
                    decoration: InputDecoration(
                      labelText: "Amount",
                      // constraints: BoxConstraints.tight(
                      // const Size.fromHeight(50),
                      // ),
                    ),
                  ),
                ),
                Gap(AppSizes.spaceBtwItems),
                Obx(
                      () => Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Checkbox(value: controller.receivedFromOwner.value, onChanged: (value) => controller.receivedFromOwner.value = !controller.receivedFromOwner.value),
                      ),
                      Gap(10),
                      controller.receivedFromOwner.value ? Text('Received from owner') : Text('Received from other')
                    ],
                  ),
                ),
                Gap(AppSizes.spaceBtwItems),
                Obx(
                      () => controller.receivedFromOwner.value
                      ? SizedBox()
                      : Form(
                    key: controller.payClientFormKey,
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Depositor's name is required";
                          }
                          return null;
                        },
                        controller: controller.depositorName,
                        decoration: InputDecoration(
                          labelText: "Depositor name",
                          // constraints: BoxConstraints.tight(
                          // const Size.fromHeight(50),
                          // ),
                        ),
                      ),
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
                  child: FloatingActionButton(
                      elevation: 0,
                      // style: ElevatedButton.styleFrom(
                      //   padding: EdgeInsets.symmetric(horizontal: 10),
                      //   disabledBackgroundColor: const Color(0xff35689fff),
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      // ),
                      onPressed: () {
                        showConfirmClientDeposit(context);
                      },
                      // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                      child: Text(
                        'Receive',
                        style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w900),
                      )),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
