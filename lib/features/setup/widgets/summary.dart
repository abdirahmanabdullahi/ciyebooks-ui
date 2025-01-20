import 'package:ciyebooks/data/repositories/auth/auth_repo.dart';

import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../utils/validators/validation.dart';
import '../../accounts/controller/accounts_controller.dart';
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
                padding:
                    const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10),
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
                    ),
                    Divider(
                      height: 0,
                    ),
                    Gap(20),
                    InfoRow(title: 'Starting capital', value: "$capital"),
                    Gap(15),
                    InfoRow(
                        title: 'Kes cash balance', value: '$kesCashBalance'),
                    ExpansionTile(
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      collapsedShape:
                          Border(bottom: BorderSide.none, top: BorderSide.none),
                      title: InfoRow(
                          title: 'Receivables', value: '$kesReceivables'),
                      children: [
                        Column(
                          children: [
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('Accounts')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData || snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                        'No accounts found or an error occurred.'),
                                  );
                                }

                                final accounts = snapshot.data!.docs;

                                if (accounts.isEmpty) {
                                  return Center(
                                    child: Text('No accounts available.'),
                                  );
                                }

                                // Using a for loop to generate the list of widgets
                                List<Widget> accountWidgets = [];

                                for (var account in accounts) {
                                  final accountData = account.data();
                                  final accountName = accountData['FirstName'];
                                  final balance = accountData['PhoneNo'];
                                  final currencyBalances =
                                      accountData['CurrencyBalances'];
                                  // for (var currency in currencyBalances){
                                  //
                                  // }

                                  accountWidgets.add(
                                    ListTile(
                                      title: Text(accountName),
                                      subtitle:
                                          Text('Balance: $currencyBalances'),
                                      onTap: () {
                                        // Handle tap, if needed
                                      },
                                    ),
                                  );
                                }

                                return SingleChildScrollView(
                                  child: Column(
                                    children: accountWidgets,
                                  ),
                                );
                              },
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          createPayableBottomSheet(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.secondary,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        "New account",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Gap(6),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          showAddReceivableBottomSheet(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.secondary,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        "Add a receivable",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ExpansionTile(
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      collapsedShape:
                          Border(bottom: BorderSide.none, top: BorderSide.none),
                      title: InfoRow(title: 'Payables', value: '$kesPayables'),
                      children: [],
                    ),
                    ExpansionTile(
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      collapsedShape:
                          Border(bottom: BorderSide.none, top: BorderSide.none),
                      title:
                          InfoRow(title: 'Expenses', value: '$kesReceivables'),
                      children: [],
                    ),
                    ExpansionTile(
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      collapsedShape:
                          Border(bottom: BorderSide.none, top: BorderSide.none),
                      title: InfoRow(
                          title: 'Foreign currencies at cost',
                          value: '$kesPayables'),
                      children: [],
                    ),
                    Gap(10),
                    Divider(),
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
          style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
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

void showAddReceivableBottomSheet(BuildContext context) {
  final controller = Get.put(AccountsController());
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: controller.accountsFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Payable",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Gap(10),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('Accounts')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.hasError) {
                    return Center(
                      child: Text('No accounts found or an error occurred.'),
                    );
                  }

                  final accounts = snapshot.data!.docs;

                  if (accounts.isEmpty) {
                    return Center(
                      child: Text('No accounts available.'),
                    );
                  }

                  // This will hold all the dropdown menu entries
                  List<DropdownMenuEntry<String>> dropdownMenuEntries = [];

                  for (var account in accounts) {
                    final accountData = account.data();
                    final accountName = accountData[
                        'FirstName']; // Assuming 'FirstName' is the account name
                    final balance =
                        accountData['PhoneNo']; // Consider if you need this

                    // Add each account as a dropdown entry for the account name
                    dropdownMenuEntries.add(DropdownMenuEntry<String>(
                      value: accountName,
                      label: accountName,
                    ));
                  }

                  return DropdownMenu<String>(
                    width: double.infinity,
                    dropdownMenuEntries: dropdownMenuEntries,
                    onSelected: (value) {
                      // Handle the selected value here
                    },
                  );
                },
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: DropdownMenu(
                        width: double.infinity, dropdownMenuEntries: []),
                  ),
                  const Gap(10),
                  Expanded(
                    child: TextFormField(
                      controller: controller.email,
                      validator: (value) =>
                          Validator.validateEmptyText('field', value),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                ],
              ),
              const Gap(10),
              Gap(10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => controller.saveData(),
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
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Gap(20),
            ],
          ),
        ),
      );
    },
  );
}

void createPayableBottomSheet(BuildContext context) {
  final controller = Get.put(AccountsController());
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: controller.accountsFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create new receivable account",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    ///hjghghg
                    child: TextFormField(
                      validator: (value) =>
                          Validator.validateEmptyText('field', value),
                      controller: controller.firstName,
                      decoration: InputDecoration(
                        labelText: "First Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Gap(10),
                  Expanded(
                    child: TextFormField(
                      validator: (value) =>
                          Validator.validateEmptyText('field', value),
                      controller: controller.lastName,
                      decoration: InputDecoration(
                        labelText: "Last Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.phoneNo,
                      validator: (value) =>
                          Validator.validateEmptyText('field', value),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: TextFormField(
                      controller: controller.email,
                      validator: (value) =>
                          Validator.validateEmptyText('field', value),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.currency,
                      validator: (value) =>
                          Validator.validateEmptyText('field', value),
                      decoration: InputDecoration(
                        labelText: "Currency",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: TextFormField(
                      controller: controller.amount,
                      validator: (value) =>
                          Validator.validateEmptyText('field', value),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Amount",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => controller.saveData(),
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
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Gap(20),
            ],
          ),
        ),
      );
    },
  );
}
