import 'dart:async';
import 'dart:io';

import 'package:ciyebooks/common/widgets/error_dialog.dart';
import 'package:ciyebooks/features/forex/model/forex_model.dart';
import 'package:ciyebooks/features/forex/ui/widgets/fx_transaction_success.dart';
import 'package:ciyebooks/features/stats/models/stats_model.dart';
import 'package:ciyebooks/utils/helpers/forex_profit_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../../utils/exceptions/firebase_exceptions.dart';
import '../../../../utils/exceptions/platform_exceptions.dart';
import '../../setup/models/setup_model.dart';
import '../model/new_currency_model.dart';
import '../ui/widgets/confirm_fx_transaction.dart';

class ForexController extends GetxController {
  static ForexController get instance => Get.find();
  final NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 2,
  );
  final String today = DateFormat("dd MMM yyyy ").format(DateTime.now());
  final dailyReportCreated = false.obs;

  double profit = 0;
  double cost = 0;
  final selectedTransaction = 'BUYFX'.obs;
  final counters = {}.obs;
  final selectedField = ''.obs;
  final currencyList = {}.obs;

  RxList<CurrencyModel> currencyStock = <CurrencyModel>[].obs;
  final isButtonEnabled = false.obs;
  final isLoading = false.obs;
  Rx<BalancesModel> totals = BalancesModel.empty().obs;

  ///Sort by date for the history screen

  final transactionCounter = 0.obs;

  ///Controllers
  TextEditingController forexType = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController currencyCode = TextEditingController();
  TextEditingController transactionType = TextEditingController();
  TextEditingController sellingRate = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController sellingTotal = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController currencyStockTotalCost = TextEditingController();
  TextEditingController currencyStockAmount = TextEditingController();

  /// Clear controllers after data submission
  clearController() {
    forexType.clear();
    type.clear();
    currencyCode.clear();
    transactionType.clear();
    sellingRate.clear();
    amount.clear();
    sellingTotal.clear();
    description.clear();
    currencyStockTotalCost.clear();
    currencyStockAmount.clear();
  }

  /// New currency controllers
  final newCurrencyName = TextEditingController();
  final newCurrencyCode = TextEditingController();
  final newCurrencySymbol = TextEditingController();
  final bankBalances = {}.obs;
  final cashBalances = {}.obs;

  final _db = FirebaseFirestore.instance;

  final _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  onInit() async {
    fetchTotals();
    fetchCurrencies();
    createDailyReport();

    ///Add listeners to the controllers
    sellingRate.addListener(updateButtonStatus);
    type.addListener(updateButtonStatus);
    amount.addListener(updateButtonStatus);
    sellingTotal.addListener(updateButtonStatus);

    ///Get the totals and balances

    super.onInit();
  }

  /// Get all currencies ,
  fetchCurrencies() async {
    FirebaseFirestore.instance.collection('common').doc('currencies').snapshots().listen((snapshot) {
      if (snapshot.exists && snapshot.data()!.isNotEmpty) {
        currencyList.value = snapshot.data() as Map<String, dynamic>;
      }

      // FirebaseFirestore.instance.collection('common').doc('currencies').set(currencies as Map<String,dynamic>);
    });
  }

  printCurrencies() {
    final db = FirebaseFirestore.instance;
    final commonCurrencyRef = db.collection('common').doc('currencies');

      commonCurrencyRef.set(currencies);

  }

  final currencies = {
    "USD": {"symbol": "\$", "name": "US Dollar", "symbol_native": "\$", "decimal_digits": 2, "rounding": 0, "code": "USD", "name_plural": "US dollars"},
    "USD-OLD": {"symbol": "\$", "name": "USD OLD", "symbol_native": "\$", "decimal_digits": 2, "rounding": 0, "code": "USD-OLD", "name_plural": "US dollars"},
    "USD-SMALL": {"symbol": "\$", "name": "US small bills", "symbol_native": "\$", "decimal_digits": 2, "rounding": 0, "code": "usd-small bills", "name_plural": "US dollars"},
    "CAD": {"symbol": "CA\$", "name": "Canadian Dollar", "symbol_native": "\$", "decimal_digits": 2, "rounding": 0, "code": "CAD", "name_plural": "Canadian dollars"},
    "EUR": {"symbol": "€", "name": "Euro", "symbol_native": "€", "decimal_digits": 2, "rounding": 0, "code": "EUR", "name_plural": "euros"},
    "AED": {"symbol": "AED", "name": "United Arab Emirates Dirham", "symbol_native": "د.إ.‏", "decimal_digits": 2, "rounding": 0, "code": "AED", "name_plural": "UAE dirhams"},
    "AFN": {"symbol": "Af", "name": "Afghan Afghani", "symbol_native": "؋", "decimal_digits": 0, "rounding": 0, "code": "AFN", "name_plural": "Afghan Afghanis"},
    "ALL": {"symbol": "ALL", "name": "Albanian Lek", "symbol_native": "Lek", "decimal_digits": 0, "rounding": 0, "code": "ALL", "name_plural": "Albanian lekë"},
    "AMD": {"symbol": "AMD", "name": "Armenian Dram", "symbol_native": "դր.", "decimal_digits": 0, "rounding": 0, "code": "AMD", "name_plural": "Armenian drams"},
    "ARS": {"symbol": "AR\$", "name": "Argentine Peso", "symbol_native": "\$", "decimal_digits": 2, "rounding": 0, "code": "ARS", "name_plural": "Argentine pesos"},
    "AUD": {"symbol": "AU\$", "name": "Australian Dollar", "symbol_native": "\$", "decimal_digits": 2, "rounding": 0, "code": "AUD", "name_plural": "Australian dollars"},
    "AZN": {"symbol": "man.", "name": "Azerbaijani Manat", "symbol_native": "ман.", "decimal_digits": 2, "rounding": 0, "code": "AZN", "name_plural": "Azerbaijani manats"},
    "BAM": {
      "symbol": "KM",
      "name": "Bosnia-Herzegovina Convertible Mark",
      "symbol_native": "KM",
      "decimal_digits": 2,
      "rounding": 0,
      "code": "BAM",
      "name_plural": "Bosnia-Herzegovina convertible marks"
    },
    "BDT": {"symbol": "Tk", "name": "Bangladeshi Taka", "symbol_native": "৳", "decimal_digits": 2, "rounding": 0, "code": "BDT", "name_plural": "Bangladeshi takas"},
    "BGN": {"symbol": "BGN", "name": "Bulgarian Lev", "symbol_native": "лв.", "decimal_digits": 2, "rounding": 0, "code": "BGN", "name_plural": "Bulgarian leva"},
    "BHD": {"symbol": "BD", "name": "Bahraini Dinar", "symbol_native": "د.ب.‏", "decimal_digits": 3, "rounding": 0, "code": "BHD", "name_plural": "Bahraini dinars"},
    "BIF": {"symbol": "FBu", "name": "Burundian Franc", "symbol_native": "FBu", "decimal_digits": 0, "rounding": 0, "code": "BIF", "name_plural": "Burundian francs"},
    "BND": {"symbol": "BN\$", "name": "Brunei Dollar", "symbol_native": "\$", "decimal_digits": 2, "rounding": 0, "code": "BND", "name_plural": "Brunei dollars"},
    "BOB": {"symbol": "Bs", "name": "Bolivian Boliviano", "symbol_native": "Bs", "decimal_digits": 2, "rounding": 0, "code": "BOB", "name_plural": "Bolivian bolivianos"},
    "BRL": {"symbol": "R\$", "name": "Brazilian Real", "symbol_native": "R\$", "decimal_digits": 2, "rounding": 0, "code": "BRL", "name_plural": "Brazilian reals"},
    "BWP": {"symbol": "BWP", "name": "Botswanan Pula", "symbol_native": "P", "decimal_digits": 2, "rounding": 0, "code": "BWP", "name_plural": "Botswanan pulas"},
    "BYN": {"symbol": "Br", "name": "Belarusian Ruble", "symbol_native": "руб.", "decimal_digits": 2, "rounding": 0, "code": "BYN", "name_plural": "Belarusian rubles"},
    "BZD": {"symbol": "BZ\$", "name": "Belize Dollar", "symbol_native": "\$", "decimal_digits": 2, "rounding": 0, "code": "BZD", "name_plural": "Belize dollars"},
    "CDF": {"symbol": "CDF", "name": "Congolese Franc", "symbol_native": "FrCD", "decimal_digits": 2, "rounding": 0, "code": "CDF", "name_plural": "Congolese francs"},
    "CHF": {"symbol": "CHF", "name": "Swiss Franc", "symbol_native": "CHF", "decimal_digits": 2, "rounding": 0.05, "code": "CHF", "name_plural": "Swiss francs"},
    "CLP": {"symbol": "CL\$", "name": "Chilean Peso", "symbol_native": "\$", "decimal_digits": 0, "rounding": 0, "code": "CLP", "name_plural": "Chilean pesos"},
    "CNY": {"symbol": "CN¥", "name": "Chinese Yuan", "symbol_native": "CN¥", "decimal_digits": 2, "rounding": 0, "code": "CNY", "name_plural": "Chinese yuan"},
    "COP": {"symbol": "CO\$", "name": "Colombian Peso", "symbol_native": "\$", "decimal_digits": 0, "rounding": 0, "code": "COP", "name_plural": "Colombian pesos"},
    "CRC": {"symbol": "₡", "name": "Costa Rican Colón", "symbol_native": "₡", "decimal_digits": 0, "rounding": 0, "code": "CRC", "name_plural": "Costa Rican colóns"},
    "CVE": {"symbol": "CV\$", "name": "Cape Verdean Escudo", "symbol_native": "CV\$", "decimal_digits": 2, "rounding": 0, "code": "CVE", "name_plural": "Cape Verdean escudos"},
    "CZK": {"symbol": "Kč", "name": "Czech Republic Koruna", "symbol_native": "Kč", "decimal_digits": 2, "rounding": 0, "code": "CZK", "name_plural": "Czech Republic korunas"},
    "DJF": {"symbol": "Fdj", "name": "Djiboutian Franc", "symbol_native": "Fdj", "decimal_digits": 0, "rounding": 0, "code": "DJF", "name_plural": "Djiboutian francs"},
    "DKK": {"symbol": "Dkr", "name": "Danish Krone", "symbol_native": "kr", "decimal_digits": 2, "rounding": 0, "code": "DKK", "name_plural": "Danish kroner"},
    "DOP": {"symbol": "RD\$", "name": "Dominican Peso", "symbol_native": "RD\$", "decimal_digits": 2, "rounding": 0, "code": "DOP", "name_plural": "Dominican pesos"},
    "DZD": {"symbol": "DA", "name": "Algerian Dinar", "symbol_native": "د.ج.‏", "decimal_digits": 2, "rounding": 0, "code": "DZD", "name_plural": "Algerian dinars"},
    "EEK": {"symbol": "Ekr", "name": "Estonian Kroon", "symbol_native": "kr", "decimal_digits": 2, "rounding": 0, "code": "EEK", "name_plural": "Estonian kroons"},
    "EGP": {"symbol": "EGP", "name": "Egyptian Pound", "symbol_native": "ج.م.‏", "decimal_digits": 2, "rounding": 0, "code": "EGP", "name_plural": "Egyptian pounds"},
    "ERN": {"symbol": "Nfk", "name": "Eritrean Nakfa", "symbol_native": "Nfk", "decimal_digits": 2, "rounding": 0, "code": "ERN", "name_plural": "Eritrean nakfas"},
    "ETB": {"symbol": "Br", "name": "Ethiopian Birr", "symbol_native": "Br", "decimal_digits": 2, "rounding": 0, "code": "ETB", "name_plural": "Ethiopian birrs"},
    "GBP": {"symbol": "£", "name": "British Pound Sterling", "symbol_native": "£", "decimal_digits": 2, "rounding": 0, "code": "GBP", "name_plural": "British pounds sterling"},
    "GEL": {"symbol": "GEL", "name": "Georgian Lari", "symbol_native": "GEL", "decimal_digits": 2, "rounding": 0, "code": "GEL", "name_plural": "Georgian laris"},
    "GHS": {"symbol": "GH₵", "name": "Ghanaian Cedi", "symbol_native": "GH₵", "decimal_digits": 2, "rounding": 0, "code": "GHS", "name_plural": "Ghanaian cedis"},
    "GNF": {"symbol": "FG", "name": "Guinean Franc", "symbol_native": "FG", "decimal_digits": 0, "rounding": 0, "code": "GNF", "name_plural": "Guinean francs"},
    "GTQ": {"symbol": "GTQ", "name": "Guatemalan Quetzal", "symbol_native": "Q", "decimal_digits": 2, "rounding": 0, "code": "GTQ", "name_plural": "Guatemalan quetzals"},
    "HKD": {"symbol": "HK\$", "name": "Hong Kong Dollar", "symbol_native": "\$", "decimal_digits": 2, "rounding": 0, "code": "HKD", "name_plural": "Hong Kong dollars"},
    "HNL": {"symbol": "HNL", "name": "Honduran Lempira", "symbol_native": "L", "decimal_digits": 2, "rounding": 0, "code": "HNL", "name_plural": "Honduran lempiras"},
    "HRK": {"symbol": "kn", "name": "Croatian Kuna", "symbol_native": "kn", "decimal_digits": 2, "rounding": 0, "code": "HRK", "name_plural": "Croatian kunas"},
    "HUF": {"symbol": "Ft", "name": "Hungarian Forint", "symbol_native": "Ft", "decimal_digits": 0, "rounding": 0, "code": "HUF", "name_plural": "Hungarian forints"},
    "IDR": {"symbol": "Rp", "name": "Indonesian Rupiah", "symbol_native": "Rp", "decimal_digits": 0, "rounding": 0, "code": "IDR", "name_plural": "Indonesian rupiahs"},
    "ILS": {"symbol": "₪", "name": "Israeli New Sheqel", "symbol_native": "₪", "decimal_digits": 2, "rounding": 0, "code": "ILS", "name_plural": "Israeli new sheqels"},
    "INR": {"symbol": "Rs", "name": "Indian Rupee", "symbol_native": "টকা", "decimal_digits": 2, "rounding": 0, "code": "INR", "name_plural": "Indian rupees"},
    "IQD": {"symbol": "IQD", "name": "Iraqi Dinar", "symbol_native": "د.ع.‏", "decimal_digits": 0, "rounding": 0, "code": "IQD", "name_plural": "Iraqi dinars"},
    "IRR": {"symbol": "IRR", "name": "Iranian Rial", "symbol_native": "﷼", "decimal_digits": 0, "rounding": 0, "code": "IRR", "name_plural": "Iranian rials"},
    "ISK": {"symbol": "Ikr", "name": "Icelandic Króna", "symbol_native": "kr", "decimal_digits": 0, "rounding": 0, "code": "ISK", "name_plural": "Icelandic krónur"},
    "JMD": {"symbol": "J\$", "name": "Jamaican Dollar", "symbol_native": "\$", "decimal_digits": 2, "rounding": 0, "code": "JMD", "name_plural": "Jamaican dollars"},
    "JOD": {"symbol": "JD", "name": "Jordanian Dinar", "symbol_native": "د.أ.‏", "decimal_digits": 3, "rounding": 0, "code": "JOD", "name_plural": "Jordanian dinars"},
    "JPY": {"symbol": "¥", "name": "Japanese Yen", "symbol_native": "￥", "decimal_digits": 0, "rounding": 0, "code": "JPY", "name_plural": "Japanese yen"},
    "KES": {"symbol": "Ksh", "name": "Kenyan Shilling", "symbol_native": "Ksh", "decimal_digits": 2, "rounding": 0, "code": "KES", "name_plural": "Kenyan shillings"},
    "KHR": {"symbol": "KHR", "name": "Cambodian Riel", "symbol_native": "៛", "decimal_digits": 2, "rounding": 0, "code": "KHR", "name_plural": "Cambodian riels"},
    "KMF": {"symbol": "CF", "name": "Comorian Franc", "symbol_native": "FC", "decimal_digits": 0, "rounding": 0, "code": "KMF", "name_plural": "Comorian francs"},
    "KRW": {"symbol": "₩", "name": "South Korean Won", "symbol_native": "₩", "decimal_digits": 0, "rounding": 0, "code": "KRW", "name_plural": "South Korean won"},
    "KWD": {"symbol": "KD", "name": "Kuwaiti Dinar", "symbol_native": "د.ك.‏", "decimal_digits": 3, "rounding": 0, "code": "KWD", "name_plural": "Kuwaiti dinars"},
    "KZT": {"symbol": "KZT", "name": "Kazakhstani Tenge", "symbol_native": "тңг.", "decimal_digits": 2, "rounding": 0, "code": "KZT", "name_plural": "Kazakhstani tenges"},
    "LBP": {"symbol": "L.L.", "name": "Lebanese Pound", "symbol_native": "ل.ل.‏", "decimal_digits": 0, "rounding": 0, "code": "LBP", "name_plural": "Lebanese pounds"},
    "LKR": {"symbol": "SLRs", "name": "Sri Lankan Rupee", "symbol_native": "SL Re", "decimal_digits": 2, "rounding": 0, "code": "LKR", "name_plural": "Sri Lankan rupees"},
    "LTL": {"symbol": "Lt", "name": "Lithuanian Litas", "symbol_native": "Lt", "decimal_digits": 2, "rounding": 0, "code": "LTL", "name_plural": "Lithuanian litai"},
    "LVL": {"symbol": "Ls", "name": "Latvian Lats", "symbol_native": "Ls", "decimal_digits": 2, "rounding": 0, "code": "LVL", "name_plural": "Latvian lati"},
    "LYD": {"symbol": "LD", "name": "Libyan Dinar", "symbol_native": "د.ل.‏", "decimal_digits": 3, "rounding": 0, "code": "LYD", "name_plural": "Libyan dinars"},
    "MAD": {"symbol": "MAD", "name": "Moroccan Dirham", "symbol_native": "د.م.‏", "decimal_digits": 2, "rounding": 0, "code": "MAD", "name_plural": "Moroccan dirhams"},
    "MDL": {"symbol": "MDL", "name": "Moldovan Leu", "symbol_native": "MDL", "decimal_digits": 2, "rounding": 0, "code": "MDL", "name_plural": "Moldovan lei"},
    "MGA": {"symbol": "MGA", "name": "Malagasy Ariary", "symbol_native": "MGA", "decimal_digits": 0, "rounding": 0, "code": "MGA", "name_plural": "Malagasy Ariaries"},
    "MKD": {"symbol": "MKD", "name": "Macedonian Denar", "symbol_native": "MKD", "decimal_digits": 2, "rounding": 0, "code": "MKD", "name_plural": "Macedonian denari"},
    "MMK": {"symbol": "MMK", "name": "Myanma Kyat", "symbol_native": "K", "decimal_digits": 0, "rounding": 0, "code": "MMK", "name_plural": "Myanma kyats"},
    "MOP": {"symbol": "MOP\$", "name": "Macanese Pataca", "symbol_native": "MOP\$", "decimal_digits": 2, "rounding": 0, "code": "MOP", "name_plural": "Macanese patacas"},
    "MUR": {"symbol": "MURs", "name": "Mauritian Rupee", "symbol_native": "MURs", "decimal_digits": 0, "rounding": 0, "code": "MUR", "name_plural": "Mauritian rupees"},
    "MXN": {"symbol": "MX\$", "name": "Mexican Peso", "symbol_native": "\$", "decimal_digits": 2, "rounding": 0, "code": "MXN", "name_plural": "Mexican pesos"},
    "MYR": {"symbol": "RM", "name": "Malaysian Ringgit", "symbol_native": "RM", "decimal_digits": 2, "rounding": 0, "code": "MYR", "name_plural": "Malaysian ringgits"},
    "MZN": {"symbol": "MTn", "name": "Mozambican Metical", "symbol_native": "MTn", "decimal_digits": 2, "rounding": 0, "code": "MZN", "name_plural": "Mozambican meticals"},
    "NAD": {"symbol": "N\$", "name": "Namibian Dollar", "symbol_native": "N\$", "decimal_digits": 2, "rounding": 0, "code": "NAD", "name_plural": "Namibian dollars"},
    "NGN": {"symbol": "₦", "name": "Nigerian Naira", "symbol_native": "₦", "decimal_digits": 2, "rounding": 0, "code": "NGN", "name_plural": "Nigerian nairas"},
    "NIO": {"symbol": "C\$", "name": "Nicaraguan Córdoba", "symbol_native": "C\$", "decimal_digits": 2, "rounding": 0, "code": "NIO", "name_plural": "Nicaraguan córdobas"},
    "NOK": {"symbol": "Nkr", "name": "Norwegian Krone", "symbol_native": "kr", "decimal_digits": 2, "rounding": 0, "code": "NOK", "name_plural": "Norwegian kroner"},
    "NPR": {"symbol": "NPRs", "name": "Nepalese Rupee", "symbol_native": "नेरू", "decimal_digits": 2, "rounding": 0, "code": "NPR", "name_plural": "Nepalese rupees"},
    "NZD": {"symbol": "NZ\$", "name": "New Zealand Dollar", "symbol_native": "\$", "decimal_digits": 2, "rounding": 0, "code": "NZD", "name_plural": "New Zealand dollars"},
    "OMR": {"symbol": "OMR", "name": "Omani Rial", "symbol_native": "ر.ع.‏", "decimal_digits": 3, "rounding": 0, "code": "OMR", "name_plural": "Omani rials"},
    "PAB": {"symbol": "B/.", "name": "Panamanian Balboa", "symbol_native": "B/.", "decimal_digits": 2, "rounding": 0, "code": "PAB", "name_plural": "Panamanian balboas"},
    "PEN": {"symbol": "S/.", "name": "Peruvian Nuevo Sol", "symbol_native": "S/.", "decimal_digits": 2, "rounding": 0, "code": "PEN", "name_plural": "Peruvian nuevos soles"},
    "PHP": {"symbol": "₱", "name": "Philippine Peso", "symbol_native": "₱", "decimal_digits": 2, "rounding": 0, "code": "PHP", "name_plural": "Philippine pesos"},
    "PKR": {"symbol": "PKRs", "name": "Pakistani Rupee", "symbol_native": "₨", "decimal_digits": 0, "rounding": 0, "code": "PKR", "name_plural": "Pakistani rupees"},
    "PLN": {"symbol": "zł", "name": "Polish Zloty", "symbol_native": "zł", "decimal_digits": 2, "rounding": 0, "code": "PLN", "name_plural": "Polish zlotys"},
    "PYG": {"symbol": "₲", "name": "Paraguayan Guarani", "symbol_native": "₲", "decimal_digits": 0, "rounding": 0, "code": "PYG", "name_plural": "Paraguayan guaranis"},
    "QAR": {"symbol": "QR", "name": "Qatari Rial", "symbol_native": "ر.ق.‏", "decimal_digits": 2, "rounding": 0, "code": "QAR", "name_plural": "Qatari rials"},
    "RON": {"symbol": "RON", "name": "Romanian Leu", "symbol_native": "RON", "decimal_digits": 2, "rounding": 0, "code": "RON", "name_plural": "Romanian lei"},
    "RSD": {"symbol": "din.", "name": "Serbian Dinar", "symbol_native": "дин.", "decimal_digits": 0, "rounding": 0, "code": "RSD", "name_plural": "Serbian dinars"},
    "RUB": {"symbol": "RUB", "name": "Russian Ruble", "symbol_native": "₽.", "decimal_digits": 2, "rounding": 0, "code": "RUB", "name_plural": "Russian rubles"},
    "RWF": {"symbol": "RWF", "name": "Rwandan Franc", "symbol_native": "FR", "decimal_digits": 0, "rounding": 0, "code": "RWF", "name_plural": "Rwandan francs"},
    "SAR": {"symbol": "SR", "name": "Saudi Riyal", "symbol_native": "ر.س.‏", "decimal_digits": 2, "rounding": 0, "code": "SAR", "name_plural": "Saudi riyals"},
    "SDG": {"symbol": "SDG", "name": "Sudanese Pound", "symbol_native": "SDG", "decimal_digits": 2, "rounding": 0, "code": "SDG", "name_plural": "Sudanese pounds"},
    "SEK": {"symbol": "Skr", "name": "Swedish Krona", "symbol_native": "kr", "decimal_digits": 2, "rounding": 0, "code": "SEK", "name_plural": "Swedish kronor"},
    "SGD": {"symbol": "S\$", "name": "Singapore Dollar", "symbol_native": "\$", "decimal_digits": 2, "rounding": 0, "code": "SGD", "name_plural": "Singapore dollars"},
    "SOS": {"symbol": "Ssh", "name": "Somali Shilling", "symbol_native": "Ssh", "decimal_digits": 0, "rounding": 0, "code": "SOS", "name_plural": "Somali shillings"},
    "SYP": {"symbol": "SY£", "name": "Syrian Pound", "symbol_native": "ل.س.‏", "decimal_digits": 0, "rounding": 0, "code": "SYP", "name_plural": "Syrian pounds"},
    "THB": {"symbol": "฿", "name": "Thai Baht", "symbol_native": "฿", "decimal_digits": 2, "rounding": 0, "code": "THB", "name_plural": "Thai baht"},
    "TND": {"symbol": "DT", "name": "Tunisian Dinar", "symbol_native": "د.ت.‏", "decimal_digits": 3, "rounding": 0, "code": "TND", "name_plural": "Tunisian dinars"},
    "TOP": {"symbol": "T\$", "name": "Tongan Paʻanga", "symbol_native": "T\$", "decimal_digits": 2, "rounding": 0, "code": "TOP", "name_plural": "Tongan paʻanga"},
    "TRY": {"symbol": "TL", "name": "Turkish Lira", "symbol_native": "TL", "decimal_digits": 2, "rounding": 0, "code": "TRY", "name_plural": "Turkish Lira"},
    "TTD": {"symbol": "TT\$", "name": "Trinidad and Tobago Dollar", "symbol_native": "\$", "decimal_digits": 2, "rounding": 0, "code": "TTD", "name_plural": "Trinidad and Tobago dollars"},
    "TWD": {"symbol": "NT\$", "name": "New Taiwan Dollar", "symbol_native": "NT\$", "decimal_digits": 2, "rounding": 0, "code": "TWD", "name_plural": "New Taiwan dollars"},
    "TZS": {"symbol": "TSh", "name": "Tanzanian Shilling", "symbol_native": "TSh", "decimal_digits": 0, "rounding": 0, "code": "TZS", "name_plural": "Tanzanian shillings"},
    "UAH": {"symbol": "₴", "name": "Ukrainian Hryvnia", "symbol_native": "₴", "decimal_digits": 2, "rounding": 0, "code": "UAH", "name_plural": "Ukrainian hryvnias"},
    "UGX": {"symbol": "USh", "name": "Ugandan Shilling", "symbol_native": "USh", "decimal_digits": 0, "rounding": 0, "code": "UGX", "name_plural": "Ugandan shillings"},
    "UYU": {"symbol": "\$U", "name": "Uruguayan Peso", "symbol_native": "\$", "decimal_digits": 2, "rounding": 0, "code": "UYU", "name_plural": "Uruguayan pesos"},
    "UZS": {"symbol": "UZS", "name": "Uzbekistan Som", "symbol_native": "UZS", "decimal_digits": 0, "rounding": 0, "code": "UZS", "name_plural": "Uzbekistan som"},
    "VEF": {"symbol": "Bs.F.", "name": "Venezuelan Bolívar", "symbol_native": "Bs.F.", "decimal_digits": 2, "rounding": 0, "code": "VEF", "name_plural": "Venezuelan bolívars"},
    "VND": {"symbol": "₫", "name": "Vietnamese Dong", "symbol_native": "₫", "decimal_digits": 0, "rounding": 0, "code": "VND", "name_plural": "Vietnamese dong"},
    "XAF": {"symbol": "FCFA", "name": "CFA Franc BEAC", "symbol_native": "FCFA", "decimal_digits": 0, "rounding": 0, "code": "XAF", "name_plural": "CFA francs BEAC"},
    "XOF": {"symbol": "CFA", "name": "CFA Franc BCEAO", "symbol_native": "CFA", "decimal_digits": 0, "rounding": 0, "code": "XOF", "name_plural": "CFA francs BCEAO"},
    "YER": {"symbol": "YR", "name": "Yemeni Rial", "symbol_native": "ر.ي.‏", "decimal_digits": 0, "rounding": 0, "code": "YER", "name_plural": "Yemeni rials"},
    "ZAR": {"symbol": "R", "name": "South African Rand", "symbol_native": "R", "decimal_digits": 2, "rounding": 0, "code": "ZAR", "name_plural": "South African rand"},
    "ZMK": {"symbol": "ZK", "name": "Zambian Kwacha", "symbol_native": "ZK", "decimal_digits": 0, "rounding": 0, "code": "ZMK", "name_plural": "Zambian kwachas"},
    "ZWL": {"symbol": "ZWL\$", "name": "Zimbabwean Dollar", "symbol_native": "ZWL\$", "decimal_digits": 0, "rounding": 0, "code": "ZWL", "name_plural": "Zimbabwean Dollar"}
  };


  updateNewCurrencyButton() {
    isButtonEnabled.value = newCurrencyCode.text.isNotEmpty;
  }

  addNewCurrency(BuildContext context) async {
    isLoading.value = true;
    try {
      // Create new currency
      final newCurrency = CurrencyModel(currencyName: newCurrencyName.text.trim(), amount: 0, totalCost: 0, symbol: newCurrencySymbol.text.trim(), currencyCode: newCurrencyCode.text.trim());

      await _db.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('currencyStock').doc(newCurrencyCode.text.trim().toUpperCase()).set(newCurrency.toJson()).then((_) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        isLoading.value = false;
      });
    } catch (e) {
      isLoading.value = false;
      throw e.toString();
    }
  }

  ///Calculate the fields
  onAmountChanged(String? value) {
    sellingTotal.text = formatter.format(((double.tryParse(amount.text.trim().replaceAll(',', ',').removeAllWhitespace) ?? 0.0) * (double.tryParse(sellingRate.text.trim()) ?? 0.0)));
  }

  onTotalChanged(String? value) {
    if ((double.tryParse(sellingRate.text.trim().replaceAll(',', '').removeAllWhitespace) ?? 0.0) <= 0) {
      return;
    }

    amount.text = formatter.format(((double.tryParse(sellingTotal.text.trim()) ?? 0.0) / (double.tryParse(sellingRate.text.trim()) ?? 0.0)));
  }

  /// Update whether the submit button is enabled or disabled
  updateButtonStatus() {
    isButtonEnabled.value = sellingRate.text.isNotEmpty &&
        amount.text.isNotEmpty &&
        type.text.isNotEmpty &&
        sellingTotal.text.isNotEmpty &&
        ((num.tryParse(sellingRate.text) ?? 0) > 0 && (num.tryParse(amount.text) ?? 0) > 0 && (num.tryParse(sellingTotal.text.replaceAll(',', '')) ?? 0) > 0);
  }

  fetchTotals() async {
    FirebaseFirestore.instance.collection('users').doc(_uid).collection('currencyStock').snapshots().listen((querySnapshot) {
      currencyStock.value = querySnapshot.docs.map((doc) {
        return CurrencyModel.fromJson(doc.data());
      }).toList();
    });

    FirebaseFirestore.instance.collection('users').doc(_uid).collection('setup').doc('balances').snapshots().listen((snapshot) {
      if (snapshot.exists) {
        totals.value = BalancesModel.fromJson(snapshot.data()!);
        bankBalances.value = totals.value.bankBalances;
        cashBalances.value = totals.value.cashBalances;
        counters.value = totals.value.transactionCounters;
        transactionCounter.value = counters[selectedTransaction.value];
      }
    });
  }

  ///Check if you have enough base currency to buy a foreign currency
  checkBalances(BuildContext context) {
    final availableForeignCurrencyBalance = double.parse(currencyStockAmount.text.trim());
    final availableBankAmount = double.parse(bankBalances['KES'].toString());
    final availableCashAmount = double.parse(cashBalances['KES'].toString());
    final requestedAmount = double.parse(sellingTotal.text.trim().replaceAll(',', ''));
    final requestedForeignCurrencyAmount = double.parse(amount.text.trim().replaceAll(',', ''));

    /// Limit the user so as not to sell what they do not have.
    if (selectedTransaction.value == 'SELLFX' && availableForeignCurrencyBalance < requestedForeignCurrencyAmount) {
      showErrorDialog(
        context: context,
        errorTitle: 'Insufficient funds',
        errorText: 'You do not have enough ${currencyCode.text.trim()} to complete this transaction.',
      );
      return;
    }

    if (selectedTransaction.value == 'BUYFX') {
      if (type.text.trim() == 'Cash' && requestedAmount > availableCashAmount) {
        showErrorDialog(
          context: context,
          errorTitle: 'Cash not enough',
          errorText: 'You only have KES ${formatter.format(availableCashAmount)} in cash. Please check your balances and try again.',
        );
        return;
      }
      if (type.text.trim() != 'Cash' && requestedAmount > availableBankAmount) {
        showErrorDialog(
          context: context,
          errorTitle: 'Balance at bank not enough',
          errorText: 'You only have KES ${formatter.format(availableCashAmount)} at bank. Please check your balances and try again.',
        );
        return;
      }
    }

    showConfirmForexTransaction(context);
  }

  checkInternetConnection(BuildContext context) async {
    isLoading.value = true;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (context.mounted) {
          createForexTransaction(context);
        }
      }
    } on SocketException catch (_) {
      isLoading.value = false;
      if (context.mounted) {
        showErrorDialog(context: context, errorTitle: 'Connection error!', errorText: 'Please check your network connection and try again.');
      }
    }
  }

  createDailyReport() async {
    final reportRef = FirebaseFirestore.instance.collection('users').doc(_uid).collection('dailyReports').doc(today);
    final snapshot = await reportRef.get();
    if (snapshot.exists) {
      dailyReportCreated.value = true;
    }
  }

  Future createForexTransaction(BuildContext context) async {
    isLoading.value = true;
    try {
      await createDailyReport();

      /// If it is a sale calculate the profit
      if (selectedTransaction.value == 'SELLFX') {
        profit = ForexProfitCalculator.calculateTotalProfit(
            sellingAmount: amount.text.trim(),
            sellingRate: sellingRate.text.trim(),
            sellingTotal: sellingTotal.text.trim(),
            currencyStockTotalCost: currencyStockTotalCost.text.trim(),
            currencyStockAmount: currencyStockAmount.text.trim());
      }
      cost = ForexProfitCalculator.cost(sellingAmount: amount.text.trim(), currencyStockTotalCost: currencyStockTotalCost.text.trim(), currencyStockAmount: currencyStockAmount.text.trim());

      /// Initialize batch
      final db = FirebaseFirestore.instance;
      final batch = db.batch();

      ///Doc references
      final counterRef = db.collection('users').doc(_uid).collection('setup').doc('balances');
      final currencyRef = db.collection('users').doc(_uid).collection('currencyStock').doc(currencyCode.text.trim().toUpperCase());
      final cashRef = db.collection('users').doc(_uid).collection('setup').doc('balances');
      final transactionRef = db.collection('users').doc(_uid).collection('transactions').doc('${selectedTransaction.value}-${counters[selectedTransaction.value]}');
      final dailyReportRef = db.collection('users').doc(_uid).collection('dailyReports').doc(today);

      final newForexTransaction = ForexModel(
        forexType: selectedTransaction.value,
        transactionType: 'forex',
        type: type.text.trim(),
        transactionId: '${selectedTransaction.value.toUpperCase()}-${counters[selectedTransaction.value]}',
        amount: double.tryParse(amount.text.trim().replaceAll(',', '')) ?? 0.0,
        dateCreated: DateTime.now(),
        // currencyName: currency.text.trim(),
        currencyCode: currencyCode.text.trim(),
        rate: double.tryParse(sellingRate.text.trim().replaceAll(',', '')) ?? 0.0,
        totalCost: double.tryParse(sellingTotal.text.trim().replaceAll(',', '')) ?? 0.0,
        revenueContributed: double.parse(profit.toStringAsFixed(3)),
      );

      ///Create Daily report
      if (!dailyReportCreated.value) {
        batch.set(dailyReportRef, DailyReportModel.empty().toJson());
      }

      ///Create payment transaction
      batch.set(transactionRef, newForexTransaction.toJson());

      ///update cash and currency balances when buying currencies
      if (selectedTransaction.value == 'BUYFX') {
        /// Update currencies at cost
        batch.update(cashRef, {'currenciesAtCost': FieldValue.increment(double.parse(sellingTotal.text.trim().replaceAll(',', '')))});

        /// Update currency amount
        batch.update(currencyRef, {"amount": FieldValue.increment(double.parse(amount.text.trim().replaceAll(',', '')))});

        ///Update total cost
        batch.update(currencyRef, {"totalCost": FieldValue.increment(double.parse(sellingTotal.text.trim().replaceAll(',', '')))});

        batch.update(
            cashRef,
            type.text.trim() == 'Bank transfer'
                ? {"cashBalances.KES": FieldValue.increment(-num.parse(sellingTotal.text.trim().replaceAll(',', '')))}
                : {"cashBalances.KES": FieldValue.increment(-num.parse(sellingTotal.text.trim().replaceAll(',', '')))});
      }

      ///update cash balance when selling currencies

      if (selectedTransaction.value == 'SELLFX') {
        /// Update currencies at cost
        batch.update(cashRef, {'currenciesAtCost': FieldValue.increment(-cost)});

        /// Update profit
        batch.update(dailyReportRef, {'dailyProfit': FieldValue.increment(profit)});

        /// Update currency amount
        batch.update(currencyRef, {"amount": FieldValue.increment(-double.parse(amount.text.trim().replaceAll(',', '')))});

        ///Update total cost
        batch.update(currencyRef, {"totalCost": FieldValue.increment(-cost)});

        batch.update(
            cashRef,
            type.text.trim() == 'Bank transfer'
                ? {"bankBalances.KES": FieldValue.increment(num.parse(sellingTotal.text.trim().replaceAll(',', '')))}
                : {"cashBalances.KES": FieldValue.increment(num.parse(sellingTotal.text.trim().replaceAll(',', '')))});
      }

      ///Update forex counter
      batch.update(counterRef, {"transactionCounters.${selectedTransaction.value}": FieldValue.increment(1)});

      await batch.commit().then((_) {
        isLoading.value = false;
        Get.snackbar(
          icon: Icon(
            Icons.cloud_done,
            color: Colors.white,
          ),
          shouldIconPulse: true,
          "Success",
          'Transaction created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        /// Show success dialog
        if (context.mounted) {
          Navigator.of(context).pop();
          showForexInfo(
              context: context,
              forexType: selectedTransaction.value,
              currency: currencyCode.text.trim(),
              transactionCode: '${selectedTransaction.value.toUpperCase()}-${counters[selectedTransaction.value]}',
              method: type.text.trim(),
              amount: amount.text.trim(),
              rate: sellingRate.text.trim(),
              totalCost: sellingTotal.text.trim(),
              date: DateTime.now());
        }
        clearController();
      });
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on TPlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      isLoading.value = false;
      throw 'Something went wrong. Please try again';
    }
  }

  /// *-----------------------------End data submission----------------------------------*
}
