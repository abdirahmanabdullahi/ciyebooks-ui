import 'package:ciyebooks/features/forex/controller/new_currency_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';

showAddNewCurrencyDialog(BuildContext context,NewCurrencyController controller) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(20),
        backgroundColor: AppColors.quinary,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: AppColors.secondary),
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
                    color: AppColors.quinary,
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
                    color: AppColors.quinary,
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
                  constraints: BoxConstraints.tight(const Size.fromHeight(38)),
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
                    // controller.currencyName.text = value[1];
                    // controller.currencyCode.text = value[0];
                    // controller.symbol.text = value[2];
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
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(side: BorderSide(color: AppColors.secondary, width: 1), borderRadius: BorderRadius.circular(10)),
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
