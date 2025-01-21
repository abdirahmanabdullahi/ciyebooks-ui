import 'package:ciyebooks/common/styles/custom_container.dart';
import 'package:ciyebooks/data/repositories/auth/auth_repo.dart';

import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/validators/validation.dart';
import '../../accounts/controller/accounts_controller.dart';
import '../controller/setup_controller.dart';

// Main Finance Dashboard Screen
class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {
    final setupController = Get.put(SetupController());
    final accountsController = Get.put(AccountsController());

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: setupController.setUpStream,
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
                    const EdgeInsets.symmetric(vertical: 18.0, horizontal: 6),
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
                                  .orderBy('DateCreated', descending: true)
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

                                /// Format the number to have decimals and 1,000 separator
                                final formatter =
                                    NumberFormat.decimalPatternDigits(
                                  locale: 'en_us',
                                  decimalDigits: 2,
                                );

                                for (var account in accounts) {
                                  final accountData = account.data();
                                  accountWidgets.add(
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: ListTile(
                                        titleAlignment:
                                            ListTileTitleAlignment.titleHeight,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        // dense: true,
                                        tileColor: AppColors.quinary,
                                        title: Text(
                                            '${accountData['AccountName']}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        subtitle: Text(
                                          'Acc-no: ${accountData['AccountNo']}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.purple),
                                        ),
                                        trailing: Column(
                                          spacing: 0,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                'KES: ${formatter.format(accountData['KesBalance'] ?? 0.0)}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: (accountData[
                                                                    'KesBalance'] ??
                                                                0.0) <
                                                            0
                                                        ? Colors.red
                                                        : Colors.blue)),
                                            Gap(6),
                                            Text(
                                                'USD: ${formatter.format(accountData['UsdBalance'] ?? 0.0)}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: (accountData[
                                                                    'UsdBalance'] ??
                                                                0.0) <
                                                            0
                                                        ? Colors.red
                                                        : Colors.green))
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }

                                return Column(
                                  children: accountWidgets,
                                );
                              },
                            ),
                            Divider(),
                            // Expanded(
                            //   child: Align(
                            //     alignment: Alignment.centerRight,
                            //     child: ElevatedButton(
                            //       onPressed: () {
                            //
                            //         createPayableBottomSheet(context);
                            //       },
                            //       style: ElevatedButton.styleFrom(
                            //         backgroundColor: AppColors.secondary,
                            //         padding: const EdgeInsets.symmetric(
                            //           horizontal: 20,
                            //           vertical: 12,
                            //         ),
                            //         shape: RoundedRectangleBorder(
                            //           borderRadius:
                            //               BorderRadius.circular(12),
                            //         ),
                            //       ),
                            //       child: const Text(
                            //         "New payable",
                            //         style: TextStyle(
                            //           color: AppColors.quinary,
                            //           fontSize: 16,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {


                                  createPayableBottomSheet(context);

                                },
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
                                    color: AppColors.quinary,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),

                            Gap(6),
                          ],
                        ),
                      ],
                    ),
                    ExpansionTile(
                      childrenPadding: EdgeInsets.zero,
                      tilePadding: EdgeInsets.zero,
                      collapsedShape:
                          Border(bottom: BorderSide.none, top: BorderSide.none),
                      title:
                          InfoRow(title: 'Payables', value: '$kesReceivables'),
                      children: [
                        Column(
                          children: [
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('Accounts')
                                  .where('KesBalance', isGreaterThan: 0)
                                  // .where('UsdBalance',
                                  //     isGreaterThan: 0)
                                  // where("population", isGreaterThan: 1000000)
                                  //     .where("density", isLessThan: 10000);
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

                                /// Format the number to have decimals and 1,000 separator
                                final formatter =
                                    NumberFormat.decimalPatternDigits(
                                  locale: 'en_us',
                                  decimalDigits: 2,
                                );

                                for (var account in accounts) {
                                  final accountData = account.data();
                                  accountWidgets.add(
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: ListTile(
                                        titleAlignment:
                                            ListTileTitleAlignment.titleHeight,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        dense: true,
                                        tileColor: AppColors.quinary,
                                        title: Text(
                                          '${accountData['AccountName']}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .apply(fontSizeFactor: .8),
                                        ),
                                        subtitle: Text(
                                            'Acc_no: ${accountData['AccountNo']}'),
                                        trailing: Column(
                                            spacing: 0,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'KES: ${formatter.format(accountData['KesBalance'] ?? 0.0)}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                              Gap(6),
                                              Text(
                                                'USD: ${formatter.format(accountData['usdBalance'] ?? 0.0)}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              )
                                            ]),

                                        // Column(
                                        //   crossAxisAlignment:
                                        //       CrossAxisAlignment
                                        //           .start,
                                        //   children: [
                                        //   ],
                                        // ),
                                      ),
                                    ),
                                  );
                                }

                                return Column(
                                  children: accountWidgets,
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
                                          color: AppColors.quinary,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Gap(6),
                                  // Align(
                                  //   alignment: Alignment.centerRight,
                                  //   child: TextButton(
                                  //     onPressed: () =>
                                  //         showAddReceivableBottomSheet(context),
                                  //     child: const Text(
                                  //       "Add a receivable",
                                  //       style: TextStyle(
                                  //         color: AppColors.prettyDark,
                                  //         fontSize: 16,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
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
                    onPressed: () => setupController.saveSetupData(),
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

// void showAddReceivableBottomSheet(BuildContext context) {
//   final controller = Get.put(AccountsController());
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.white,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(
//         top: Radius.circular(20),
//       ),
//     ),
//     builder: (context) {
//       return Padding(
//         padding: EdgeInsets.only(
//           left: 16,
//           right: 16,
//           top: 16,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//         ),
//         child: Form(
//           key: controller.accountsFormKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Add Payable",
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               const Gap(10),
//               StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                 stream: FirebaseFirestore.instance
//                     .collection('Users')
//                     .doc(FirebaseAuth.instance.currentUser!.uid)
//                     .collection('Accounts')
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData || snapshot.hasError) {
//                     return Center(
//                       child: Text('No accounts found or an error occurred.'),
//                     );
//                   }
//
//                   final accounts = snapshot.data!.docs;
//
//                   if (accounts.isEmpty) {
//                     return Center(
//                       child: Text('No accounts available.'),
//                     );
//                   }
//
//                   // This will hold all the dropdown menu entries
//                   List<DropdownMenuEntry<String>> dropdownMenuEntries = [];
//
//                   for (var account in accounts) {
//                     final accountData = account.data();
//                     final accountName = accountData[
//                         'FirstName']; // Assuming 'FirstName' is the account name
//                     final balance =
//                         accountData['PhoneNo']; // Consider if you need this
//
//                     // Add each account as a dropdown entry for the account name
//                     dropdownMenuEntries.add(DropdownMenuEntry<String>(
//                       value: accountName,
//                       label: accountName,
//                     ));
//                   }
//
//                   return DropdownMenu<String>(
//                     width: double.infinity,
//                     dropdownMenuEntries: dropdownMenuEntries,
//                     onSelected: (value) {
//                       // Handle the selected value here
//                     },
//                   );
//                 },
//               ),
//               const Gap(10),
//               Row(
//                 children: [
//                   Expanded(
//                     child: DropdownMenu(
//                         width: double.infinity, dropdownMenuEntries: []),
//                   ),
//                   const Gap(10),
//                   Expanded(
//                     child: TextFormField(
//                       controller: controller.email,
//                       validator: (value) =>
//                           Validator.validateEmptyText('field', value),
//                       keyboardType: TextInputType.emailAddress,
//                       decoration: InputDecoration(
//                         labelText: "Email",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               const Gap(10),
//               Gap(10),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // controller.makeItNegative.value = false;
//                     controller.saveData();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.secondary,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 12,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text(
//                     "Submit",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//               Gap(20),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

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
                      controller: controller.usd,
                      validator: (value) =>
                          Validator.validateEmptyText('field', value),
                      decoration: InputDecoration(
                        labelText: "USD amount",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Obx(
                            () => SizedBox(height: 20,width: 30,
                          child: Checkbox(activeColor: Colors.red,
                            value: controller.usdIsNegative.value,
                            onChanged: (value) => controller.usdIsNegative
                                .value = !controller.usdIsNegative.value,
                          ),
                        ),
                      ),Text('Overdrawn?',style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                ],
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.kes,
                      validator: (value) =>
                          Validator.validateEmptyText('field', value),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "KES amount",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Obx(
                        () => SizedBox(height: 20,width: 30,
                          child: Checkbox(activeColor: Colors.red,
                            value: controller.kesIsNegative.value,
                            onChanged: (value) => controller.kesIsNegative
                                .value = !controller.kesIsNegative.value,
                          ),
                        ),
                      ),Text('Overdrawn?',style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                ],
              ),
              Gap(10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // controller.makeItNegative.value = true;
                    controller.saveData();
                  },
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
