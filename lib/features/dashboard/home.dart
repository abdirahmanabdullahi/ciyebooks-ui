
import 'package:ciyebooks/features/dashboard/widgets/balances_tile.dart';
import 'package:ciyebooks/features/dashboard/widgets/button_list.dart';
import 'package:ciyebooks/features/dashboard/widgets/period_selector.dart';
import 'package:ciyebooks/features/dashboard/widgets/stats_box.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../common/styles/custom_container.dart';
import '../../utils/constants/colors.dart';
import '../profile/profile.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.quinary,
        automaticallyImplyLeading: true,
        title: Text("Dashboard"),
        centerTitle: true,
        leading:  Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child:SizedBox(
            child: IconButton(
              // backgroundColor: AppColors.quarternary.withOpacity(.9),
              // shape:  CircleBorder(
              //   side: BorderSide(width: 1, color: AppColors.quarternary.withOpacity(.2)),
              // ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Correct context for drawer
              },
              icon: Icon(
                Icons.sort,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => Profile()),
            icon: Icon(
              Icons.person_outline,
              color: AppColors.prettyDark,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        // primary: true,

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
              child: CustomContainer(
                  darkColor: AppColors.quinary,
                  height: 100,
                  width: double.infinity,
                  padding: const EdgeInsets.all(6),
                  child: ButtonList()),
            ),
            // Cash balances
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your wallet",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const BalanceTile(
                    leading: "USD",
                    title: '4,235,567',
                    subtitle: 'USD cash in hand',
                  ),
                  const Gap(6),
                  const BalanceTile(
                    leading: "KES",
                    title: '4,235,567',
                    subtitle: 'KES cash in hand',
                  ),
                ],
              ),
            ),
            //Bank balances
            Padding(
              padding: const EdgeInsets.fromLTRB(6.0, 0, 6, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bank balances",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const BalanceTile(
                    leading: "USD",
                    title: '4,235,567',
                    subtitle: 'USD at bank',
                  ),
                  const Gap(6),
                  const BalanceTile(
                    leading: "KES",
                    title: '4,235,567',
                    subtitle: 'KES at bank',
                  ),
                  const Gap(12),
                  Text(
                    "Foreign currency stock",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  CustomContainer(
                    border: Border.all(color: Colors.grey, width: 0.3),
                    darkColor: AppColors.quinary,
                    width: double.infinity,
                    padding: const EdgeInsets.all(6),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        sortAscending: true,
                        horizontalMargin: 5,
                        headingTextStyle:
                            Theme.of(context).textTheme.titleLarge,
                        // headingRowColor:
                        // WidgetStateProperty.all<Color>(AppColors.primary),
                        headingRowHeight: 40,
                        // columnSpacing: 28,

                        columns: const [
                          DataColumn(
                            label: Text('Code'),
                          ),
                          DataColumn(
                            label: Text('Amount'),
                          ),
                          DataColumn(
                            label: Text('Rate'),
                          ),
                          DataColumn(
                            label: Text('Total'),
                          ),
                        ],
                        rows: const [
                          DataRow(
                            cells: [
                              DataCell(Text("USD")),
                              DataCell(Text('100')),
                              DataCell(Text('128.00')),
                              DataCell(Text('12,800')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("Euro")),
                              DataCell(Text('1000')),
                              DataCell(Text('170.00')),
                              DataCell(Text('145,230')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("CHF")),
                              DataCell(Text('80')),
                              DataCell(Text('128.00')),
                              DataCell(Text('16,700')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("CAD")),
                              DataCell(Text('100')),
                              DataCell(Text('110.00')),
                              DataCell(Text('11,000')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("USD\nsmall")),
                              DataCell(Text('100')),
                              DataCell(Text('128.00')),
                              DataCell(Text('12,800')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("UGX")),
                              DataCell(Text('20,000')),
                              DataCell(Text('0.04')),
                              DataCell(Text('800')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("ETH")),
                              DataCell(Text('10,000')),
                              DataCell(Text('1.00')),
                              DataCell(Text('10,000')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(12),
                  Text(
                    "Recent transactions",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  CustomContainer(
                    border: Border.all(color: Colors.grey, width: 0.3),
                    darkColor: AppColors.quinary,
                    width: double.infinity,
                    padding: const EdgeInsets.all(6),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingTextStyle:
                            Theme.of(context).textTheme.titleLarge,
                        // headingRowColor:
                        // WidgetStateProperty.all<Color>(AppColors.primary),
                        headingRowHeight: 40,
                        columnSpacing: 10,
                        horizontalMargin: 0,
                        columns: const [
                          DataColumn(
                            label: Text('Date'),
                          ),
                          DataColumn(
                            label: Text('Type'),
                          ),
                          DataColumn(
                            label: Text('Account'),
                          ),
                          DataColumn(
                            label: Text('Curr'),
                            numeric: true,
                          ),
                          DataColumn(
                            label: Text('Amount'),
                            numeric: true,
                          ),
                        ],
                        rows: const [
                          DataRow(
                            cells: [
                              DataCell(Text('Oct 01')),
                              DataCell(Text('Pay')),
                              DataCell(Text('Abdirahman\nAbdullahi')),
                              DataCell(Text('USD')),
                              DataCell(Text('\$1,000.00')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Oct 01')),
                              DataCell(Text('Withdraw')),
                              DataCell(Text('Mohamed\nFaarah')),
                              DataCell(Text('USD')),
                              DataCell(Text('\$1,000.00')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Oct 01')),
                              DataCell(Text('Pay')),
                              DataCell(Text(
                                'Faarah\nAbdullahi',
                                style:
                                    TextStyle(overflow: TextOverflow.ellipsis),
                              )),
                              DataCell(Text('KES')),
                              DataCell(Text('1,234,234.00')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Oct 01')),
                              DataCell(Text('Expense')),
                              DataCell(Text('Sudays\nAbdullahi')),
                              DataCell(Text('KES')),
                              DataCell(Text('1,000.00')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Oct 03')),
                              DataCell(Text('Pay')),
                              DataCell(Text('Mahad\nKuusow')),
                              DataCell(Text('USD')),
                              DataCell(Text('\$1,000.00')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Dec 14')),
                              DataCell(Text('Receive')),
                              DataCell(Text('Aways\nSudays')),
                              DataCell(Text('USD')),
                              DataCell(Text('\$1,000.00')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Nov 21')),
                              DataCell(Text('Withdraw')),
                              DataCell(Text('Mohamed\nSudays')),
                              DataCell(Text('USD')),
                              DataCell(Text('2,332,340.00')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(12),
                  Text(
                    "Stats",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Gap(3),
                  const PeriodSelector(),
                  const Gap(6),
                  SizedBox(
                    height: 830,
                    child: GridView.count(
                      padding: EdgeInsets.zero,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        StatsBox(
                            heroTag: "StatsReceivables",
                            label: "Receivables",
                            usd: "2,234,456",
                            kes: "3,534,567"),
                        StatsBox(
                            heroTag: "StatsPayables",
                            label: "Payables",
                            usd: "2,234,456",
                            kes: "3,534,567"),
                        StatsBox(
                            heroTag: "StatsPayments",
                            label: "Payments",
                            usd: "2,234,456",
                            kes: "3,534,567"),
                        StatsBox(
                            heroTag: "StatsReceipts",
                            label: "Receipts",
                            usd: "2,234,456",
                            kes: "3,534,567"),
                        StatsBox(
                            heroTag: "StatsDeposits",
                            label: "Deposits",
                            usd: "2,234,456",
                            kes: "3,534,567"),
                        StatsBox(
                            heroTag: "StatsWithdrawals",
                            label: "Withdrawals",
                            usd: "2,234,456",
                            kes: "3,534,567"),
                        StatsBox(
                            heroTag: "StatsTransfers",
                            label: "Transfers",
                            usd: "2,234,456",
                            kes: "3,534,567"),
                        StatsBox(
                            heroTag: "StatsExpense",
                            label: "Expenses",
                            usd: "2,234,456",
                            kes: "3,534,567"),
                        StatsBox(
                            heroTag: "NoOfTransactions",
                            label: "No of transactions",
                            usd: "123",
                            kes: "345"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
