import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../features/pay/pay_client/pay_client_controller/pay_client_controller.dart';
import '../../utils/constants/colors.dart';

showErrorDialog(BuildContext context,String errorText) {
  return showDialog(
    context: context,
    builder: (context) {
      final NumberFormat formatter = NumberFormat.decimalPatternDigits(
        locale: 'en_us',
        decimalDigits: 2,
      );
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        // insetPadding: EdgeInsets.all(8),
        backgroundColor: AppColors.quinary,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)), color: CupertinoColors.destructiveRed),
          width: double.maxFinite,
          // height: 30,
          child: Row(mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Error!',
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
        content: Column(mainAxisSize: MainAxisSize.min,mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(errorText,textAlign: TextAlign.center,),
            ),
            Gap(30),Divider(height: 0,),TextButton(onPressed: ()=>Navigator.of(context).pop(), child: Text('Ok'))
          ],
        ),
      );
    },
  );
}
