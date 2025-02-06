import 'package:ciyebooks/features/receive/screens/receive_confirm_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/screens/amount_screen.dart';


class ReceiveAmountScreen extends StatelessWidget {
  const ReceiveAmountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AmountScreen(
      currencySelectorFieldLabel: "Select deposited currency",
      ownerCheckBoxLabel: "Deposited by owner",
      onPressed: () => Get.to(() => ReceiveConfirmScreen()),
      amountDepositedOrPaid: 'Amount received',
    );
  }
}
