class DailyReportModel {
  final Map<String, dynamic> received;
  final Map<String, dynamic> payments;
  final Map<String, dynamic> deposits;
  final Map<String, dynamic> withdrawals;
  final Map<String, dynamic> expenses;
  final double dailyProfit;
  final double numberOfCurrencySales;
  final double numberOfClientDeposits;
  final double numberOfPayments;
  final double numberOfExpenses;
  final double numberOfDeposits;
  final double numberOfWithdrawals;

  DailyReportModel({
    required this.received,
    required this.numberOfExpenses,
    required this.payments,
    required this.deposits,
    required this.withdrawals,
    required this.expenses,
    required this.dailyProfit,
    required this.numberOfCurrencySales,
    required this.numberOfClientDeposits,
    required this.numberOfPayments,
    required this.numberOfDeposits,
    required this.numberOfWithdrawals,
  });

  /// Convert `DailyReportModel` to JSON structure for storing data in Firestore
  Map<String, dynamic> toJson() {
    return {
      'received': received,
      'numberOfExpenses': numberOfExpenses,
      'payments': payments,
      'deposits': deposits,
      'withdrawals': withdrawals,
      'expenses': expenses,
      'dailyProfit': dailyProfit,
      'numberOfCurrencySales': numberOfCurrencySales,
      'numberOfClientDeposits': numberOfClientDeposits,
      'numberOfPayments': numberOfPayments,
      'numberOfDeposits': numberOfDeposits,
      'numberOfWithdrawals': numberOfWithdrawals,

    };
  }

  static DailyReportModel empty() => DailyReportModel(
      received: {},
      numberOfExpenses: 0,
      payments: {},
      deposits: {},
      withdrawals: {},
      expenses: {},
      dailyProfit: 0,
      numberOfCurrencySales: 0,
      numberOfClientDeposits: 0,
      numberOfPayments: 0,
      numberOfDeposits: 0,
      numberOfWithdrawals: 0);

  factory DailyReportModel.fromJson(Map<String, dynamic> jsonData) {
    return DailyReportModel(
      received: Map<String, dynamic>.from(jsonData['received'] ?? {}),
      payments: Map<String, dynamic>.from(jsonData['payments'] ?? {}),
      deposits: Map<String, dynamic>.from(jsonData['deposits'] ?? {}),
      withdrawals: Map<String, dynamic>.from(jsonData['withdrawals'] ?? {}),
      expenses: Map<String, dynamic>.from(jsonData['expenses'] ?? {}),
      numberOfExpenses: jsonData['numberOfExpenses']?? 0.0,
      dailyProfit: jsonData['dailyProfit'] ?? 0.0,
      numberOfCurrencySales: jsonData['numberOfCurrencySales'] ?? 0.0,
      numberOfClientDeposits: jsonData['numberOfClientDeposits'] ?? 0.0,
      numberOfPayments: jsonData['numberOfPayments']?? 0.0,
      numberOfDeposits: jsonData['numberOfDeposits']?? 0.0,
      numberOfWithdrawals: jsonData['numberOfWithdrawals']?? 0.0,
    );
  }
}
