
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/screens/account_selector.dart';
import 'deposit_for_client_amount_screen.dart';

class ClientDepositAccountSelector extends StatelessWidget {
  const ClientDepositAccountSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AccountSelector(
          accountTitle: "Deposit for client",
          onTilePressed: () => Get.to(() => DepositForClientAmountScreen())),
    );
  }
}