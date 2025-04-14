import 'package:ciyebooks/features/bank/withdraw/screens/withdraw_form.dart';
import 'package:ciyebooks/features/pay/pay_client/pay_client_controller/pay_client_controller.dart';
import 'package:ciyebooks/features/pay/pay_client/pay_client_model/pay_client_model.dart';
import 'package:ciyebooks/features/pay/pay_expense/expense_controller/pay_expense_controller.dart';
import 'package:ciyebooks/features/pay/widgets/expenses.dart';
import 'package:ciyebooks/navigation_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../../../common/styles/custom_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../dashboard/widgets/bottom_sheet_button.dart';
import '../../forex/ui/test.dart';
import '../widgets/payments.dart';

class PaymentHistory extends StatelessWidget {
  const PaymentHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PayClientController());
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );

    return Scaffold(
      backgroundColor: AppColors.quarternary,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.prettyDark,
        shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.prettyDark, width: 2), borderRadius: BorderRadius.circular(100)),
        onPressed: () {
          showModalBottomSheet<dynamic>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext bc) {
              return Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Make a payment",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Gap(20),
                        Divider(
                          height: 0,
                        ),
                        BottomSheetButton(
                          heroTag: "Pay client",
                          label: "Pay client",
                          icon: Icons.north_east,
                          onPressed: () {
                            Get.back();

                            showPaymentForm(context);
                          },
                        ),
                        Divider(
                          height: 0,
                        ),
                        BottomSheetButton(
                            heroTag: "Pay an expense",
                            label: "Pay an expense",
                            icon: Icons.shopping_bag,
                            onPressed: () {
                              Get.back();
                              showExpenseForm(context);
                            }),
                        Divider(
                          height: 0,
                        ),
                        Gap(60),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: AppColors.quinary,
          // size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () => Get.offAll(NavigationMenu()),
              icon: Icon(
                Icons.close,
                color: AppColors.prettyDark,
              )),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.quarternary,
        title: Text(
          'Payment history',
          style: TextStyle(color: AppColors.prettyDark),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: DefaultTabController(
            length: 2,
            child: Column(children: [
              Container(
                color: AppColors.quinary,
                child: TabBar(
                  padding: EdgeInsets.zero,
                  indicatorColor: CupertinoColors.systemBlue,
                  labelPadding: EdgeInsets.zero,
                  labelStyle: TextStyle(color: CupertinoColors.systemBlue, fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(
                      height: 35,
                      child: Text(
                        'Payments',
                        // style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Tab(
                      height: 35,
                      child: Text(
                        'Expenses',
                        // style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(children: [PaymentsHistory(), ExpenseHistory()]),
              )
            ])),
      ),
    );
  }



}
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
              insetPadding: EdgeInsets.all(8),
              backgroundColor: AppColors.quarternary,
              contentPadding: EdgeInsets.all(6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              title: Container(padding: EdgeInsets.only(left: 15),
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
              content: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Gap(15),
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
                        onSelected: (value) {
                          if (value != null && value == 'AddNew') {
                            showAddExpenseCategoryDialog(context);
                          } else {}
                        },
                        dropdownMenuEntries: controller.expenseCategories.entries.map((entry) {
                          return DropdownMenuEntry(
                              labelWidget: entry.value == 'AddNew'
                                  ? Row(
                                children: [
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                  Gap(5),
                                  Text(
                                    'Add new category',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                                  )
                                ],
                              )
                                  : Text(entry.value, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.black)),
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
                    ),
                    Gap(10),
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
                        label: Text('Select currency'),
                        selectedTrailingIcon: Icon(Icons.search),
                        width: double.maxFinite,
                        onSelected: (value) {
                          if (value != null) {
                            controller.paidCurrency.text = value;
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
                    Gap(10),
                    SizedBox(
                      height: 45,
                      child: TextFormField(
                        onChanged: (val){
                          print(val);
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
                    ),
                    Gap(10),

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
                    Gap(10),
                    SizedBox(
                      height: 38,
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
                            Navigator.of(context).pop();
                            showConfirmExpenseDialog(context);
                          },
                          // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                          child: Text(
                            ' Pay',
                            style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w900),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
showAddExpenseCategoryDialog(context) {
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
showConfirmExpenseDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final NumberFormat formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_us',
        decimalDigits: 2,
      );
      final controller = Get.put(PayExpenseController());
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(8),
        backgroundColor: AppColors.quinary,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Container(padding: EdgeInsets.only(left: 15),
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.systemBlue),
          width: double.maxFinite,
          // height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Confirm expense',
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
                      Text(
                        'Expense',
                      ),
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Category", style: TextStyle()),
                      ),
                      Text(
                        controller.category.text.trim(),
                      ),
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Currency',
                      ), Text(
                        controller.paidCurrency.text.trim(),
                      ),

                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Amount paid", style: TextStyle()),
                      Text(
                        controller.amount.text.trim(),
                      ),
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
                      Text(
                        controller.description.text.trim(),
                      ),
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
                      Text(
                        DateFormat('dd MMM yyyy   HH:mm').format(DateTime.now()),
                      ),
                    ],
                  ),
                  Gap(10),
                ],
              ),
            ),
            Divider(
              height: 0,
            ),
            Gap(10),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: SizedBox(
                height: 38,
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

                      controller.createExpense(context);
                    },

                    // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: AppColors.quinary, fontSize: 15),
                    )),
              ),
            ),
          ],
        ),
      );
    },
  );
}
showPaymentForm(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final controller = Get.put(PayClientController());
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
            insetPadding: EdgeInsets.all(8),
            backgroundColor: AppColors.quarternary,
            contentPadding: EdgeInsets.all(6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            title: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.systemBlue),
              width: double.maxFinite,
              // height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Gap(30),
                      Icon(
                        Icons.currency_exchange,
                        color: AppColors.quinary,
                        // size: 25,
                      ),
                      Gap(15),
                      Text(
                        'Paying a client',
                        style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w500),
                      ),
                    ],
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
            content: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gap(10),
                  Obx(
                        () => SizedBox(
                      height: 45,
                      child: DropdownMenu(
                        controller: controller.from,
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
                        label: Text('Paying account'),
                        selectedTrailingIcon: Icon(Icons.search),
                        width: double.maxFinite,
                        onSelected: (value) {
                          if (value != null) {
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
                  Gap(10),
                  Obx(
                        () => SizedBox(
                      height: 45,
                      child: DropdownMenu(
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
                        label: Text('Currency paid'),
                        selectedTrailingIcon: Icon(Icons.search),
                        width: double.maxFinite,
                        onSelected: (value) {
                          if (value != null) {
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
                  SizedBox(height: 15),
                  Obx(
                        () => Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Checkbox(value: controller.paidToOwner.value, onChanged: (value) => controller.paidToOwner.value = !controller.paidToOwner.value),
                        ),
                        Gap(10),
                        controller.paidToOwner.value ? Text('Paid to owner') : Text('Paid to a other')
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Obx(
                        () => controller.paidToOwner.value
                        ? SizedBox()
                        : Form(
                      key: controller.payClientFormKey,
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
                            labelText: "Receiver's name",
                            // constraints: BoxConstraints.tight(
                            // const Size.fromHeight(50),
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(10),
                  SizedBox(
                    height: 45,
                    child: TextFormField(
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
                  ),
                  Gap(10),
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
                  Gap(15),
                  SizedBox(
                    height: 38,
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
                          Navigator.of(context).pop();
                          showConfirmPayment(context);
                        },
                        // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                        child: Text(
                          ' Pay',
                          style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w900),
                        )),
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

showConfirmPayment(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final NumberFormat formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_us',
        decimalDigits: 2,
      );
      final controller = Get.put(PayClientController());
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(8),
        backgroundColor: AppColors.quinary,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.systemBlue),
          width: double.maxFinite,
          // height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Gap(30),
                  Icon(
                    Icons.currency_exchange,
                    color: AppColors.quinary,
                    // size: 25,
                  ),
                  Gap(15),
                  Text(
                    'Confirm payment',
                    style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w500),
                  ),
                ],
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
                      Text(
                        'Payment',
                      ),
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Payee", style: TextStyle()),
                      ),
                      Text(
                        controller.from.text.trim(),
                      ),
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Receiver',
                      ),
                      Obx(
                            () => controller.paidToOwner.value
                            ? Text(
                          "Account holder",
                        )
                            : Text(
                          controller.receiver.text,
                        ),
                      ),
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Paid currency", style: TextStyle()),
                      Text(
                        controller.paidCurrency.text.trim(),
                      ),
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
                      Text(
                        formatter.format(double.parse(controller.amount.text.replaceAll(',', ''))),
                      ),
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
                      Text(
                        controller.description.text.trim(),
                      ),
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
                      Text(
                        DateFormat('dd MMM yyyy   HH:mm').format(DateTime.now()),
                      ),
                    ],
                  ),
                  Gap(10),
                ],
              ),
            ),
            Divider(
              height: 0,
            ),
            Gap(10),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: SizedBox(
                height: 38,
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
                      Navigator.of(context).pop();
                      controller.createPayment(context);
                    },

                    // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: AppColors.quinary, fontSize: 15),
                    )),
              ),
            ),
          ],
        ),
      );
    },
  );
}