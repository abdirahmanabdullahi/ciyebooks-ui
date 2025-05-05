class ForexProfitCalculator {
  /// Calculates profit per sale forex transaction
  static double calculateTotalProfit({
    required
    double sellingAmount,
    required double sellingRate,
    required double sellingTotal,
    required double currencyStockTotalCost,
    required double currencyStockAmount,
  })
   {
    final revenue = sellingTotal;
    final costRate =   currencyStockTotalCost/currencyStockAmount;
    final cost = sellingAmount*costRate;
    final profit = revenue-cost;

    return profit;
  }
}
