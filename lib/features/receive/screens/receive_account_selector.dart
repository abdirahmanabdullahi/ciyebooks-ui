import 'package:ciyebooks/features/receive/screens/receive_amount_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/screens/account_selector_screen.dart';


class ReceiveAccountSelector extends StatelessWidget {
  const ReceiveAccountSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountSelectorScreen(
        accountTitle: "Select receiving account",
        onTilePressed: () => Get.to(() => ReceiveAmountScreen()));
  }
}
