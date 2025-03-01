import 'package:ciyebooks/features/pay/pay_expense/expense_controller/pay_expense_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../../../utils/constants/colors.dart';

class PayExpenseForm extends StatelessWidget {
  const PayExpenseForm({super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    final buttonValues = ['9', '8', '7', '6', '5', '4', '3', '2', '1', '.', '0', 'del'];
    final controller = Get.put(PayExpenseController());

    return Scaffold(
      backgroundColor: AppColors.quarternary,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Text(
            'Paying an expense',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: CupertinoColors.white),
          backgroundColor: CupertinoColors.systemBlue,
          scrolledUnderElevation: 6,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Obx(
                      () => DropdownMenu(
                        controller: controller.category,
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
                        label: Text('Select expense category'),
                        selectedTrailingIcon: Icon(Icons.search),
                        width: double.maxFinite,
                        onSelected: (value) {
                          if (value != null) {
                            }
                        },
                        dropdownMenuEntries: controller.expenseCategories.entries.map((entry) {
                          return DropdownMenuEntry(
                            labelWidget: Text(entry.value,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12,color: Colors.black54),),
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                                  side: WidgetStateProperty.all(
                                    BorderSide(width: 2, color: AppColors.quarternary),
                                  ),
                                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(0)),
                                  ))),
                              value: entry.value,
                              label: '${entry.value}'
                              
                          );
                          
                        }).toList(),
                      ),
                    ),
                    Gap(15),
                    Obx(
                      () => DropdownMenu(
                        controller: controller.paidCurrency,
                        trailingIcon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: CupertinoColors.systemBlue,
                          size: 30,
                        ),
                        inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          fillColor: AppColors.quinary,
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
                          // side: WidgetStateProperty.all(BorderSide(color: Colors.grey,width: 2,)),
                          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 0, vertical: 3)),
                          backgroundColor: WidgetStateProperty.all(AppColors.quinary), // Adjust height here,
                          maximumSize: WidgetStateProperty.all(Size(double.infinity, 500)), // Adjust height here
                        ),
                        label: Text('Select currency'),
                        selectedTrailingIcon: Icon(Icons.search),
                        width: double.maxFinite,
                        onSelected: (value) {
                          print(value);
                          if (value != null) {
                            controller.paidCurrency.text = value;
                          }
                        },
                        dropdownMenuEntries: controller.cashBalances.entries.map((currency) {
                          print(currency);
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
                              )
                          );
                        }).toList(),

                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      maxLines: 2,
                      controller: controller.description,
                      decoration: InputDecoration(
                        labelText: "Description",
                        // constraints: BoxConstraints.tight(
                        // const Size.fromHeight(50),
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: Container(
                  width: double.infinity,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Amount Input Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  canRequestFocus: false,
                  cursorColor: CupertinoColors.activeGreen,
                  cursorWidth: 2,
                  // cursorHeight: 35,
                  textAlign: TextAlign.center,
                  controller: controller.amount,
                  style: const TextStyle(
                    letterSpacing: 2,
                    // fontFamily: 'Oswald',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.systemBlue,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                  decoration: InputDecoration(
                    // prefix: Text(controller.paidCurrency.value.text,style: TextStyle(
                    //     color: AppColors.prettyDark,fontSize: 25,fontWeight: FontWeight.w300),),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    label: Center(
                      child: Text(
                        '0',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.systemBlue,
                        ),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(width: 1, color: AppColors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(width: .1, color: AppColors.quarternary),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
                child: Card(
                  elevation: 2,
                  color: AppColors.quinary,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: buttonValues.map((value) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              height: 65,
                              child: FloatingActionButton(
                                splashColor: Colors.transparent,
                                // elevation: 3,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 0.001,
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
                        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 20.0),
                        child: SizedBox(
                          width: double.infinity,
                          // height:65,
                          child: Obx(
                            () => ElevatedButton(
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
                                              decoration:
                                                  BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.systemBlue),
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
                                                          Text(controller.category.text, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                                                          Text(controller.paidCurrency.text,
                                                              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                                                      Gap(5), Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text("Description", style: TextStyle()),
                                                          ),
                                                          Text(controller.description.text.trim(), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // child: FormWithKeypad(),
      ),
    );
  }
}
