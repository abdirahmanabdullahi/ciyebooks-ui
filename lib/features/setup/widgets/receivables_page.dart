import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:ciyebooks/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../accounts/controller/accounts_controller.dart';

class ReceivablesPage extends StatelessWidget {
  const ReceivablesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Receivables",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Gap(10),
          const Text(
            "Add accounts for individuals who owe you money. ",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const Gap(20),
          Expanded(
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "No receivables added yet.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      const Gap(10),
                      ElevatedButton(
                        onPressed: () {
                          _showAddReceivableBottomSheet(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.prettyDark,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Add Receivable",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddReceivableBottomSheet(BuildContext context) {
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
                  "Add Receivable",
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
                    const Gap(10),
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
                Gap(20)
              ],
            ),
          ),
        );
      },
    );
  }
}
