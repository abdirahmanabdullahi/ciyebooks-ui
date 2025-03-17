import 'dart:math';

import 'package:ciyebooks/common/styles/custom_container.dart';
import 'package:ciyebooks/features/bank/deposit/controller/deposit_cash_controller.dart';
import 'package:ciyebooks/features/calculator/calculator_screen.dart';
import 'package:ciyebooks/features/pay/pay_client/screens/testing.dart';
import 'package:ciyebooks/features/pay/pay_expense/expense_controller/pay_expense_controller.dart';
import 'package:ciyebooks/features/pay/pay_expense/screens/expense_history.dart';
import 'package:ciyebooks/navigation_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:intl/intl.dart';

import '../../../../utils/constants/colors.dart';
import '../controller/forex_controller.dart';
import 'forex_history.dart';

class ForexForm extends StatelessWidget {
  const ForexForm({super.key});

  @override
  Widget build(BuildContext context) {
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
    final customHeight = ((MediaQuery.sizeOf(context).height - 56) * 0.01);
    final buttonValues = ['9', '8', '7', '6', '5', '4', '3', '2', '1', '.', '0', 'del'];
    final controller = Get.put(ForexController());
    OverlayEntry floatingWidgetOverlay = OverlayEntry(
      builder: (BuildContext context) {    final controller = Get.put(ForexController());

      return Positioned(
          right: 5,
          bottom: 90.0,
          child: Row(
            children: [
              FloatingActionButton(elevation: 7,
                // style: ElevatedButton.styleFrom(elevation: 5,shadowColor: AppColors.prettyDark,
                backgroundColor: AppColors.prettyDark,
                shape: RoundedRectangleBorder(side: BorderSide(width: 0, color: AppColors.prettyDark), borderRadius: BorderRadius.circular(100)),
                // ),
                onPressed: controller.enableOverlayButton.value?() {
                  showCalculator(context);
                  controller.enableOverlayButton.value=!controller.enableOverlayButton.value;
                }:null,
                child: const Icon(
                  size: 25,
                  Iconsax.computing,
                  color: AppColors.quinary,
                ),
              ),
              // Gap(6),
              // Material(
              //   color: Colors.white,
              //   elevation: 5,
              //   shadowColor: AppColors.prettyDark,
              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //     child: Row(
              //       children: [
              //
              //         IconButton(
              //           onPressed: () {},
              //           icon: Icon(
              //             Icons.manage_search_rounded,
              //             color: AppColors.prettyDark,
              //           ),
              //         ),  IconButton(
              //           onPressed: () {
              //             // Handle button press
              //           },
              //           icon: Icon(
              //             Icons.calculate_outlined,
              //             color: AppColors.prettyDark,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
    return GestureDetector(
      onLongPress: () {
        vibrate();
        // floatingWidgetOverlay.mounted
        if (!floatingWidgetOverlay.mounted) {
          Overlay.of(context).insert(floatingWidgetOverlay);

        } else {

          floatingWidgetOverlay.remove();
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            elevation: 0,
            backgroundColor: CupertinoColors.systemBlue,
            shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.quarternary, width: 2), borderRadius: BorderRadius.circular(20)),
            onPressed: () => Get.to(() => ForexHistory()),
            child: Icon(
              Icons.manage_search_rounded,
              color: CupertinoColors.white,
              size: 35,
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        backgroundColor: AppColors.quarternary,
        appBar: AppBar(
          actions: [],
          leading: IconButton(onPressed: () => Get.offAll(NavigationMenu()), icon: Icon(Icons.arrow_back)),
          automaticallyImplyLeading: true,

          title: Text(
            'Forex',
            style: TextStyle(color: Colors.white),
          ),
          // centerTitle: true,
          iconTheme: IconThemeData(color: CupertinoColors.white),
          backgroundColor: CupertinoColors.systemBlue,
          scrolledUnderElevation: 6,
        ),
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(6, customHeight * 4, 6, customHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Obx(
                      () => Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                            // color: AppColors.prettyDark,
                            ),
                        width: double.maxFinite,
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                child: FloatingActionButton(
                                  heroTag: 'Forex Buy',
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1, color: AppColors.grey), borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))),
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
                                          fontSize: 20,
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
                                          fontSize: 20,
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
                    ),
                    Gap(customHeight / 1.5),
                    DropdownMenu(
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
                          constraints: BoxConstraints.tight(const Size.fromHeight(50)),
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
                        width: double.maxFinite,
                        onSelected: (value) {
                          if (value != null && value == 'AddNew') {
                            showAddExpenseCategoryDialog(context);
                          } else {}
                        },
                        dropdownMenuEntries: []
                        // dropdownMenuEntries: controller.expenseCategories.entries.map((entry) {
                        //   return DropdownMenuEntry(
                        //       labelWidget: entry.value == 'AddNew'
                        //           ? Row(
                        //         children: [
                        //           Icon(
                        //             Icons.add_circle_outline,
                        //             color: Colors.black54,
                        //             size: 20,
                        //           ),
                        //           Gap(5),
                        //           Text(
                        //             'Add new category',
                        //             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                        //           )
                        //         ],
                        //       )
                        //           : Text(entry.value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.black)),
                        //       style: ButtonStyle(
                        //           backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                        //           side: WidgetStateProperty.all(
                        //             BorderSide(width: 2, color: AppColors.quarternary),
                        //           ),
                        //           shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.all(Radius.circular(0)),
                        //           ))),
                        //       value: entry.value,
                        //       label: entry.value == 'AddNew' ? '' : '${entry.value}');
                        // }).toList(),
                        ),
                    Gap(customHeight / 1.5),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: customHeight / 1.5),
                            child: TextFormField(
                              onTap: () => controller.selectedField.value = 'amount',

                              controller: controller.amount,
                              canRequestFocus: false,
                              cursorColor: CupertinoColors.systemBlue,
                              cursorWidth: 2,
                              // cursorHeight: 35,
                              textAlign: TextAlign.center,
                              // // controller: controller.amount,
                              // style: const TextStyle(
                              //   letterSpacing: 2,
                              //   // fontFamily: 'Oswald',
                              //   fontSize: 15,
                              //   fontWeight: FontWeight.bold,
                              //   color: CupertinoColors.systemBlue,
                              // ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                              ],
                              decoration: InputDecoration(
                                // prefix: Text('Amnt:',style:  TextStyle(
                                //     color: CupertinoColors.systemBlue,fontSize: 12,fontWeight: FontWeight.w900)),
                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                label: Center(
                                  child: Text(
                                    'Amount',
                                    textAlign: TextAlign.center,
                                    // style: TextStyle(
                                    //   fontSize: 20,
                                    //   fontWeight: FontWeight.w600,
                                    //   color: CupertinoColors.systemBlue,
                                    // ),
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
                                  borderSide: BorderSide(width: .1, color: AppColors.quarternary),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            onTap: () => controller.selectedField.value = 'rate',

                            canRequestFocus: false,
                            cursorColor: CupertinoColors.systemBlue,
                            cursorWidth: 2,
                            // cursorHeight: 35,
                            textAlign: TextAlign.center,
                            controller: controller.rate,
                            // style: const TextStyle(
                            //   letterSpacing: 2,
                            //   // fontFamily: 'Oswald',
                            //   fontSize: 15,
                            //   fontWeight: FontWeight.bold,
                            //   color: CupertinoColors.systemBlue,
                            // ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                            ],
                            decoration: InputDecoration(
                              // prefix: Text('Rate:',style:  TextStyle(
                              //     color: CupertinoColors.systemBlue,fontSize: 12,fontWeight: FontWeight.w900)),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              label: Center(
                                child: Text(
                                  'Rate',
                                  textAlign: TextAlign.center,
                                  // style: TextStyle(
                                  //   fontSize: 20,
                                  //   fontWeight: FontWeight.w600,
                                  //   color: CupertinoColors.systemBlue,
                                  // ),
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
                                borderSide: BorderSide(width: .1, color: AppColors.quarternary),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(customHeight / 1.5),
                    // Amount Input Field
                    TextFormField(readOnly: true,
                      onTap: () => controller.selectedField.value = 'total',

                      controller: controller.total,
                      canRequestFocus: false,
                      cursorColor: CupertinoColors.systemBlue,
                      cursorWidth: 2,
                      // cursorHeight: 35,
                      textAlign: TextAlign.center,
                      // // controller: controller.amount,
                      // style: const TextStyle(
                      //   letterSpacing: 2,
                      //   // fontFamily: 'Oswald',
                      //   fontSize: 15,
                      //   fontWeight: FontWeight.bold,
                      //   color: CupertinoColors.systemBlue,
                      // ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                      ],
                      decoration: InputDecoration(
                        // prefix: Text('Amnt:',style:  TextStyle(
                        //     color: CupertinoColors.systemBlue,fontSize: 12,fontWeight: FontWeight.w900)),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        label: Center(
                          child: Text(
                            'Amount',
                            textAlign: TextAlign.center,
                            // style: TextStyle(
                            //   fontSize: 20,
                            //   fontWeight: FontWeight.w600,
                            //   color: CupertinoColors.systemBlue,
                            // ),
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
                          borderSide: BorderSide(width: .1, color: AppColors.quarternary),
                        ),
                      ),
                    ),
                    Gap(customHeight),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 90.0),
                  child: Container(
                    width: double.infinity,
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),

                // Gap(customHeight),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                  color: AppColors.quinary,
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: customHeight * 3.5),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: customHeight * 1.5,
                        children: buttonValues.map((value) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                            height: 65,
                            child: FloatingActionButton(
                              // splashColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: AppColors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              backgroundColor: AppColors.quinary,
                              heroTag: value,
                              child: value == 'del'
                                  ? Icon(Icons.backspace_outlined, size: 30, color: AppColors.prettyDark)
                                  : Text(
                                      value,
                                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: CupertinoColors.darkBackgroundGray),
                                    ),
                              onPressed: () {
                                value == 'del' ? controller.removeCharacter() : controller.addCharacter(value);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60.0),
                      child: Container(
                        width: double.infinity,
                        height: 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.0, customHeight * 2, 16.0, customHeight * 2),
                      child: SizedBox(
                        width: double.infinity,
                        // height:65,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: const Color(0xff35689fff),
                            backgroundColor: CupertinoColors.systemBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: controller.isButtonEnabled.value
                              ? () => showDialog(
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
                                                      Text(formatter.format(double.parse(controller.amount.text)), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                                  )
                              : null,
                          child: const Text(
                            'Continue',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ]),
                )
              ],
            ),
          ),
          // child: FormWithKeypad(),
        ),
      ),
    );
  }
}

void showAddExpenseCategoryDialog(context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      final controller = Get.put(PayExpenseController());
      return AlertDialog(
        backgroundColor: AppColors.quarternary,
        insetPadding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Column(
          children: [const Text('Add new expense category'), Gap(5), Divider()],
        ),
        content: SizedBox(
            width: double.maxFinite,
            child: TextFormField(
              controller: controller.category,
              decoration: InputDecoration(labelText: 'Category name'),
            )),
        actions: <Widget>[
          OutlinedButton.icon(
            icon: Icon(
              Icons.add_circle_outline,
              color: AppColors.quinary,
            ),
            style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(CupertinoColors.systemBlue), padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10))),
            label: const Text(
              'Add',
              style: TextStyle(color: AppColors.quinary),
            ),
            onPressed: () {
              controller.addNewExpenseCategory();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

showCalculator(BuildContext context) {
  final controller = Get.put(ForexController());
  final NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 2,
  );

  showDialog(
    context: context,
    builder: (context) {
      // Future.delayed(Duration(seconds: 5), () {
      //   if (context.mounted) {
      //     Navigator.of(context).pop();
      //   } // Close the dialog
      // });
      return AlertDialog(
          titlePadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.fromLTRB(25, MediaQuery.sizeOf(context).height/7, 25, 0),
          backgroundColor: AppColors.quarternary,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          content: CalculatorScreen());
    },
  ).then((value) {
    controller.enableOverlayButton.value = true;
  });
  ;
}
