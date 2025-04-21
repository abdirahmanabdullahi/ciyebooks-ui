import 'package:ciyebooks/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utils/constants/colors.dart';
import '../../../common/widgets/calculator.dart';
import '../../controllers/pay_expense_controller.dart';
import 'confirm_expense.dart';

showExpenseForm(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        final controller = Get.put(PayExpenseController());
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
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              title: Container(
                padding: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.systemBlue),
                width: double.maxFinite,
                // height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Paying an expense',
                      style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w500),
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
                children: [
                  Gap(AppSizes.spaceBtwItems),
                  Obx(
                        () => DropdownMenu(
                      controller: controller.category,
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
                      label: Text('Select expense category'),
                      selectedTrailingIcon: Icon(Icons.search),
                      width: double.maxFinite,
                      onSelected: (value) {},
                      dropdownMenuEntries: controller.expenseCategories.entries.map((entry) {
                        return DropdownMenuEntry(
                            labelWidget: Text(entry.value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.black)),
                            style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                                side: WidgetStateProperty.all(
                                  BorderSide(width: 2, color: AppColors.quarternary),
                                ),
                                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(0)),
                                ))),
                            value: entry.value,
                            label: entry.value == 'AddNew' ? '' : '${entry.value}');
                      }).toList(),
                    ),
                  ),              Gap(AppSizes.spaceBtwItems),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownMenu(
                          // controller: controller.paymentType,
                            trailingIcon: Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: CupertinoColors.systemBlue,
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              fillColor: AppColors.quinary,
                              filled: true,
                              isDense: true,
                              // contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
                            label: Text('Payment type'),
                            selectedTrailingIcon: Icon(Icons.search),
                            width: double.maxFinite,
                            onSelected: (value) {
                              if(value!=null){
                                controller.paymentType.value = value;

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
                                  label: 'cash'),
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
                                  value: 'Bank',
                                  label: 'Bank'),
                            ]),
                      ),
                      Gap(AppSizes.spaceBtwItems),
                      Expanded(
                        child: Obx(
                              () => DropdownMenu(
                            controller: controller.paidCurrency,
                            trailingIcon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: CupertinoColors.systemBlue,
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              filled: true,
                              fillColor: AppColors.quinary,
                              isDense: true,
                              // contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
                                controller.paidCurrency.text = value;
                              }
                            },
                            dropdownMenuEntries: controller.paymentType.value != 'Bank'
                                ? controller.cashBalances.entries.map((currency) {
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
                            }).toList()
                                : controller.bankBalances.entries.map((currency) {
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
                      ),
                    ],
                  ),              Gap(AppSizes.spaceBtwItems),

                  SizedBox(
                    height: 45,
                    child: TextFormField(
                      onChanged: (val) {
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Amount paid";
                        }
                        return null;
                      },
                      controller: controller.amount,
                      decoration: InputDecoration(
                        labelText: "Amount paid",
                        // constraints: BoxConstraints.tight(
                        // const Size.fromHeight(50),
                        // ),
                      ),
                    ),
                  ),              Gap(AppSizes.spaceBtwItems),

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

                  Gap(15),SizedBox(
                    height: AppSizes.buttonHeight,
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
                          showConfirmExpenseDialog(context);
                        },
                        // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                        child: Text(
                          ' Pay',
                          style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w600),
                        )),
                  )
                ],
              ),
            ),
          ),
        );
      });
}
