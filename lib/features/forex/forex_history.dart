
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/custom_appbar.dart';
import '../../common/styles/custom_container.dart';
import '../../navigation_menu.dart';
import '../../utils/constants/colors.dart';

class ForexHistory extends StatelessWidget {
  const ForexHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: Text("Forex history"),
        showBackArrow: true,
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => NavigationMenu()),
              icon: Icon(Icons.clear))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomContainer(
          darkColor: AppColors.quinary,
          width: double.infinity,
          padding: const EdgeInsets.all(6),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 28,
              sortAscending: true,
              horizontalMargin: 5,
              headingTextStyle: Theme.of(context).textTheme.titleLarge,
              // headingRowColor:
              // WidgetStateProperty.all<Color>(AppColors.primary),
              headingRowHeight: 40,

              columns: const [
                DataColumn(
                  label: Text('Code'),
                ),
                DataColumn(
                  label: Text('Type'),
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
                    DataCell(Text('buy')),
                    DataCell(Text('100')),
                    DataCell(Text('128.00')),
                    DataCell(Text('12,800')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text("Euro")),
                    DataCell(Text('Sell')),
                    DataCell(Text('1000')),
                    DataCell(Text('170.00')),
                    DataCell(Text('145,230')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text("CHF")),
                    DataCell(Text('Sell')),
                    DataCell(Text('80')),
                    DataCell(Text('128.00')),
                    DataCell(Text('16,700')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text("CAD")),
                    DataCell(Text('Buy')),
                    DataCell(Text('100')),
                    DataCell(Text('110.00')),
                    DataCell(Text('11,000')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text("USD\nsmall")),
                    DataCell(Text('Sell')),
                    DataCell(Text('100')),
                    DataCell(Text('128.00')),
                    DataCell(Text('12,800')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text("UGX")),
                    DataCell(Text('Buy')),
                    DataCell(Text('20,000')),
                    DataCell(Text('0.04')),
                    DataCell(Text('800')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text("ETH")),
                    DataCell(Text('Buy')),
                    DataCell(Text('10,000')),
                    DataCell(Text('1.00')),
                    DataCell(Text('10,000')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
