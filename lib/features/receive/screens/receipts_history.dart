import 'package:ciyebooks/navigation_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/styles/custom_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../common/widgets/calculator.dart';
import '../controller/receive_from_client_controller.dart';

class ReceiptsHistory extends StatelessWidget {
  const ReceiptsHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2,
    );
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('transactions')
        .where('transactionType', isEqualTo: 'receipt')
        .snapshots();

    return  Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>showReceiptForm(context),
        backgroundColor: AppColors.prettyDark,
        shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.prettyDark, width: 2), borderRadius: BorderRadius.circular(100)),
        child: Icon(
          Icons.add,
          color: AppColors.quinary,
          // size: 35,
        ),
      ),        appBar: AppBar(backgroundColor: AppColors.quinary,
        title: Text('Receipt history'),actions: [IconButton(onPressed: ()=>Get.offAll(()=>NavigationMenu()), icon: Icon(Icons.close))],
    ),
      backgroundColor: AppColors.quarternary,
      body: StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (!snapshot.hasData) {
            return const Text('No data available');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.fromLTRB(3.0,3,3,0),
                child: CustomContainer(
                  border: Border.all(color: AppColors.grey, width: .5),
                  darkColor: AppColors.quinary,
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // First Row (From, Receiver, Amount)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Received from: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    TextSpan(
                                      text: data['depositorName'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.blue,
                                        // Black Value
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(3),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Receiving account: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                        color: Colors.grey[600], // Grey Label
                                      ),
                                    ),
                                    TextSpan(
                                      text: data['receivingAccountName'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.blue,
                                        // Grey Label
                                        // Black Value
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${data['currency']}: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    // fontSize: 12,
                                    fontSize: 10,
                                    color: Colors.grey[600], // Grey Label
                                  ),
                                ),
                                TextSpan(
                                  text: formatter
                                      .format(data['amount'])
                                  // text: payment.amountPaid
                                      .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: Colors.redAccent, // Grey Label
                                    // Black Value
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Divider(color: Colors.grey[400], thickness: 1),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Type: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        color: Colors.grey[600], // Grey Label
                                      ),
                                    ),
                                    TextSpan(
                                      text: data['transactionType'],
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10, color: Colors.blue // Grey Label
                                        // Black Value
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(10),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '# ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        color: Colors.grey[600], // Grey Label
                                      ),
                                    ),
                                    TextSpan(
                                      text: data['transactionId'],
                                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10, color: Colors.blue // Grey Label
                                        // Black Value
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: DateFormat("dd MMM yyyy HH:mm").format(data['dateCreated'].toDate()),
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10, color: Colors.blue // Grey Label
                                    // Black Value
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            })
                .toList()
                .cast(),
          );
        },
      ),
    );
  }
}

showReceiptForm(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final controller = Get.put(ReceiveFromClientController());
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
                      'Receiving a deposit',
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
            content: SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Gap(10),
                    Obx(
                      () => DropdownMenu(
                        controller: controller.receivingAccountName,
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
                        label: Text('Select receiving account'),
                        selectedTrailingIcon: Icon(Icons.search),
                        width: double.maxFinite,
                        onSelected: (value) {
                          if (value != null) {
                            controller.receivingAccountNo.text = value[0].toString();
                            controller.receivingAccountName.text = value[2].toString();

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
                    Gap(10),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => DropdownMenu(
                              controller: controller.receivedCurrency,
                              trailingIcon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: CupertinoColors.systemBlue,
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
                              label: Text('Currency'),
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
                        ),Gap(10),
                        Expanded(
                          child: DropdownMenu(
                              controller: controller.receiptType,
                              trailingIcon: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: CupertinoColors.systemBlue,
                              ),
                              inputDecorationTheme: InputDecorationTheme(
                                fillColor: AppColors.quinary,
                                filled: true,
                                isDense: true,
                                // contentPadding: const EdgeInsets.symmetric(horizontal: 0),
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
                              label: Text('Deposit type'),
                              selectedTrailingIcon: Icon(Icons.search),
                              width: double.maxFinite,
                              onSelected: (value) {},
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
                        )
                      ],
                    ),
                    Gap(10),
                    SizedBox(
                      height: 45,
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Amount";
                          }
                          return null;
                        },
                        controller: controller.amount,
                        decoration: InputDecoration(
                          labelText: "Amount",
                          // constraints: BoxConstraints.tight(
                          // const Size.fromHeight(50),
                          // ),
                        ),
                      ),
                    ),
                    Gap(10),
                    Obx(
                      () => Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Checkbox(value: controller.receivedFromOwner.value, onChanged: (value) => controller.receivedFromOwner.value = !controller.receivedFromOwner.value),
                          ),
                          Gap(10),
                          controller.receivedFromOwner.value ? Text('Received from owner') : Text('Received from other')
                        ],
                      ),
                    ),
                    Gap(10),
                    Obx(
                      () => controller.receivedFromOwner.value
                          ? SizedBox()
                          : Form(
                              key: controller.payClientFormKey,
                              child: SizedBox(height: 45,
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
                            showConfirmReceipt(context);
                          },
                          // onPressed: controller.isLoading.value ? null : () => controller.createPayment(context),
                          child: Text(
                            'Receive',
                            style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.w900),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

showConfirmReceipt(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final NumberFormat formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_us',
        decimalDigits: 2,
      );
      final controller = Get.put(ReceiveFromClientController());
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(0),
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
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Confirm receipt',
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
                        'Receipt',
                      ),
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Transaction code", style: TextStyle()),
                      Text('RCPT-${controller.transactionCounter.value}'),
                    ],
                  ),

                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Received from", style: TextStyle()),
                      Text(controller.receivedFromOwner.value ? controller.receivingAccountName.text : controller.depositorName.text.trim()),
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Receiving account',
                      ),
                      Text(controller.receivingAccountName.text.trim())
                    ],
                  ),
                  Gap(5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Received currency", style: TextStyle()),
                      Text(controller.receivedCurrency.text.trim()),
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
                      controller.createReceipt(context);
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
