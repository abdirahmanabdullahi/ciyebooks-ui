import 'package:ciyebooks/features/receive/receive_receipt_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/screens/confirm_screen.dart';

class ReceiveConfirmScreen extends StatelessWidget {
  const ReceiveConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ConfirmScreen(
      screenTitle: "Confirm cash deposit",
      previewBoxTitle: 'Cash deposit',
      currencySubtitle: 'Received currency',
      amountSubtitle: 'Received amount',
      accountLabel: 'Receiving account',
      receiverOrDepositor: 'Depositor',
      onPressed: () => Get.to(() => ReceiveReceiptScreen()),
    );
  }
}
