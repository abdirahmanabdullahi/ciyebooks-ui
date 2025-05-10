class ForexProfitCalculator {
  /// Calculates profit per sale forex transaction
  static double calculateTotalProfit(
      {required String sellingAmount, required String sellingRate, required String sellingTotal, required String currencyStockTotalCost, required String currencyStockAmount}) {
    final revenue = double.parse(sellingTotal.replaceAll(',', ''));
    final costRate = double.parse(currencyStockTotalCost.replaceAll(',', '')) / double.parse(currencyStockAmount.replaceAll(',', ''));
    final double cost = double.parse(sellingAmount.replaceAll(',', '')) * costRate;

    ///Profit
    final profit = revenue - cost;

    return profit;
  }

  static double cost({required String sellingAmount, required String currencyStockTotalCost, required String currencyStockAmount}) {
    final costRate = double.parse(currencyStockTotalCost.replaceAll(',', '')) / double.parse(currencyStockAmount.replaceAll(',', ''));

    final cost = double.parse(sellingAmount.replaceAll(',', '')) * costRate;
    return cost;
  }
}
