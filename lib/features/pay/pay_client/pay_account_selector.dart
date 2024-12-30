
import 'package:ciyebooks/features/pay/pay_client/pay_amount_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/screens/account_selector.dart';

class PayAccountSelector extends StatelessWidget {
  const PayAccountSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AccountSelector(
          accountTitle: "Select paying account",
          onTilePressed: () => Get.to(() => PayAmountScreen())),
    );
  }
}
