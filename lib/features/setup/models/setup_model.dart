import 'package:cloud_firestore/cloud_firestore.dart';

class BalancesModel {
  final double capital;
  final double kesCashBalance;
  final double usdCashBalance;
  final double kesBankBalance;
  final double usdBankBalance;
  final double kesReceivables;
  final double usdReceivables;
  final double kesPayables;
  final double usdPayables;
  final bool accountIsSetup;
  final double profitBalance;

  BalancesModel({
    required this.capital,
    required this.kesCashBalance,
    required this.usdCashBalance,
    required this.kesBankBalance,
    required this.usdBankBalance,
    required this.kesReceivables,
    required this.usdReceivables,
    required this.kesPayables,
    required this.usdPayables,
    required this.accountIsSetup,
    required this.profitBalance,
  });

  /// Convert `BalancesModel` to JSON structure for storing data in Firestore
  Map<String, dynamic> toJson() {
    return {
      'Capital': capital,
      'KesCashBalance': kesCashBalance,
      'UsdCashBalance': usdCashBalance,
      'KesBankBalance': kesBankBalance,
      'UsdBankBalance': usdBankBalance,
      'KesReceivables': kesReceivables,
      'UsdReceivables': usdReceivables,
      'KesPayables': kesPayables,
      'UsdPayables': usdPayables,
      'AccountIsSetup': accountIsSetup,
      'ProfitBalance': profitBalance,
    };
  }

  static BalancesModel empty()=>BalancesModel(capital: 0, kesCashBalance: 0, usdCashBalance: 0, kesBankBalance: 0, usdBankBalance: 0, kesReceivables: 0, usdReceivables: 0, kesPayables: 0, usdPayables: 0, accountIsSetup: false, profitBalance: 0, );
  /// Factory constructor for creating a `BalancesModel` instance from a Firestore document snapshot
  factory BalancesModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data != null) {
      return BalancesModel(
          capital: data['Capital'] ?? '',
          kesCashBalance: data['KesCashBalance'] ?? '',
          usdCashBalance: data['UsdCashBalance'] ?? '',
          kesBankBalance: data['KesBankBalance'] ?? '',
          usdBankBalance: data['UsdBankBalance'] ?? '',
          kesReceivables: data['KesReceivables'] ?? '',
          usdReceivables: data['UsdReceivables'] ?? '',
          kesPayables: data['KesPayables'] ?? '',
          usdPayables: data['UsdPayables'] ?? '',
          accountIsSetup: data['AccountIsSetup'] ?? false,
          profitBalance: data['ProfitBalance'] ?? false,
          );
    } else {
      throw Exception('Document snapshot data is null');
    }
  }
}
