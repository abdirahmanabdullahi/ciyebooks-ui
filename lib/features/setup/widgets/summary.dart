import 'package:ciyebooks/data/repositories/auth/auth_repo.dart';

import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../controller/setup_controller.dart';

// Main Finance Dashboard Screen
class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SetupController());

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: controller.setUpStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
          return Text('When done, setup data will appear here');
        }

        final data = snapshot.data!;

        final capital = data['Capital'] ?? 0.0; // Default to 0.0 if missing
        final kesBankBalance =
            data['KesBankBalance'] ?? 0.0; // Default to 0.0 if missing
        final kesCashBalance =
            data['KesCashBalance'] ?? 0.0; // Default to 0.0 if missing
        final kesPayables =
            data['KesPayables'] ?? 0.0; // Default to 0.0 if missing
        final kesReceivables =
            data['KesReceivables'] ?? 0.0; // Default to 0.0 if missing
        final profitBalance =
            data['ProfitBalance'] ?? 0.0; // Default to 0.0 if missing
        final usdBankBalance =
            data['UsdBankBalance'] ?? 0.0; // Default to 0.0 if missing
        final usdCashBalance =
            data['UsdCashBalance'] ?? 0.0; // Default to 0.0 if missing
        final usdPayables =
            data['UsdPayables'] ?? 0.0; // Default to 0.0 if missing
        final usdReceivables =
            data['UsdReceivables'] ?? 0.0; // Default to 0.0 if missing
        // final Expesnes =
        //     data['Expenses'] ?? 0.0; // Default to 0.0 if missing

        return SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Account setup',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),Divider(height: 0,),Gap(20),
                    InfoRow(title: 'Starting capital', value: "$capital"),Gap(15),
                    InfoRow(
                        title: 'Kes cash balance', value: '$kesCashBalance'),
                    ExpansionTile(
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      collapsedShape:
                      Border(bottom: BorderSide.none, top: BorderSide.none),
                      title: InfoRow(
                          title: 'Payables', value: '$kesPayables'),
                      children: [
                        ForexData(),
                      ],
                    ),
                    ExpansionTile(
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      collapsedShape:
                      Border(bottom: BorderSide.none, top: BorderSide.none),
                      title: InfoRow(
                          title: 'Receivables', value: '$kesReceivables'),
                      children: [
                        ForexData(),
                      ],
                    ),
                    ExpansionTile(
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      collapsedShape:
                      Border(bottom: BorderSide.none, top: BorderSide.none),
                      title: InfoRow(
                          title: 'Expenses', value: '$kesReceivables'),
                      children: [
                        ForexData(),
                      ],
                    ),
                    ExpansionTile(
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      collapsedShape:
                      Border(bottom: BorderSide.none, top: BorderSide.none),
                      title: InfoRow(
                          title: 'Foreign currencies at cost', value: '$kesPayables'),
                      children: [
                        ForexData(),
                      ],
                    ),Gap(10),Divider(),

                    Gap(20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => controller.saveSetupData(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Complete setup",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style:
              TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
        ),
        Text(
          value,
          style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins'),
        ),
      ],
    );
  }
}

class ForexData extends StatelessWidget {
  const ForexData({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: double.infinity,
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
      ),
    );
  }
}
