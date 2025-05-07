import 'package:ciyebooks/features/forex/controller/forex_controller.dart';
import 'package:ciyebooks/features/forex/controller/new_currency_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

showAddNewCurrencyDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      final controller = Get.put(ForexController());
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(20),
        backgroundColor: AppColors.quarternary,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: AppColors.quinary),
          width: double.maxFinite,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Adding new currency',
                  style: TextStyle(
                    color: AppColors.prettyBlue,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColors.prettyDark,
                  ))
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownMenu(
                trailingIcon: Icon(
                  Icons.search,
                  color: CupertinoColors.systemBlue,
                  // size: 30,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: AppColors.quinary,
                  isDense: false,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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
                  maximumSize: WidgetStateProperty.all(Size(double.infinity, 200)), // Adjust height here
                ),
                label: Text('Select currency'),
                selectedTrailingIcon: Icon(Icons.search),
                width: double.maxFinite,
                onSelected: (value) {
                  if (value != null) {
                    controller.newCurrencyCode.text = value;
                  }
                },
                dropdownMenuEntries: controller.currencyList.entries.map((currency) {
                  return DropdownMenuEntry(
                    value: currency.key,
                    label: currency.value.toString().replaceAll(RegExp(r'[{}()]'), ''),
                    labelWidget: Text(
                      currency.value.toString().replaceAll(RegExp(r'[{}()]'), ''),
                    ),
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                        side: WidgetStateProperty.all(
                          BorderSide(width: 2, color: AppColors.quarternary),
                        ),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                        ))),
                  );
                }).toList(),
                // controller.currencyList.entries.map((currency) {
                //   return DropdownMenuEntry(
                //       labelWidget: Text('${currency.value['name']}, CODE: ${currency.value['code']}, SYMBOL: ${currency.value['symbol']}'),
                //       style: ButtonStyle(
                //           backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                //           side: WidgetStateProperty.all(
                //             BorderSide(width: 2, color: AppColors.quarternary),
                //           ),
                //           shape: WidgetStateProperty.all(RoundedRectangleBorder(
                //             borderRadius: BorderRadius.all(Radius.circular(0)),
                //           ))),
                //       value: [currency.value['code'], currency.value['name'], currency.value['symbol']],
                //       label: '${currency.value['name']} CODE: ${currency.value['code']} SYMBOL: ${currency.value['symbol']}');
                // }).toList()
              ),
              Gap(15),
              SizedBox(
                height: 38,
                width: double.maxFinite,
                child: FloatingActionButton(
                    elevation: 0,
                    backgroundColor: AppColors.prettyBlue,
                    shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.prettyBlue, width: 1), borderRadius: BorderRadius.circular(10)),
                    onPressed: () => controller.addNewCurrency(context),
                    child: Text(
                      'Add currency',
                      style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.bold),
                    )),
              )
            ],
          ),
        ),
      );
    },
  );
}
