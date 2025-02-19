import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../../common/styles/custom_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../common/widgets/acount_preview_tile.dart';
import '../pay_client_controller/pay_client_controller.dart';

class Testing extends StatelessWidget {
  const Testing({super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.decimalPatternDigits();
    final buttonValues = ['9', '8', '7', '6', '5', '4', '3', '2', '1', '.', '0', 'del'];
    final controller = Get.put(PayClientController());

    return Scaffold(
      backgroundColor: AppColors.quinary,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          //   shape: RoundedRectangleBorder(
          //   borderRadius:  BorderRadius.only(
          // topLeft: Radius.circular(20),    // Adjust as needed
          //   // Adjust as needed
          //   bottomLeft: Radius.circular(-30), // Adjust as needed
          //   bottomRight: Radius.circular(-15), // Adjust as needed
          // ),
          // ),
          // leading: Icon(Icons.arrow_back),
          title: Text(
            'Paying a client',
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
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Obx(
                        () => DropdownMenu(
                          trailingIcon: Icon(
                            Icons.search,
                            color: CupertinoColors.systemBlue,
                            size: 25,
                          ),
                          inputDecorationTheme: InputDecorationTheme(
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
                            backgroundColor: WidgetStateProperty.all(AppColors.quarternary), // Adjust height here,
                            maximumSize: WidgetStateProperty.all(Size(double.infinity, 500)), // Adjust height here
                          ),
                          label: Text('Search account'),
                          selectedTrailingIcon: Icon(Icons.search),
                          width: double.maxFinite,
                          onSelected: (value) {},
                          dropdownMenuEntries: controller.accounts.map((account) {
                            print(account.usdBalance);
                            // controller.currencyList.value = Map<String, dynamic>.from(account.currencies);
                            // print(controller.currencyList.values);
                            return DropdownMenuEntry(

                                ///THis is where I wanna change the width. Its width is wider than the menu
                                labelWidget: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: CustomContainer(
                                        darkColor: AppColors.quinary,
                                        width: double.maxFinite,
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: 'Name: ',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 10,
                                                              color: Colors.grey[600],
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '${account.firstName}${account.lastName}',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 13,
                                                              color: Colors.blue,
                                                              // Black Value
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.end, children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'USD: ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10,
                                                            color: Colors.grey[600], // Grey Label
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: '${account.usdBalance}'.toString(),
                                                          style: TextStyle(
                                                            color: account.usdBalance <= 0 ? CupertinoColors.destructiveRed : CupertinoColors.systemBlue,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 12,
                                                            // color: account.usdBalance < 0 ? Colors.redAccent : Colors.blue, // Grey Label
                                                            // Black Value
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'KES: ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 10,
                                                            color: Colors.grey[600], // Grey Label
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: '${account.kesBalance}'.toString(),
                                                          style: TextStyle(
                                                            color: account.kesBalance <= 0 ? CupertinoColors.destructiveRed : CupertinoColors.systemBlue,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 12,
                                                            // color: account.usdBalance < 0 ? Colors.redAccent : Colors.blue, // Grey Label
                                                            // Black Value
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                              ],
                                            ),
                                            Divider(color: Colors.grey[400], thickness: 1),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: 'REF: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 10,
                                                          color: Colors.grey[600], // Grey Label
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: account.accountNo,
                                                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10, color: Colors.blue // Grey Label
                                                            // Black Value
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ))),
                                value: account.accountNo,
                                label: account.fullName);
                          }).toList(),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButtonFormField(
                        iconEnabledColor: CupertinoColors.systemBlue,
                        menuMaxHeight: 100,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                          // iconColor: Colors.red,
                          constraints: BoxConstraints.tight(const Size.fromHeight(50)),
                          fillColor: AppColors.quinary,
                          filled: true,
                          labelText: 'Select currency',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(width: 1, color: AppColors.grey),
                          ),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: [
                          DropdownMenuItem(
                            value: 'USD',
                            child: Text('USD'),
                          ),
                          DropdownMenuItem(
                            value: 'KES',
                            child: Text('KES'),
                          ),
                        ],
                        onChanged: (value) {
                          print(value);
                        },
                      ),
                    ),

                    SizedBox(height: 15),
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
                            controller.paidToOwner.value ? Text('Paid to owner') : Text('Paid to a proxy')
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Obx(
                        () => controller.paidToOwner.value
                            ? SizedBox()
                            : TextFormField(decoration: InputDecoration(labelText: "Receiver's name", constraints: BoxConstraints.tight(const Size.fromHeight(50)))),
                      ),
                    ),
                    SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                        cursorHeight: 35,
                        textAlign: TextAlign.center,
                        controller: controller.amount,
                        style: const TextStyle(
                          letterSpacing: 2,
                          // fontFamily: 'Oswald',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.systemBlue,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                        ],
                        decoration: InputDecoration(
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
                  ],
                ),
              ), // Divider

              // Custom Keyboard
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Card(
                  elevation: 0,
                  color: AppColors.quarternary,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
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
                                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black87),
                                      ),
                                onPressed: () {
                                  value == 'del' ? controller.removeCharacter() : controller.addCharacter(value);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Gap(10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Container(
                          width: double.infinity,
                          height: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 22.0, 16.0, 15.0),
                        child: SizedBox(
                          width: double.infinity,
                          // height:/,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              disabledBackgroundColor: Colors.red,
                              backgroundColor: CupertinoColors.systemBlue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            onPressed: () {
                              showReceiptDialog(context);
                            },
                            child: const Text(
                              'Continue',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // const SizedBox(height: 10),
              // Continue Button
            ],
          ),
        ),
      ),
    );
  }
}

void showReceiptDialog(BuildContext context) {
  // Dummy data
  String accountName = "John Doe";
  String accountNumber = "1234567890";
  double amount = 2500.75;
  String currency = "KES";
  String reference = "INV-20250219";
  String paymentMethod = "Mobile Money";
  String dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(8),
        backgroundColor: AppColors.quinary,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
            color: CupertinoColors.systemBlue
          ),
          width: double.maxFinite,
          height: 70,
          child: Center(child: Text('Confirm payment',style: TextStyle(color: AppColors.quinary,fontSize: 24),)),
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
                        child: Text("From", style: TextStyle()),
                      ),
                      Text(accountName, style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),  Gap(5),
                  Row(
                    children: [

                      Expanded(
                        child: Text("Receiver", style: TextStyle()),
                      ),
                      Text(accountNumber, style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w600)),
                    ],
                  ),  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),  Gap(5),
                  Row(
                    children: [

                      Expanded(
                        child: Text("Currency", style: TextStyle()),
                      ),
                      Text("$currency ${amount.toStringAsFixed(2)}", style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w600)),
                    ],
                  ),  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),  Gap(5),
                  Row(
                    children: [

                      Expanded(
                        child: Text("Amount", style: TextStyle()),
                      ),
                      Text(paymentMethod, style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w600)),
                    ],
                  ),  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),  Gap(5),

                  Row(
                    children: [

                      Expanded(
                        child: Text("Date & Time", style: TextStyle(fontWeight: FontWeight.normal)),
                      ),
                      Text(dateTime, style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w600)),
                    ],
                  ),Gap(5),
                  Gap(5),
                ],
              ),
            ),
            Divider(height: 0,),
            Gap(15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(maxLines: 2,
                decoration: InputDecoration(labelStyle: TextStyle(),
                  label: Text('Add description'
                    ,),),),
            ),Gap(20)
          ],
        ),
        actions: [
          SizedBox(width: 90,height: 40,
            child: FloatingActionButton(elevation: 0,
              backgroundColor: CupertinoColors.systemBlue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onPressed: () => Navigator.pop(context),
              child: Text('Submit', style: TextStyle(color: AppColors.quinary,fontWeight: FontWeight.bold,fontSize: 15)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: SizedBox(width: 90,height: 40,
              child: FloatingActionButton(elevation: 0,
                backgroundColor: CupertinoColors.destructiveRed,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: AppColors.quinary,fontWeight: FontWeight.bold,fontSize: 15)),
              ),
            ),
          ),

        ],
      );
    },
  );
}
