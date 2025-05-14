import 'package:ciyebooks/features/setup/controller/setup_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

showCompleteSetupDialog({required BuildContext context, required String errorText, required String errorTitle}) {
  return showDialog(
    context: context,
    builder: (context) {
      final controller = Get.put(SetupController());
      return CupertinoAlertDialog(
        title: Text(
          errorTitle,
        ),
        content: Text(
          errorText,
          textAlign: TextAlign.center,
        ),
        actions: [
          CupertinoDialogAction(
            textStyle: TextStyle(color: CupertinoColors.systemBlue),

            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () async {
              await controller.checkInternetConnection(context).then(
                    (_) => Navigator.pop(context),
                  );
            },
            child: const Text('Confirm'),
          ),
          CupertinoDialogAction(
            textStyle: TextStyle(color: CupertinoColors.systemBlue),

            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Go back'),
          ),
        ],
      );
    },
  );
}
