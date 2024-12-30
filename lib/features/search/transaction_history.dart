import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../common/styles/custom_container.dart';
import '../../navigation_menu.dart';
import '../../utils/constants/colors.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _selectedType;
  String? _selectedAccount;

  // Mock transaction data
  final List<Map<String, dynamic>> _transactions = [
    {
      "type": "Payment",
      "account": "Client 1",
      "date": "2024-12-10",
      "amount": 1200,
      "currency": "USD"
    },
    {
      "type": "Receipt",
      "account": "Main Account",
      "date": "2024-12-11",
      "amount": 500,
      "currency": "USD"
    },
    {
      "type": "Expense",
      "account": "Bank Account",
      "date": "2024-12-12",
      "amount": 300,
      "currency": "KES"
    },{
      "type": "Payment",
      "account": "Client 1",
      "date": "2024-12-10",
      "amount": 1200,
      "currency": "USD"
    },
    {
      "type": "Receipt",
      "account": "Main Account",
      "date": "2024-12-11",
      "amount": 500,
      "currency": "USD"
    },
    {
      "type": "Expense",
      "account": "Bank Account",
      "date": "2024-12-12",
      "amount": 300,
      "currency": "KES"
    },{
      "type": "Payment",
      "account": "Client 1",
      "date": "2024-12-10",
      "amount": 1200,
      "currency": "USD"
    },
    {
      "type": "Receipt",
      "account": "Main Account",
      "date": "2024-12-11",
      "amount": 500,
      "currency": "USD"
    },
    {
      "type": "Expense",
      "account": "Bank Account",
      "date": "2024-12-12",
      "amount": 300,
      "currency": "KES"
    },{
      "type": "Payment",
      "account": "Client 1",
      "date": "2024-12-10",
      "amount": 1200,
      "currency": "USD"
    },
    {
      "type": "Receipt",
      "account": "Main Account",
      "date": "2024-12-11",
      "amount": 500,
      "currency": "USD"
    },
    {
      "type": "Expense",
      "account": "Bank Account",
      "date": "2024-12-12",
      "amount": 300,
      "currency": "KES"
    },{
      "type": "Payment",
      "account": "Client 1",
      "date": "2024-12-10",
      "amount": 1200,
      "currency": "USD"
    },
    {
      "type": "Receipt",
      "account": "Main Account",
      "date": "2024-12-11",
      "amount": 500,
      "currency": "USD"
    },
    {
      "type": "Expense",
      "account": "Bank Account",
      "date": "2024-12-12",
      "amount": 300,
      "currency": "KES"
    },{
      "type": "Payment",
      "account": "Client 1",
      "date": "2024-12-10",
      "amount": 1200,
      "currency": "USD"
    },
    {
      "type": "Receipt",
      "account": "Main Account",
      "date": "2024-12-11",
      "amount": 500,
      "currency": "USD"
    },
    {
      "type": "Expense",
      "account": "Bank Account",
      "date": "2024-12-12",
      "amount": 300,
      "currency": "KES"
    },{
      "type": "Payment",
      "account": "Client 1",
      "date": "2024-12-10",
      "amount": 1200,
      "currency": "USD"
    },
    {
      "type": "Receipt",
      "account": "Main Account",
      "date": "2024-12-11",
      "amount": 500,
      "currency": "USD"
    },
    {
      "type": "Expense",
      "account": "Bank Account",
      "date": "2024-12-12",
      "amount": 300,
      "currency": "KES"
    },{
      "type": "Payment",
      "account": "Client 1",
      "date": "2024-12-10",
      "amount": 1200,
      "currency": "USD"
    },
    {
      "type": "Receipt",
      "account": "Main Account",
      "date": "2024-12-11",
      "amount": 500,
      "currency": "USD"
    },
    {
      "type": "Expense",
      "account": "Bank Account",
      "date": "2024-12-12",
      "amount": 300,
      "currency": "KES"
    },{
      "type": "Payment",
      "account": "Client 1",
      "date": "2024-12-10",
      "amount": 1200,
      "currency": "USD"
    },
    {
      "type": "Receipt",
      "account": "Main Account",
      "date": "2024-12-11",
      "amount": 500,
      "currency": "USD"
    },
    {
      "type": "Expense",
      "account": "Bank Account",
      "date": "2024-12-12",
      "amount": 300,
      "currency": "KES"
    },{
      "type": "Payment",
      "account": "Client 1",
      "date": "2024-12-10",
      "amount": 1200,
      "currency": "USD"
    },
    {
      "type": "Receipt",
      "account": "Main Account",
      "date": "2024-12-11",
      "amount": 500,
      "currency": "USD"
    },
    {
      "type": "Expense",
      "account": "Bank Account",
      "date": "2024-12-12",
      "amount": 300,
      "currency": "KES"
    },
  ];

  // Transaction types and accounts (mock data)
  final List<String> _transactionTypes = [
    "All",
    "Payment",
    "Receipt",
    "Expense",
    "Deposit",
    "Transfer",
    "Buy Currency",
    "Sell Currency",
  ];

  final List<String> _accounts = [
    "All",
    "Main Account",
    "Client 1",
    "Client 2",
    "Bank Account",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,actions: [ Padding(
        padding: const EdgeInsets.only(right: 18.0),
        child: IconButton(
            onPressed: () => Get.offAll(() => NavigationMenu()),
            icon: const Icon(Icons.clear)),
      )],
        backgroundColor: AppColors.quinary,
        title: const Text("Transaction History"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters Section
            CustomContainer(width: double.infinity,darkColor: AppColors.quarternary,
            padding: EdgeInsets.zero,
            child: _buildFilters()),
            Gap(6),

            // Transactions List
            Expanded(
              child: ListView.builder(padding: EdgeInsets.zero,physics: ClampingScrollPhysics(),
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final transaction = _transactions[index];
                  return _buildTransactionTile(transaction);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Row(
            children: [
              // Transaction Type Filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedType,
                  items: _transactionTypes
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      labelText: "Search by type",
                      labelStyle: TextStyle(fontSize: 12),
                      fillColor: AppColors.quinary,
                      filled: true),
                ),
              ),
              const SizedBox(width: 3),

              // Account Filter
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedAccount,
                  items: _accounts
                      .map((account) => DropdownMenuItem(
                          value: account, child: Text(account)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAccount = value;
                    });
                  },
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      labelStyle: TextStyle(fontSize: 12),
                      labelText: "Search by account",
                      fillColor: AppColors.quinary,
                      filled: true),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 3),

        // Date and Amount Filters
        SizedBox(
          height: 40,
          child: Row(
            children: [
              // Date Filter
              Expanded(
                child: TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 12),
                      labelStyle: TextStyle(fontSize: 12),
                      labelText: "Search by date",
                      fillColor: AppColors.quinary,
                      filled: true),
                  onTap: () async {

                  },
                ),
              ),
              const SizedBox(width: 3),

              // Amount Filter
              Expanded(
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 12),
                      labelStyle: TextStyle(fontSize: 12),
                      labelText: "Search by amount",
                      fillColor: AppColors.quinary,
                      filled: true),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTile(Map<String, dynamic> transaction) {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: ListTile(tileColor:AppColors.quinary,dense: true,isThreeLine: true,shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: .2),
        borderRadius: BorderRadius.circular(10),
      ),
        title: Text(
          "${transaction['type']} - ${transaction['account']}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date: ${transaction['date']}"),
            Text("Amount: \$${transaction['amount']}"),
          ],
        ),
        trailing: Text(
          transaction['currency'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}
