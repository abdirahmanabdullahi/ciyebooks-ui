class BalancesModel {
  final String baseCurrency;
  // final double shillingReceivable;
  // final double shillingPayable;
  // final double dollarCashInHand;
  // final double dollarReceivable;
  // final double dollarPayable;
  final double workingCapital;
  final double currenciesAtCost;
  final Map<String, dynamic> cashBalances;
  final Map<String, dynamic> bankBalances;
  final Map<String, dynamic> payable;
  final Map<String, dynamic> receivable;
  Map<String, dynamic> expenses;
  Map<String, dynamic> payments;
  Map<String, dynamic>receipts;
  Map<String, dynamic>withdrawals;
  Map<String, dynamic>deposits;
  Map<String, dynamic>transfers;
  // Map<String, dynamic>? inflows;
  // Map<String, dynamic>? outflows;
  final Map<String, dynamic> transactionCounters;

  BalancesModel(  {
    required this.expenses,
    required this.baseCurrency,
    required this.bankBalances,
    required this.payable,
    required this.receivable,
    required this.cashBalances,
    // required this.shillingAtBank,
    // required this.shillingCashInHand,
    // required this.shillingReceivable,
    // required this.shillingPayable,
    // required this.dollarAtBank,
    // required this.dollarCashInHand,
    // required this.dollarReceivable,
    // required this.dollarPayable,
    required this.workingCapital,
    required this.payments,
    required  this.deposits,
    required  this.receipts,
    required  this.transfers,
    required  this.withdrawals,
    required this.currenciesAtCost,
    // this.inflows,
    // this.outflows,
    required this.transactionCounters,
  });

  /// Convert `BalancesModel` to JSON structure for storing data in Firestore
  Map<String, dynamic> toJson() {
    return {

      'bankBalances': bankBalances,
      'baseCurrency': baseCurrency,
      // 'shillingCashInHand': shillingCashInHand,
      // 'shillingReceivable': shillingReceivable,
      // 'shillingPayable': shillingPayable,
      // 'dollarCashInHand': dollarCashInHand,
      'payable': payable,
      'receivable': receivable,
      'workingCapital': workingCapital,
      'cashBalances': cashBalances,
      'expenses': expenses,
      'payments': payments,
      'deposits': deposits,
      'receipts': receipts,
      'transfers': transfers,
      'withdrawals': withdrawals,
      'currenciesAtCost': currenciesAtCost,
      // 'inflows': inflows,
      // 'outflows': outflows,
      'transactionCounters': transactionCounters
    };
  }

  /// Factory constructor to convert firestore data from Map to BalancesModel
  static BalancesModel empty() => BalancesModel(
        // shillingAtBank: 0.0,
        // shillingCashInHand: 0.0,
        // shillingReceivable: 0.0,
        // shillingPayable: 0.0,
        // dollarAtBank: 0.0,
        // dollarCashInHand: 0.0,
        // dollarReceivable: 0.0,
        // dollarPayable: 0.0,
        workingCapital: 0.0,
    baseCurrency: '',
    expenses: {'USD': 0.0, 'KES': 0.0},
    payable: {'USD': 0.0, 'KES': 0.0},
    receivable: {'USD': 0.0, 'KES': 0.0},
        receipts: {'USD': 0.0, 'KES': 0.0},
        transfers: {'USD': 0.0, 'KES': 0.0},
        withdrawals: {'USD': 0.0, 'KES': 0.0},
        payments: {'USD': 0.0, 'KES': 0.0},
        deposits: {'USD': 0.0, 'KES': 0.0},
        currenciesAtCost: 0.0,
        // inflows: {'USD': 0.0, 'KES': 0.0},
        // outflows: {'USD': 0.0, 'KES': 0.0},
        cashBalances: {'USD': 0.0, 'KES': 0.0},

        transactionCounters: {
          'paymentsCounter': 0,
          'receiptsCounter': 0,
          'transfersCounter': 0,
          'expenseCounter': 0,
          'buyFxCounter': 0,
          'sellFxCounter': 0,
          'accountsCounter': 0,
          'bankDepositCounter': 0,
          'bankWithdrawCounter': 0,
          'bankTransferCounter': 0,
          'internalTransferCounter': 0,
        }, bankBalances: {'USD':0.0,'KES':0.0},
      );

  factory BalancesModel.fromJson(Map<String, dynamic> jsonData) {
    return BalancesModel(
      // shillingReceivable: (jsonData['shillingReceivable'] as num?)?.toDouble() ?? 0.0,
      // shillingPayable: (jsonData['shillingPayable'] as num?)?.toDouble() ?? 0.0,
      // dollarReceivable: (jsonData['dollarReceivable'] as num?)?.toDouble() ?? 0.0,
      // dollarPayable: (jsonData['dollarPayable'] as num?)?.toDouble() ?? 0.0,
      workingCapital: (jsonData['workingCapital'] as num?)?.toDouble() ?? 0.0,
      expenses: Map<String, dynamic>.from(jsonData['expenses'] ?? {}),
      payable: Map<String, dynamic>.from(jsonData['payable'] ?? {}),
      receivable: Map<String, dynamic>.from(jsonData['receivable'] ?? {}),
      bankBalances: Map<String, dynamic>.from(jsonData['bankBalances'] ?? {}),
      cashBalances: Map<String, dynamic>.from(jsonData['cashBalances'] ?? {}),
      payments: Map<String, dynamic>.from(jsonData['payments'] ?? {}),
      deposits: Map<String, dynamic>.from(jsonData['deposits'] ?? {}),
      withdrawals: Map<String, dynamic>.from(jsonData['withdrawals'] ?? {}),
      receipts: Map<String, dynamic>.from(jsonData['receipts'] ?? {}),
      transfers: Map<String, dynamic>.from(jsonData['transfers'] ?? {}),
      // inflows: Map<String, dynamic>.from(jsonData['inflows'] ?? {}),
      // outflows: Map<String, dynamic>.from(jsonData['outflows'] ?? {}),
      currenciesAtCost: (jsonData['currenciesAtCost'] as num?)?.toDouble() ?? 0.0,
      baseCurrency: jsonData['baseCurrency'] ,
      transactionCounters: Map<String, dynamic>.from(jsonData['transactionCounters']),
    );
  }

  /// Factory constructor for creating a `BalancesModel` instance from a Firestore document snapshot
  // factory BalancesModel.fromSnapshot(
  //     DocumentSnapshot<Map<String, dynamic>> document) {
  //   final data = document.data();
  //   if (data != null) {
  //     return BalancesModel(
  //       capital: (data['Capital'] as num?)?.toDouble() ?? 0.0,
  //       kesCashBalance: (data['KesCashBalance'] as num?)?.toDouble() ?? 0.0,
  //       usdCashBalance: (data['UsdCashBalance'] as num?)?.toDouble() ?? 0.0,
  //       kesBankBalance: (data['KesBankBalance'] as num?)?.toDouble() ?? 0.0,
  //       usdBankBalance: (data['UsdBankBalance'] as num?)?.toDouble() ?? 0.0,
  //       kesReceivables: (data['KesReceivables'] as num?)?.toDouble() ?? 0.0,
  //       usdReceivables: (data['UsdReceivables'] as num?)?.toDouble() ?? 0.0,
  //       kesPayables: (data['KesPayables'] as num?)?.toDouble() ?? 0.0,
  //       usdPayables: (data['UsdPayables'] as num?)?.toDouble() ?? 0.0,
  //       profitBalance: (data['ProfitBalance'] as num?)?.toDouble() ?? 0.0,
  //     );
  //   } else {
  //     throw Exception('Document snapshot data is null');
  //   }
  // }
}
