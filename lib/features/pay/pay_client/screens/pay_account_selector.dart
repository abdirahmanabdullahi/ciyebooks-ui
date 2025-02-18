import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Obx(
                      () => DropdownMenu(
                        inputDecorationTheme: InputDecorationTheme(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            constraints: BoxConstraints.tight(const Size.fromHeight(50)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                        requestFocusOnTap: true,
                        enableFilter: true,
                        menuStyle: MenuStyle(
                          backgroundColor: WidgetStateProperty.all(AppColors.quinary), // Adjust height here,
                          maximumSize: WidgetStateProperty.all(Size(double.infinity, 300)), // Adjust height here
                        ),
                        label: Text('Search account'),
                        selectedTrailingIcon: Icon(Icons.search),
                        trailingIcon: Icon(
                          Icons.search,
                          color: CupertinoColors.systemBlue,
                        ),
                        width: double.maxFinite,
                        onSelected: (value) {},
                        dropdownMenuEntries: controller.accounts.map((account) {
                          return DropdownMenuEntry(value: account.accountNo, label: account.fullName);
                        }).toList(),
                      ),
                    ),
                    // Container(
                    //     decoration: BoxDecoration(color: AppColors.quinary, border: Border.all(width: 1, color: AppColors.grey), borderRadius: BorderRadius.circular(15)),
                    //     child: const AccountPreviewTile()),
                    // const SizedBox(height: 15),

                    // Currency Dropdown
                    SizedBox(height: 15),
                    DropdownButtonFormField(
                      menuMaxHeight: 100,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        iconColor: Colors.red,
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
                      items: const [
                        DropdownMenuItem(value: "USD", child: Text("US Dollar")),
                        DropdownMenuItem(value: "KES", child: Text("Kenyan Shilling")),
                      ],
                      onChanged: (value) {},
                    ),

                    SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:120.0),
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
                    TextFormField(
                      canRequestFocus: false,
                      cursorColor: CupertinoColors.activeGreen,
                      cursorWidth: 2,
                      cursorHeight: 35,
                      textAlign: TextAlign.center,
                      // controller: controller.amount,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.activeGreen,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                      ],
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        label: Center(
                          child: Text(
                            '0.0',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.activeGreen,
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
                  ],
                ),
              ), // Divider

              const SizedBox(height: 0),

              // Custom Keyboard
              Card(
                elevation: 0,
                color: AppColors.quarternary,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 12,
                        children: buttonValues.map((value) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                            height: 65,
                            child: FloatingActionButton(
                              elevation: .1,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: .2, color: AppColors.prettyDark),
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
                                // value == 'del' ? controller.removeCharacter() : controller.addCharacter(value);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Gap(10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:30.0),
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
                      padding: const EdgeInsets.fromLTRB(16.0,32.0,16.0,25.0),
                      child: SizedBox(
                        width: double.infinity,
                        // height:/,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            disabledBackgroundColor: Colors.red,
                            backgroundColor: CupertinoColors.systemBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: () {},
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
              // const SizedBox(height: 10),
              // Continue Button
            ],
          ),
        ),
      ),
    );
  }
}
