import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../../setup/controller/setup_controller.dart';

showAddTotals(context) {
  final controller = Get.put(SetupController());

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        backgroundColor: AppColors.quarternary,
        contentPadding: EdgeInsets.all(16),
        insetPadding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: AppColors.quinary),
          width: double.maxFinite,
          // height: 30,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Totals',
                        style: TextStyle(color: AppColors.prettyDark, fontWeight: FontWeight.w400),
                      ),
                    ),
                    IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: AppColors.prettyDark,
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
        content: Column(mainAxisSize: MainAxisSize.min,
          children: [
            DropdownMenu(
                controller: controller.type,
                trailingIcon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: CupertinoColors.systemBlue,
                ),
                expandedInsets: EdgeInsets.zero,
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
                label: Text('Type'),
                selectedTrailingIcon: Icon(Icons.search),
               onSelected: (value){},
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
                      value: 'BANK',
                      label: 'BANK'),
                  DropdownMenuEntry(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                          side: WidgetStateProperty.all(
                            BorderSide(width: 2, color: AppColors.quarternary),
                          ),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                          ))),
                      value: 'CASH',
                      label: 'CASH'),
                ]),            Gap(10),
            DropdownMenu(
                controller: controller.currency,
                trailingIcon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: CupertinoColors.systemBlue,
                ),
                expandedInsets: EdgeInsets.zero,
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
                label: Text('Received from'),
                selectedTrailingIcon: Icon(Icons.search),
               onSelected: (value){},
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
                      value: 'USD',
                      label: 'USD'),
                  DropdownMenuEntry(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(AppColors.quinary),
                          side: WidgetStateProperty.all(
                            BorderSide(width: 2, color: AppColors.quarternary),
                          ),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                          ))),
                      value: 'KES',
                      label: 'KES'),
                ]),            Gap(10),

            TextFormField(controller: controller.amount,
              decoration: InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  label: Text('Amount')),
            ),
            Gap(20),
            SizedBox(height: 45,
              width: double.maxFinite,child: FloatingActionButton(backgroundColor: AppColors.prettyBlue,elevation: 0,
                onPressed: (){controller.updateTotals(context);},child: Text('Add',style: TextStyle(color: AppColors.quinary),),),)
          ],
        ),
      );
    },
  ).then((_){
    controller.clearControllers();
  });
}
