
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../common/custom_appbar.dart';
import '../../common/styles/custom_container.dart';
import '../../navigation_menu.dart';
import '../../utils/constants/colors.dart';
import '../../utils/device/device_utility.dart';

class AccountStatement extends StatelessWidget {
  const AccountStatement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        showBackArrow: true,
        title: const Text("Account statement"),
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => NavigationMenu()),
              icon: const Icon(Icons.clear))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              width: double.infinity,
              child: FloatingActionButton(
                heroTag: "Account select period",
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: .6,
                onPressed: () {
                  showDateRangePicker(
                    initialEntryMode: DatePickerEntryMode.input,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(3000),
                    currentDate: DateTime(2024),
                    context: context,
                  );
                },
                // onPressed: () => Get.to(() => const ReceiptScreen()),
                backgroundColor: AppColors.prettyDark,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Select period",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .apply(color: AppColors.quinary),
                    ),
                    Gap(10),
                    Icon(
                      Icons.search,
                      color: AppColors.quinary,
                    )
                  ],
                ),
              ),
            ),
            Gap(8),
            CustomContainer(
              darkColor: AppColors.quinary,
              width: double.infinity,
              padding: EdgeInsets.all(0),
              height: DeviceUtils.getScreenHeight(context) * .7,
              child: SingleChildScrollView(
                child: DataTable(
                  headingTextStyle: Theme.of(context).textTheme.titleLarge,
                  // headingRowColor:
                  // WidgetStateProperty.all<Color>(AppColors.primary),
                  headingRowHeight: 40,
                  columnSpacing: 20,
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
                        DataCell(Icon(Icons.swap_horiz)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.north_east)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.arrow_downward)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.account_balance_outlined)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000,234.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.account_balance_outlined)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.swap_horiz)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.north_east)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.arrow_downward)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.account_balance_outlined)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.account_balance_outlined)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.swap_horiz)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.north_east)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.arrow_downward)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.account_balance_outlined)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.account_balance_outlined)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.swap_horiz)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.north_east)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.arrow_downward)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.account_balance_outlined)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('Oct 01')),
                        DataCell(Icon(Icons.account_balance_outlined)),
                        DataCell(Text('Mohamed\nFaarah')),
                        DataCell(Text('USD')),
                        DataCell(Text('\$1,000.00')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Gap(12),
            SizedBox(
              height: 40,
              width: 200,
              child: FloatingActionButton(
                heroTag: "Generate statement",
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: .6,
                onPressed: () {},
                backgroundColor: AppColors.prettyDark,
                child: Text(
                  "Generate statement",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .apply(color: AppColors.quinary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
