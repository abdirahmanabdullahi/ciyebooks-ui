import 'package:ciyebooks/features/bank/withdraw/controllers/withdraw_cash_controller.dart';
import 'package:ciyebooks/features/bank/withdraw/screens/deposits.dart';
import 'package:ciyebooks/features/bank/withdraw/screens/transfers.dart';
import 'package:ciyebooks/features/bank/withdraw/screens/withdraw_form.dart';
import 'package:ciyebooks/features/bank/withdraw/screens/withdrawals.dart';
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
import 'package:get_storage/get_storage.dart';

import 'package:intl/intl.dart';

import '../../common/styles/custom_container.dart';
import '../../utils/constants/colors.dart';
import '../dashboard/widgets/bottom_sheet_button.dart';
import '../forex/ui/forex_home.dart';
import '../pay/widgets/payments.dart';
import 'deposit/controller/deposit_cash_controller.dart';

class BankHistory extends StatelessWidget {
  const BankHistory({super.key});

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
                          "Bank",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Gap(20),
                        Divider(
                          height: 0,
                        ),
                        BottomSheetButton(
                          heroTag: "Deposit cash at bank",
                          label: "Deposit cash at bank",
                          icon: Icons.arrow_downward,
                          onPressed: () {
                            Get.back();
                            showDepositForm(context);
                          },
                        ),
                        Divider(
                          height: 0,
                        ),
                        BottomSheetButton(
                          heroTag: "Withdraw cash from bank",
                          label: "Withdraw cash from bank",
                          icon: Icons.list_alt,
                          onPressed: () {
                            Get.back();
                          showWithdrawalForm(context);
                          },
                        ),


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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
          'Bank history',
          style: TextStyle(color: AppColors.prettyDark),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
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
                        'Deposits',
                        // style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Tab(
                      height: 35,
                      child: Text(
                        'Withdrawals',
                        // style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),

                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Deposits(),
                    Withdrawals(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

showDepositForm(BuildContext context) {
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
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Depositing cash at bank',
                      style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w500),
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
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(10),
                Obx(
                  () => DropdownMenu(
                    controller: controller.depositedCurrency,
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
                Gap(10),

                Obx(
                  () => Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Checkbox(value: controller.depositedByOwner.value, onChanged: (value) => controller.depositedByOwner.value = !controller.depositedByOwner.value),
                      ),
                      Gap(10),
                      controller.depositedByOwner.value ? Text('Deposited by owner') : Text('Deposited by other')
                    ],
                  ),
                ),
                // Gap(10),
                Obx(
                  () => controller.depositedByOwner.value
                      ? SizedBox()
                      : Form(
                          // key: controller.payClientFormKey,
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
                                labelText: "Depositor's name",
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
                        return "Amount deposited";
                      }
                      return null;
                    },
                    controller: controller.amount,
                    decoration: InputDecoration(
                      labelText: "Amount deposited",
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
                        showConfirmDeposit(context);
                      },
                      // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                      child: Text(
                        'Deposit',
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
showConfirmDeposit(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final NumberFormat formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_us',
        decimalDigits: 2,
      );
      final controller = Get.put(DepositCashController());
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

              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Confirm bank deposit',
                  style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w500),
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
                        'Deposit',
                      ),
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaction code',
                      ), Text(
                        'BKDP-${controller.transactionCounter.value}',
                      ),

                    ],
                  ),


                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Deposited by',
                      ),
                      Obx(
                            () => controller.depositedByOwner.value
                            ? Text(
                          "Account holder",
                        )
                            : Text(
                          controller.depositorName.text.trim(),
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
                      Text("Deposited currency", style: TextStyle()),
                      Text(
                        controller.depositedCurrency.text.trim(),
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
                      controller.createBankDeposit(context);
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
showWithdrawalForm(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final controller = Get.put(WithdrawCashController());
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
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Withdraw cash from bank',
                      style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w500),
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
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(10),
                Obx(
                      () => DropdownMenu(
                    controller: controller.withdrawnCurrency,
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
                      if (value != null) {
                        controller.withdrawnCurrency.text = value;
                      }
                    },
                    dropdownMenuEntries: controller.bankBalances.entries.map((currency) {
                      print('${currency.key}${currency.value}');
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Amount withdrawn";
                      }
                      return null;
                    },
                    controller: controller.amount,
                    decoration: InputDecoration(
                      labelText: "Amount withdrawn",
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
                        showConfirmWithdrawal(context);
                      },
                      // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                      child: Text(
                        'Withdraw',
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
showConfirmWithdrawal(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final NumberFormat formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_us',
        decimalDigits: 2,
      );
      final controller = Get.put(WithdrawCashController());
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

              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Confirm bank withdrawal',
                  style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w500),
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
                        'Bank withdrawal',
                      ),
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Transaction code',
                      ), Text(
                        'BKWD-${controller.transactionCounter.value}',
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
                      Text("Withdrawn currency", style: TextStyle()),
                      Text(
                        controller.withdrawnCurrency.text.trim(),
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
                      controller.createWithdrawal(context);
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
