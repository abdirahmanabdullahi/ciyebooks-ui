import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/screens/account_selector.dart';
import 'internal_transfer_amount_screen.dart';

class InternalTransferAccountSelector extends StatelessWidget {
  const InternalTransferAccountSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountSelector(
        accountTitle: "Internal transfer",
        onTilePressed: () => Get.to(() => InternalTransferAmountScreen()));
  }
}
