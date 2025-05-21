import 'package:ciyebooks/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/colors.dart';

import '../../../accounts/screens/widgets/create_account_form.dart';
import '../../controllers/pay_client_controller.dart';

showPaymentForm(BuildContext context) {      final controller = Get.put(PayClientController());

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

      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(6),
        contentPadding: EdgeInsets.all(16),
        backgroundColor: AppColors.quarternary,
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
                        'Paying a client',
                        style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: ()  => showCreateAccountDialog(context),
                            icon: Icon(
                              Icons.add,
                              color: AppColors.prettyDark,
                            )),IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              Icons.close,
                              color: AppColors.prettyDark,
                            )),
                      ],
                    )
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
              () => SizedBox(
                width: double.maxFinite,
                height: 45,
                child: DropdownMenu(
                  expandedInsets: EdgeInsets.zero,

                  controller: controller.from,
                  trailingIcon: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: CupertinoColors.systemBlue,
                  ),
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
                  label: Text('Paying account'),
                  selectedTrailingIcon: Icon(
                    Icons.search,
                    color: CupertinoColors.systemBlue,
                  ),
                  // width: double.maxFinite,
                  onSelected: (value) {
                    if (value != null) {
                      controller.updateButtonStatus();
                      controller.from.text = value[2].toString();
                      controller.accountNo.text = value[0].toString();

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
                        label: account.accountName);
                  }).toList(),
                ),
              ),
            ),
            Gap(AppSizes.spaceBtwItems),
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: DropdownMenu(
                      controller: controller.paymentType,
                      expandedInsets: EdgeInsets.zero,
                      trailingIcon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: CupertinoColors.systemBlue,
                      ),
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
                      label: Text('Payment type'),
                      selectedTrailingIcon: Icon(
                        Icons.search,
                        color: CupertinoColors.systemBlue,
                      ),
                      // width: double.maxFinite,
                      onSelected: (value) {
                        controller.updateButtonStatus();
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
                            label: 'cash'),
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
                ),
                Gap(AppSizes.spaceBtwItems),
                Expanded(
                  flex: 5,
                  child: Obx(
                    () => SizedBox(
                      height: 45,
                      child: DropdownMenu(
                        expandedInsets: EdgeInsets.zero,

                        controller: controller.paidCurrency,
                        trailingIcon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: CupertinoColors.systemBlue,
                        ),
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
                        selectedTrailingIcon: Icon(
                          Icons.search,
                          color: CupertinoColors.systemBlue,
                        ),
                        // width: double.maxFinite,
                        onSelected: (value) {
                          if (value != null) {
                            controller.updateButtonStatus();

                            controller.paidCurrency.text = value;
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
                ),
              ],
            ),
            Gap(AppSizes.spaceBtwItems),
            DropdownMenu(
                controller: controller.paidTo,
                expandedInsets: EdgeInsets.zero,
                trailingIcon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: CupertinoColors.systemBlue,
                ),
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
                label: Text('Paid to'),
                selectedTrailingIcon: Icon(
                  Icons.search,
                  color: CupertinoColors.systemBlue,
                ),
                // width: double.maxFinite,
                onSelected: (value) {
                  controller.updateButtonStatus();
                  if (value != null) {
                    controller.paidToOwner.value = value;
                    value ? (controller.receiver.text = controller.from.text.trim(),
                    controller.paidTo.text = controller.from.text.trim()) : controller.receiver.text = '';
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
                ]),
            Obx(
              () => controller.paidToOwner.value
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SizedBox(
                        height: 45,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Receiver's name is required";
                            }
                            return null;
                          },
                          controller: controller.receiver,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),

                            labelText: "Receiver's name",
                            // constraints: BoxConstraints.tight(
                            // const Size.fromHeight(50),
                            // ),
                          ),
                        ),
                      ),
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
                    return "Amount paid";
                  }
                  return null;
                },
                onChanged: (value) {
                  controller.amount.text = value.trim();
                  controller.updateButtonStatus();
                },
                controller: controller.amount,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  labelText: "Amount paid",
                  // constraints: BoxConstraints.tight(
                  // const Size.fromHeight(50),
                  // ),
                ),
              ),
            ),
            Gap(AppSizes.spaceBtwItems),
            TextFormField(
              maxLength: 40,
              maxLines: 3,
              minLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Description";
                }
                return null;
              },
              controller: controller.description,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),

                labelText: "Description",
                // constraints: BoxConstraints.tight(
                // const Size.fromHeight(50),
                // ),
              ),
            ),
            Gap(10),
            SizedBox(
              height: 45,
              width: double.maxFinite,
              child: Obx(
                () => FloatingActionButton(
                    disabledElevation: 0,
                    // elevation: 10,
                    // style: ElevatedButton.styleFrom(
                    //   padding: EdgeInsets.symmetric(horizontal: 10),
                    //   disabledBackgroundColor: const Color(0xff35689fff),
                    backgroundColor: controller.isButtonEnabled.value? AppColors.prettyBlue : AppColors.prettyGrey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    // ),
                    onPressed: controller.isButtonEnabled.value
                        ? () {
                            controller.checkBalances(context);
                          }
                        : null,
                    // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                    child: Text(
                      'Pay',
                      style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w600),
                    )),
              ),
            ),
          ],
        ),
      );
    },
  ).then((_){
    controller.clearController();  });
}
