
import 'package:ciyebooks/features/pay/pay_client/screens/pay_receipt_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/screens/confirm_screen.dart';

class PayConfirmScreen extends StatelessWidget {
  const PayConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConfirmScreen(
          screenTitle: "Confirm cash payment",
          previewBoxTitle: "Cash payment",
          currencySubtitle: "Payout currency",
          amountSubtitle: "Paid amount",
          accountLabel: "Paying account",
          receiverOrDepositor: "Receiver",
          onPressed: () => Get.to(() => PayReceiptScreen())),
    );
  }
}
