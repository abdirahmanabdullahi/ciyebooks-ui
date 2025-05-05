import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


showErrorDialog({required BuildContext context, required String errorText, required String errorTitle}) {
  return showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        // titlePadding: EdgeInsets.zero,
        // insetPadding: EdgeInsets.all(8),
        // backgroundColor: AppColors.quinary,
        // contentPadding: EdgeInsets.zero,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          errorTitle,
        ),
        content: Text(
          errorText,
          textAlign: TextAlign.center,
        ),actions: [CupertinoDialogAction(textStyle: TextStyle(color: CupertinoColors.systemBlue),
        /// This parameter indicates this action is the default,
        /// and turns the action's text to bold text.
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('OK'),
      ),],
      );
    },
  );
}
