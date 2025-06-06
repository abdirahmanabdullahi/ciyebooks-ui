import 'package:ciyebooks/features/forex/controller/forex_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';

showAddNewCurrencyDialog(BuildContext context) {
  final controller = Get.put(ForexController());

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.all(8),
        backgroundColor: AppColors.quarternary,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: AppColors.quinary),
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
              DropdownMenu(width: double.maxFinite,
                controller: controller.currencyCode,
                trailingIcon: Icon(
                  Icons.search,
                  color: CupertinoColors.systemBlue,
                ),
                // expandedInsets: EdgeInsets.zero,
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
                menuStyle: MenuStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 0, vertical: 6)),
                  backgroundColor: WidgetStateProperty.all(AppColors.quinary), // Adjust height here,
                  maximumSize: WidgetStateProperty.all(Size(double.infinity, 200)), // Adjust height here
                ),
                label: Text('Select currency'),
                selectedTrailingIcon: Icon(Icons.search),
                onSelected: (value) {
                  if (value != null) {
                    controller.newCurrencyCode.text = value;
                    controller.updateNewCurrencyButton();
                  }
                },
                dropdownMenuEntries: controller.currencyList.entries.map((currency) {
                  return DropdownMenuEntry(
                    value: currency.key.toString(),
                    label: currency.key,
                    labelWidget: Row(
                      children: [
                        Expanded(
                          child: Text(
                            currency.value['code'],
                          ),
                        ),Expanded(flex:4,
                          child: Text(
                            currency.value['name'].toUpperCase(),
                          ),
                        ),
                      ],
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

              ),
              Gap(15),
              SizedBox(
                height: 38,
                width: double.maxFinite,
                child: Obx(()=>
                  FloatingActionButton(
                      disabledElevation: 0,
                      backgroundColor: controller.isButtonEnabled.value?AppColors.prettyBlue:AppColors.prettyGrey,
                      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10)),
                      onPressed: controller.isButtonEnabled.value?() => controller.addNewCurrency(context):null,
                      child: Text(
                        'Add currency',
                        style: TextStyle(color: AppColors.quinary, fontWeight: FontWeight.bold),
                      )),
                ),
              )
            ],
          ),
        ),
      );
    },
  ).then((_){
controller.clearController();  });
}
