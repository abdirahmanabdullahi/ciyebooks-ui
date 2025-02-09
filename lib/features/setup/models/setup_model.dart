
class BalancesModel {
  final double shillingAtBank;
  final double shillingCashInHand;
  final double shillingReceivable;
  final double shillingPayable;
  final double dollarAtBank;
  final double dollarCashInHand;
  final double dollarReceivable;
  final double dollarPayable;
  final double averageRateOfDollar;
  final double workingCapital;
  final double expenses;
  final double payments;
  final double receipts;
  final double withdrawals;
  final double deposits;
  final double transfers;
  final double currenciesAtCost;
  final Map<String, dynamic> inflows;
  final Map<String, dynamic> outflows;
  final Map<String, dynamic> transactionCounters;

  BalancesModel({
    required this.expenses,
    required this.shillingAtBank,
    required this.shillingCashInHand,
    required this.shillingReceivable,
    required this.shillingPayable,
    required this.dollarAtBank,
    required this.dollarCashInHand,
    required this.dollarReceivable,
    required this.dollarPayable,
    required this.averageRateOfDollar,
    required this.workingCapital,
    required this.payments,
    required this.deposits,
    required this.receipts,
    required this.transfers,
    required this.withdrawals,
    required this.currenciesAtCost,
    required this.inflows,
    required this.outflows,
    required this.transactionCounters,
  });

  /// Convert `BalancesModel` to JSON structure for storing data in Firestore
  Map<String, dynamic> toJson() {
    return {
      'shillingAtBank': shillingAtBank,
      'shillingCashInHand': shillingCashInHand,
      'shillingReceivable': shillingReceivable,
      'shillingPayable': shillingPayable,
      'dollarAtBank': dollarAtBank,
      'dollarCashInHand': dollarCashInHand,
      'dollarReceivable': dollarReceivable,
      'dollarPayable': dollarPayable,
      'averageRateOfDollar': averageRateOfDollar,
      'workingCapital': workingCapital,
      'expenses': expenses,
      'payments': payments,
      'deposits': deposits,
      'receipts': receipts,
      'transfers': transfers,
      'withdrawals': withdrawals,
      'currenciesAtCost': currenciesAtCost,
      'inflows': inflows,
      'outflows': outflows,
      'transactionCounters': transactionCounters
    };
  }

  /// Factory constructor to convert firestore data from Map to BalancesModel
  static BalancesModel empty() => BalancesModel(
      shillingAtBank: 0.0,
      shillingCashInHand: 0.0,
      shillingReceivable: 0.0,
      shillingPayable: 0.0,
      dollarAtBank: 0.0,
      dollarCashInHand: 0.0,
      dollarReceivable: 0.0,
      dollarPayable: 0.0,
      averageRateOfDollar: 0.0,
      workingCapital: 0.0,
      expenses: 0.0,
      payments: 0.0,
      deposits: 0.0,
      receipts: 0.0,
      transfers: 0.0,
      withdrawals: 0.0,
      currenciesAtCost: 0.0,
    inflows: {'USD': 0.0, 'KES': 0.0},
    outflows: {'USD': 0.0, 'KES': 0.0},
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
    },);

  factory BalancesModel.fromJson(Map<String, dynamic> jsonData) {
    return BalancesModel(
      shillingAtBank: (jsonData['shillingAtBank'] as num?)?.toDouble() ?? 0.0,
      shillingCashInHand: (jsonData['shillingCashInHand'] as num?)?.toDouble() ?? 0.0,
      shillingReceivable: (jsonData['shillingReceivable'] as num?)?.toDouble() ?? 0.0,
      shillingPayable: (jsonData['shillingPayable'] as num?)?.toDouble() ?? 0.0,
      dollarAtBank: (jsonData['dollarAtBank'] as num?)?.toDouble() ?? 0.0,
      dollarCashInHand: (jsonData['dollarCashInHand'] as num?)?.toDouble() ?? 0.0,
      dollarReceivable: (jsonData['dollarReceivable'] as num?)?.toDouble() ?? 0.0,
      dollarPayable: (jsonData['dollarPayable'] as num?)?.toDouble() ?? 0.0,
      averageRateOfDollar: (jsonData['averageRateOfDollar'] as num?)?.toDouble() ?? 0.0,
      workingCapital: (jsonData['workingCapital'] as num?)?.toDouble() ?? 0.0,
      expenses: (jsonData['expenses'] as num?)?.toDouble() ?? 0.0,
      payments: (jsonData['payments'] as num?)?.toDouble() ?? 0.0,
      deposits: (jsonData['deposits'] as num?)?.toDouble() ?? 0.0,
      withdrawals: (jsonData['withdrawals'] as num?)?.toDouble() ?? 0.0,
      receipts: (jsonData['receipts'] as num?)?.toDouble() ?? 0.0,
      transfers: (jsonData['transfers'] as num?)?.toDouble() ?? 0.0,
      currenciesAtCost: (jsonData['currenciesAtCost'] as num?)?.toDouble() ?? 0.0,
      inflows: Map<String, dynamic>.from(jsonData['inflows'] ?? {}),
      outflows: Map<String, dynamic>.from(jsonData['outflows'] ?? {}),
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
