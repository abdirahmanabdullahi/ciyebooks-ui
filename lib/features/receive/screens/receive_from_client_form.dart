import 'package:ciyebooks/common/widgets/dropdown_menu_formfield.dart';
import 'package:ciyebooks/features/receive/controller/receive_from_client_cpntroller.dart';
import 'package:ciyebooks/features/receive/screens/receipts_history.dart';
import 'package:ciyebooks/navigation_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../common/styles/custom_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../pay/pay_client/pay_client_controller/pay_client_controller.dart';

class ReceiveFromClientForm extends StatelessWidget {
  const ReceiveFromClientForm({super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    final buttonValues = ['9', '8', '7', '6', '5', '4', '3', '2', '1', '.', '0', 'del'];
    final controller = Get.put(ReceiveFromClientController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: CupertinoColors.systemBlue,
        shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.quarternary, width: 2), borderRadius: BorderRadius.circular(20)),
        onPressed: () => Get.offAll(() => ReceiptsHistory()),
        child: Icon(Icons.manage_search_rounded,
          // Icons.add_circle_outline,
          color: AppColors.quinary,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      backgroundColor: AppColors.quarternary,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          automaticallyImplyLeading: true,leading: IconButton(onPressed: ()=>Get.offAll(NavigationMenu()), icon: Icon(Icons.close)),
          title: Text(
            'Receive funds from client',
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
                child: Obx(
                      () => DropdownMenu(
                    controller: controller.receivingAccountNo,
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
                    label: Text('Select receiving account'),
                    selectedTrailingIcon: Icon(Icons.search),
                    width: double.maxFinite,
                    onSelected: (value) {
                      if (value != null) {
                        controller.receivingAccountNo.text = value[0].toString();

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
              ),
              Gap(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Obx(
                      () => DropdownMenu(
                    controller: controller.receivedCurrency,
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
                        controller.receivedCurrency.text = value;
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

              SizedBox(height: 20),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Obx(
                      () => Row(
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Checkbox(value: controller.paidToOwner.value, onChanged: (value) => controller.paidToOwner.value = !controller.paidToOwner.value),
                      ),
                      Gap(10),
                      controller.paidToOwner.value ? Text('Received from owner') : Text('Received from other')
                    ],
                  ),
                ),
              ),
              Gap(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Obx(
                      () => controller.paidToOwner.value
                      ? SizedBox()
                      : Form(
                    key: controller.payClientFormKey,
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
              SizedBox(height: 15),

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
                child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
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
                                          'Confirm payment',
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
                                                  Text('Payment', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                                                ],
                                              ),
                                              Gap(5),
                                              Divider(thickness: 1, color: Colors.grey[300]),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text("From", style: TextStyle()),
                                                  ),
                                                  Text(controller.depositorName.text, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                                                ],
                                              ),
                                              Gap(5),
                                              Divider(thickness: 1, color: Colors.grey[300]),
                                              Gap(5),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text("Receiver", style: TextStyle()),
                                                  ),
                                                  Text(controller.paidToOwner.value ? 'Account holder' : controller.receivingAccountName.text,
                                                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                                                  Text(controller.receivedCurrency.text, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
