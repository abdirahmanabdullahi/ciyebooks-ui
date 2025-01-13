import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// Main Finance Dashboard Screen
class FinanceDashboardScreen extends StatelessWidget {
  const FinanceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            Card(
              color: AppColors.quinary,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Review and confirm figures',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  BalanceSummaryWidget(
                    cashBalance: '\$12,500',
                    capitalAccount: '\$20,000',
                  ),
                  Divider(),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Payables & Receivables',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  FinancialDetailWidget(
                    title: 'Payables',
                    value: '-\$3,000',
                    valueColor: Colors.red,
                  ),
                  FinancialDetailWidget(
                    title: '',
                    value: '-KES 245,500',
                    valueColor: Colors.red,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(),
                  ),
                  FinancialDetailWidget(
                    title: 'Receivables',
                    value: '-\$3,000',
                    valueColor: Colors.green,
                  ),
                  FinancialDetailWidget(
                    title: '',
                    value: '340,000',
                    valueColor: Colors.green,
                  ),
                  Divider(),
                  SizedBox(height: 10),
                  FinancialDetailWidget(
                    title: 'Expenses',
                    value: '-\$800 ',
                    valueColor: Colors.red,
                  ),SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  FinancialDetailWidget(
                    title: 'Profit',
                    value: 'KES 800 ',
                    valueColor: Colors.green,
                  ),SizedBox(height: 10),
                  Divider(),
                  Gap(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Foreign currencies at cost',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  ForexData(),
                  Gap(20),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  backgroundColor: AppColors.prettyDark,
                  onPressed: () {},
                  child: Text(
                    "Submit",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .apply(color: AppColors.quinary),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Balance Summary Widget
class BalanceSummaryWidget extends StatelessWidget {
  final String cashBalance;
  final String capitalAccount;

  const BalanceSummaryWidget({
    super.key,
    required this.cashBalance,
    required this.capitalAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          InfoRow(
            title: 'Capital Account',
            value: capitalAccount,
            valueColor: Colors.blue,
          ),
          Divider(),
          InfoRow(
            title: 'USD Cash Balance',
            value: cashBalance,
            valueColor: Colors.green,
          ),
          InfoRow(
            title: 'KES Cash Balance',
            value: cashBalance,
            valueColor: Colors.green,
          ),
          Divider(),
          InfoRow(
            title: 'USD at bank',
            value: cashBalance,
            valueColor: Colors.green,
          ),
          InfoRow(
            title: 'KES at bank',
            value: cashBalance,
            valueColor: Colors.green,
          ),
        ],
      ),
    );
  }
}

// Financial Detail Widget
class FinancialDetailWidget extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const FinancialDetailWidget({
    super.key,
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(color: valueColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// Currency Detail Widget
class CurrencyDetailWidget extends StatelessWidget {
  final List<Map<String, String>> currencies;

  const CurrencyDetailWidget({
    super.key,
    required this.currencies,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Foreign Currencies at cost',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 10),
          ...currencies.map((currency) => InfoRow(
                title: currency['currency']!,
                value: currency['amount']!,
              )),
        ],
      ),
    );
  }
}

// Other Information Widget
class OtherInformationWidget extends StatelessWidget {
  final String profits;
  final String lastUpdated;

  const OtherInformationWidget({
    super.key,
    required this.profits,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          InfoRow(
            title: 'Profits (last month)',
            value: profits,
            valueColor: Colors.green,
          ),
          Divider(),
          InfoRow(
            title: 'Last Updated',
            value: lastUpdated,
            valueColor: Colors.black54,
          ),
        ],
      ),
    );
  }
}

// InfoRow StatelessWidget
class InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const InfoRow({
    super.key,
    required this.title,
    required this.value,
    this.valueColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(color: valueColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ForexData extends StatelessWidget {
  const ForexData({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DataTable(
        sortAscending: true,
        horizontalMargin: 5,
        headingTextStyle: Theme.of(context).textTheme.titleLarge,
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
        ],
      ),
    );
  }
}
