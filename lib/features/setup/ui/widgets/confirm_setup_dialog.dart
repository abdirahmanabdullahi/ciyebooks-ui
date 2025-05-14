import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../utils/constants/colors.dart';
import '../../controller/setup_controller.dart';

Future<dynamic> showConfirmSetupDialog(BuildContext context, SetupController controller) {
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
                    'Are you sure?',
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
      content: Text(
        'Have you confirmed your totals and other uploaded data? If not, please do so. No hurry!.If done, please proceed to submit the data.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.only(bottom: 15),
      actions: [
        SizedBox(
          height: 40,
          width: 100,
          child: FloatingActionButton(
            backgroundColor: AppColors.quinary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              controller.completeSetup();
              Navigator.pop(context);
            },
            child: Text(
              "Submit data",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.blue,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: SizedBox(
            height: 40,
            width: 100,
            child: FloatingActionButton(
              backgroundColor: AppColors.quinary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
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
