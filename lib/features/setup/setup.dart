import 'package:ciyebooks/features/setup/controller/setup_controller.dart';
import 'package:ciyebooks/features/setup/widgets/cash_in_hand_page.dart';
import 'package:ciyebooks/features/setup/widgets/expense_page.dart';
import 'package:ciyebooks/features/setup/widgets/foreign_currencies_page.dart';
import 'package:ciyebooks/features/setup/widgets/page_one.dart';
import 'package:ciyebooks/features/setup/widgets/payables_page.dart';
import 'package:ciyebooks/features/setup/widgets/receivables_page.dart';
import 'package:ciyebooks/features/setup/widgets/starting_capital_page.dart';
import 'package:ciyebooks/features/setup/widgets/summary.dart';
import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Setup extends StatelessWidget {
  const Setup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quarternary,
      appBar: AppBar(
        backgroundColor: AppColors.quinary,
        title: const Text("Account Setup"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: PageView(
          children: [
            PageOne(),
            StartingCapitalPage(),
            CashInHandPage(),
            ReceivablesPage(),
            PayablesPage(),
            ExpensesPage(),
            ForeignCurrenciesPage(),
            Summary()
          ],
        ),
      ),
    );
  }
}
