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
            ForeignCurrenciesPage(),FinanceDashboardScreen()
          ],
        ),
      ),
    );
  }
}

/// Confirmation Page
Widget _buildConfirmationPage() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "Review Your Setup",
        textAlign: TextAlign.center,
      ),
      const Gap(20),
      Text(
        "Please review all your entries. You can go back to make corrections if needed.",
        textAlign: TextAlign.center,
      ),
      const Gap(30),
      ElevatedButton(
        onPressed: () {
          // Submit setup logic here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.prettyDark,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          "Submit Setup",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}
