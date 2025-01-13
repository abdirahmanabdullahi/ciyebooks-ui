import 'package:ciyebooks/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ForeignCurrenciesPage extends StatelessWidget {
  const ForeignCurrenciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quarternary,

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Foreign Currencies",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Gap(10),
            const Text(
              "Manage foreign currencies by adding their name, exchange rate, amount in hand, and total value.",
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
                          "No foreign currencies added yet.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        const Gap(10),
                        ElevatedButton(
                          onPressed: () {
                            _showAddForeignCurrencyBottomSheet(context);
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
                            "Add Foreign Currency",
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
      ),
    );
  }

  void _showAddForeignCurrencyBottomSheet(BuildContext context) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Foreign Currency",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Gap(10),
              const TextField(
                decoration: InputDecoration(
                  labelText: "Currency Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: const TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Rate",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ), const Gap(10),
                  Expanded(
                    child: const TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Amount",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              const Gap(10),
               TextFormField(
                // enabled: false, // Total is calculated automatically
                decoration: InputDecoration(
                  labelText: "Total",
                  // border: OutlineInputBorder(),
                  // fillColor: Colors.grey[200],
                  // filled: true,
                ),
              ),
              const Gap(20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle submit action
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
              ),Gap(20)
            ],
          ),  
        );
      },
    );
  }
}