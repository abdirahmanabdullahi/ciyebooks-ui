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
import '../../../common/widgets/acount_preview_tile.dart';
import '../pay_client_controller/pay_client_controller.dart';

class Testing extends StatelessWidget {
  const Testing({super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    final buttonValues = ['9', '8', '7', '6', '5', '4', '3', '2', '1', '.', '0', 'del'];
    final controller = Get.put(PayClientController());
    var currencies = {};

    return Scaffold(
      backgroundColor: AppColors.quinary,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
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
                          onSelected: (value) {
                            if (value != null) {

                              final currencyMap = value[1] as Map<String, dynamic>;

                              controller.currency.value = currencyMap.entries.map((entry) => [entry.key, entry.value]).toList();
                              print(controller.currency);
                            }
                          },
                          dropdownMenuEntries: controller.accounts.map((account) {
                            return DropdownMenuEntry(
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
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: account.currencies.entries.map((entry) {
                                                    return RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: entry.key,
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 13,
                                                              color: Colors.blue,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '   ${formatter.format(entry.value)}',
                                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11, color: entry.value <= 0 ? Colors.red : Colors.grey.shade600
                                                                // Black Value
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
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
                                value: [account.accountNo, account.currencies],
                                label: account.fullName);
                          }).toList(),
                        ),
                      ),
                    ),
                    Gap(15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Obx(
                        () => DropdownMenu(
                          trailingIcon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: CupertinoColors.systemBlue,
                            size: 30,
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
                            backgroundColor: WidgetStateProperty.all(AppColors.quinary), // Adjust height here,
                            maximumSize: WidgetStateProperty.all(Size(double.infinity, 500)), // Adjust height here
                          ),
                          label: Text('Select currency'),
                          selectedTrailingIcon: Icon(Icons.search),
                          width: double.maxFinite,
                          onSelected: (value) {
                            if (value != null) {


                            }
                          },
                          dropdownMenuEntries:  controller.currency.map((currency) {
                            // Ensure valid data structure

                            // Convert first item to a proper currency string
                            String currencyName = currency[0].toString().toUpperCase(); // Ensure consistency
                            num balance = num.tryParse(currency[1].toString()) ?? 0;
                            return DropdownMenuEntry(value: currencyName, label: '$currencyName  $balance');

                          }).toList(),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    //   child: Obx(
                    //         () => DropdownButtonFormField(
                    //       iconEnabledColor: CupertinoColors.systemBlue,
                    //       menuMaxHeight: 200, // Increased for better visibility
                    //       decoration: InputDecoration(
                    //         contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    //         constraints: BoxConstraints.tight(const Size.fromHeight(50)),
                    //         fillColor: AppColors.quinary,
                    //         filled: true,
                    //         labelText: 'Select currency',
                    //         border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(10),
                    //           borderSide: BorderSide(width: 1, color: AppColors.grey),
                    //         ),
                    //       ),
                    //       icon: const Icon(Icons.keyboard_arrow_down),
                    //       items: controller.currency.map((currency) {
                    //         // Ensure valid data structure
                    //
                    //         // Convert first item to a proper currency string
                    //         String currencyName = currency[0].toString().toUpperCase(); // Ensure consistency
                    //         num balance = num.tryParse(currency[1].toString()) ?? 0;
                    //
                    //         return DropdownMenuItem<String>(
                    //           value: currencyName,
                    //           child: Row(
                    //             children: [
                    //               Text(
                    //                 currencyName,
                    //                 style: TextStyle(
                    //                   fontWeight: FontWeight.w600,
                    //                   fontSize: 13,
                    //                   color: Colors.blue,
                    //                 ),
                    //               ),
                    //               const SizedBox(width: 10),
                    //               Text(
                    //                 balance.toStringAsFixed(2), // Format balance
                    //                 style: TextStyle(
                    //                   fontWeight: FontWeight.w500,
                    //                   fontSize: 11,
                    //                   color: balance <= 0 ? Colors.red : Colors.grey.shade600,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         );
                    //       }).toList(), // Ensure null items are removed
                    //       onChanged: (value) {
                    //         print('Selected value: $value');
                    //       },
                    //     ),
                    //   ),
                    // ),

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
                              showConfirmDialog(context);
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

void showConfirmDialog(BuildContext context) {
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
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.systemBlue),
          width: double.maxFinite,
          height: 70,
          child: Center(
              child: Text(
            'Confirm payment',
            style: TextStyle(color: AppColors.quinary, fontSize: 24),
          )),
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
                      Text(accountName, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                      Text(accountNumber, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                      Text("$currency ${amount.toStringAsFixed(2)}", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                      Text(paymentMethod, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                      Text(dateTime, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Gap(5),
                  Gap(5),
                ],
              ),
            ),
            Divider(
              height: 0,
            ),
            Gap(15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextFormField(
                maxLines: 2,
                decoration: InputDecoration(
                  labelStyle: TextStyle(),
                  label: Text(
                    'Add description',
                  ),
                ),
              ),
            ),
            Gap(20)
          ],
        ),
        actions: [
          SizedBox(
            width: 90,
            height: 40,
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: CupertinoColors.systemBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onPressed: () {
                Navigator.pop(context);
                showReceiptDialog(context);
              },
              child: Text('Submit', style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: SizedBox(
              width: 90,
              height: 40,
              child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ),
        ],
      );
    },
  );
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
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.systemBlue),
          width: double.maxFinite,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.task_alt_outlined,
                size: 40,
                color: AppColors.quinary,
              ),
              Gap(20),
              Text(
                'Payment created',
                style: TextStyle(color: AppColors.quinary, fontSize: 24),
              ),
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
                      Text(accountName, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    children: [
                      Expanded(
                        child: Text("Transaction id", style: TextStyle()),
                      ),
                      Text(accountName, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    children: [
                      Expanded(
                        child: Text("From", style: TextStyle()),
                      ),
                      Text(accountName, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                      Text(accountNumber, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                      Text("$currency ${amount.toStringAsFixed(2)}", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                      Text(paymentMethod, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
                      Text(dateTime, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
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
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                      height: 50, image: NetworkImage('https://media.istockphoto.com/id/828088276/vector/qr-code-illustration.jpg?s=612x612&w=0&k=20&c=FnA7agr57XpFi081ZT5sEmxhLytMBlK4vzdQxt8A70M=')),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                color: CupertinoColors.systemBlue,
                                Icons.download_for_offline_outlined,
                                size: 30,
                              )),
                          Text(
                            'Download',
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                      Gap(30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                color: CupertinoColors.systemBlue,
                                Icons.share,
                                size: 30,
                              )),
                          Text(
                            'Share',
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
