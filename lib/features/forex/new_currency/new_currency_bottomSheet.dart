import 'package:ciyebooks/features/forex/controller/currency_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/validators/validation.dart';

void showAddNewCurrencyBottomSheet(BuildContext context) {
  final controller = Get.put(CurrencyController());
  showDialog(
    context: context,
    // isScrollControlled: true,
    // backgroundColor: Colors.white,
    // shape: const RoundedRectangleBorder( 
    //   borderRadius: BorderRadius.vertical(
    //     top: Radius.circular(20),
    //   ),
    // ),
    builder: (context) {
      return Dialog(backgroundColor: AppColors.quarternary,insetPadding: EdgeInsets.all(6),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              // key: controller.accountsFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Buy Currency",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Gap(10),
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("Common")
                        .doc('Currencies')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.data == null ||
                          snapshot.hasError) {
                        return const Center(
                          child: Text('Once added, currencies will appear here'),
                        );
                      }
        
                      // Extract the document data
                      final data = snapshot.data!.data();
                      if (data == null || data.isEmpty) {
                        return const Center(
                          child: Text('No currencies available'),
                        );
                      }
        
                      // Build the dropdown menu entries
                      List<DropdownMenuEntry<String>> dropdownMenuEntries =
                          data.entries.map(
                        (entry) {
                          final currencyCode = entry.key;
                          final currencyName = entry.value;
                          return DropdownMenuEntry<String>(
                            style: ButtonStyle(
                              textStyle: WidgetStateProperty.all<TextStyle?>(
                                TextStyle(
                                  fontSize: 15,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                AppColors.quinary,
                              ),
                              side: WidgetStateProperty.all<BorderSide>(
                                BorderSide(
                                  color: AppColors
                                      .quarternary, // Set the color of the border
                                  width: 1.0, // Set the thickness of the border
                                  style: BorderStyle
                                      .solid, // Border style (e.g., solid, dashed)
                                ),
                              ),
                            ),
                            value: '$currencyCode    ${currencyName['name']}',
                            label:
                                ' code:  $currencyCode,      ${currencyName['name']}',
                          );
                        },
                      ).toList();
        
                      // DropdownMenu implementation
                      return DropdownMenu(
                        expandedInsets: EdgeInsets.zero,
                        requestFocusOnTap: true,
                        label: const Text('Search currency'),
                        enableFilter: true,
                        enableSearch: true,
                        menuHeight: 150,
                        inputDecorationTheme: InputDecorationTheme(
                          contentPadding: const EdgeInsets.only(left: 10),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        menuStyle: MenuStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(AppColors.quarternary),
                        ),
        
                        dropdownMenuEntries: dropdownMenuEntries,
                        onSelected: (value) {
                          print('Selected: $value');
                        },
                        // width: double.infinity,
                      );
                    },
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        decoration: InputDecoration(
                          label: Text('Currency code'),
                          constraints:
                              BoxConstraints.tight(const Size.fromHeight(48)),
                        ),
                      )),
                      const Gap(10),
                      Expanded(
                        child: TextFormField(
                          // controller: controller.email,
                          validator: (value) =>
                              Validator.validateEmptyText('field', value),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Rate",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    ],
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      Expanded(
                          child: TextFormField(
                        decoration: InputDecoration(label: Text('Amount')),
                      )),
                      const Gap(10),
                      Expanded(
                        child: TextFormField(
                          // controller: controller.email,
                          validator: (value) =>
                              Validator.validateEmptyText('field', value),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Total",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.addAllCurrencies();
                        // controller.makeItNegative.value = false;
                        // controller.saveData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Gap(10),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
