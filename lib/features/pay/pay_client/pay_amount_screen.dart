
import 'package:ciyebooks/features/pay/pay_client/pay_confirm_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/screens/amount_screen.dart';

class PayAmountScreen extends StatelessWidget {
  const PayAmountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AmountScreen(
        currencySelectorFieldLabel: " Select payout currency",
        ownerCheckBoxLabel: "Paid to owner",
        onPressed: () => Get.to(() => PayConfirmScreen()),
        amountDepositedOrPaid: 'Amount paid',
      ),
    );
  }
}
