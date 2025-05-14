import 'package:ciyebooks/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import '../../../common/widgets/calculator.dart';
import '../../controllers/pay_expense_controller.dart';
import 'add_expense_category_form.dart';

showExpenseForm(BuildContext context) {
  final controller = Get.put(PayExpenseController());

  return showDialog(
      context: context,
      builder: (context) {
        // final NumberFormat formatter = NumberFormat.decimalPatternDigits(
        //   locale: 'en_us',
        //   decimalDigits: 2,
        // );
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
              insetPadding: EdgeInsets.all(16),
              backgroundColor: AppColors.quarternary,
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
                              'Paying an expense',
                              style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () => showAddExpenseCategoryDialog(context),
                                  icon: Icon(
                                    Icons.add,
                                    color: AppColors.prettyDark,
                                  )), IconButton(
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
                    () => DropdownMenu(
                      controller: controller.category,
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
                        maximumSize: WidgetStateProperty.all(Size(double.infinity, 500)), // Adjust height here
                      ),
                      selectedTrailingIcon: Icon(
                        Icons.search,
                        color: CupertinoColors.systemBlue,
                      ),
                      // width: double.maxFinite,
                      label: Text('Select expense category'),
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
                          label: entry.value,
                        );
                      }).toList(),
                    ),
                  ),
                  Gap(AppSizes.spaceBtwItems),
                  Row(
                    children: [
                      Expanded(flex: 4,
                        child: DropdownMenu(
                            controller: controller.paymentTypeController,
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
                              maximumSize: WidgetStateProperty.all(Size(double.infinity, 500)), // Adjust height here
                            ),
                            label: Text('Payment type'),
                            selectedTrailingIcon: Icon(Icons.search),

                            onSelected: (value) {
                              if (value != null) {
                                controller.paymentType.value = value.trim();
                                controller.paymentTypeController.text = value.trim();
                                controller.updateNewCategoryButton();
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
                      ),        Gap(AppSizes.spaceBtwItems),
                      Expanded(flex: 3,
                        child: DropdownMenu(
                            controller: controller.paidCurrency,
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
                              maximumSize: WidgetStateProperty.all(Size(double.infinity, 500)), // Adjust height here
                            ),
                            label: Text('Currency'),
                            selectedTrailingIcon: Icon(Icons.search),
                            onSelected: (value) {
                              if (value != null) {
                                controller.paidCurrency.text = value;
                              }
                            },
                            dropdownMenuEntries: [DropdownMenuEntry(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                                    side: WidgetStateProperty.all(
                                      BorderSide(width: 2, color: AppColors.quarternary),
                                    ),
                                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(0)),
                                    ))),
                                value: 'USD',
                                label: 'USD',
                                labelWidget: Text(
                                  'USD',
                                  style: TextStyle(color: AppColors.prettyDark),
                                )),DropdownMenuEntry(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                                    side: WidgetStateProperty.all(
                                      BorderSide(width: 2, color: AppColors.quarternary),
                                    ),
                                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(0)),
                                    ))),
                                value: 'KES',
                                label: 'KES',
                                labelWidget: Text(
                                  'KES',
                                  style: TextStyle(color: AppColors.prettyDark),
                                )),]
                        ),
                      ),

                    ],
                  ),


                  Gap(AppSizes.spaceBtwItems),
                  SizedBox(
                    height: 45,
                    child: TextFormField(
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                      ],
                      onChanged: (val) {},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Amount paid";
                        }
                        return null;
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
                  Gap(15),
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
                                  controller.checkbalances(context);
                                }
                              : null,
                          // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                          child: Text(
                            ' Pay',
                            style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w600),
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }).then((_){controller.clearControllers();});
}
