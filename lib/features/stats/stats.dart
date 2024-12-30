
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gap/gap.dart';

import '../../common/styles/custom_container.dart';
import '../../utils/constants/colors.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  final List<Map<String, dynamic>> transactionData = const [
    {"date": "Dec 10", "usd": 10450, "kes": 1450000},
    {"date": "Dec 11", "usd": 6200, "kes": 890000},
    {"date": "Dec 12", "usd": 14800, "kes": 2075000},
    {"date": "Dec 13", "usd": 3750, "kes": 525000},
    {"date": "Dec 14", "usd": 2900, "kes": 406000},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Statistics",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ), leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer(); // Correct context for drawer
        },
        icon: Icon(Icons.sort),
      ),
        backgroundColor: AppColors.quarternary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(physics: ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 6.0,vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Gap(20),
            Text(
              "Financial Summaries",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatsCard("Payments", "\$10,450", Colors.red),
            _buildStatsCard("Withdrawals", "\$6,200", Colors.orange),
            _buildStatsCard("Deposits", "\$14,800", Colors.teal),
            _buildStatsCard("Transfers", "\$3,750", Colors.blue),
            _buildStatsCard("Expenses", "\$2,900", Colors.purple),
            _buildStatsCard("Profit", "\$1,400", Colors.green),
            const SizedBox(height: 24),
            _buildGraphSection(
              title: "Payments Trend (USD & KES)",
              chart: BarChart(_buildBarChartData()),
            ),
            const SizedBox(height: 24),
            Text(
              "Insights & Alerts",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildAlertTile("Overdue Receivables: \$1,200", Colors.red),
            _buildAlertTile("Upcoming Payments: \$900", Colors.orange),
            _buildAlertTile("Foreign Exchange Profits Rising!", Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(String title, String value, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: CustomContainer(
        darkColor: AppColors.quinary,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 16, color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphSection({required String title, required Widget chart}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 1.5,
          child: chart,
        ),
      ],
    );
  }

  BarChartData _buildBarChartData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceBetween,
      barGroups: transactionData.asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value;
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: data["usd"].toDouble(),
              color: Colors.blue,
              width: 12,
            ),
            BarChartRodData(
              toY: data["kes"] / 1000, // Scaling KES down for readability
              color: Colors.green,
              width: 12,
            ),
          ],
        );
      }).toList(),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, _) {
              return Text(
                transactionData[value.toInt()]["date"],
                style: const TextStyle(fontSize: 12),
              );
            },
          ),
        ),
      ),
      gridData: FlGridData(show: true),
      borderData: FlBorderData(show: false),
    );
  }

  Widget _buildAlertTile(String message, Color color) {
    return ListTile(
      trailing: Icon(Icons.arrow_forward_ios, color: color),
      leading: Icon(Icons.warning_amber_rounded, color: color),
      title: Text(message, style: TextStyle(color: color)),
    );
  }
}