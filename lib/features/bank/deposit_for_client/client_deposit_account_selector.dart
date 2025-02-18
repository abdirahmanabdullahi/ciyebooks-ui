
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/screens/account_selector_screen.dart';
import 'deposit_for_client_amount_screen.dart';

class ClientDepositAccountSelector extends StatelessWidget {
  const ClientDepositAccountSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AccountSelectorScreen(
          accountTitle: "Deposit for client",
          onTilePressed: () => Get.to(() => DepositForClientAmountScreen())),
    );
  }
}
