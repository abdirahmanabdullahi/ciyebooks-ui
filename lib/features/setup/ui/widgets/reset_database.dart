import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../utils/constants/colors.dart';

Future<dynamic> showResetDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      backgroundColor: AppColors.quarternary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      titlePadding: EdgeInsets.zero,
      title: Column(
        children: [
          Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: AppColors.quinary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: Colors.orange,
                  ),
                  Gap(10),
                  Text(
                    'Reset items',
                    style: TextStyle(
                      color: CupertinoColors.systemBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 30),
      content: DropdownMenu(
          expandedInsets: EdgeInsets.zero,

          // controller: controller.from,
          trailingIcon: Icon(
            Icons.keyboard_arrow_down_outlined,
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
          label: Text('Select items to reset'),
          selectedTrailingIcon: Icon(
            Icons.search,
            color: CupertinoColors.systemBlue,
          ),
          // width: double.maxFinite,
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
                value: 'accounts',
                label: 'accounts'),
          ]),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.only(bottom: 15),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: SizedBox(
            height: 45,
            width: double.maxFinite,
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: AppColors.quinary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Reset",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
