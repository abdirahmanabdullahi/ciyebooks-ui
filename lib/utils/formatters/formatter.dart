import 'dart:math';

import 'package:ciyebooks/utils/formatters/text_manipulation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


class ThousandsFormatter extends TextInputFormatter {
  final bool allowFraction;
  final int decimalPlaces;
  final bool allowNegative;

  final NumberFormat _formatter;

  ThousandsFormatter({
    this.allowFraction = false,
    this.decimalPlaces = 2,
    this.allowNegative = false,
  }) : _formatter = NumberFormat('#,##0.${'#' * decimalPlaces}');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String decimalSeparator = _formatter.symbols.DECIMAL_SEP;
    return textManipulation(
      oldValue,
      newValue,
      textInputFormatter: allowFraction
          ? (allowNegative
          ? FilteringTextInputFormatter.allow(
          RegExp('[0-9-]+([$decimalSeparator])?'))
          : FilteringTextInputFormatter.allow(
          RegExp('[0-9]+([$decimalSeparator])?')))
          : (allowNegative
          ? FilteringTextInputFormatter.allow(RegExp('[0-9-]+'))
          : FilteringTextInputFormatter.digitsOnly),
      // because FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]+')), does not work
      // https://github.com/flutter/flutter/issues/21874
      formatPattern: (String filteredString) {
        if (allowNegative) {
          // filter negative sign in the middle
          // this will also remove redundant negative signs
          if ('-'.allMatches(filteredString).isNotEmpty) {
            filteredString = (filteredString.startsWith('-') ? '-' : '') +
                filteredString.replaceAll('-', '');
          }
        }

        if (filteredString.isEmpty) return '';
        num number;
        if (allowFraction) {
          String decimalDigits = filteredString;
          if (decimalSeparator != '.') {
            decimalDigits =
                filteredString.replaceFirst(RegExp(decimalSeparator), '.');
          }
          number = double.tryParse(decimalDigits) ?? 0.0;
        } else {
          number = int.tryParse(filteredString) ?? 0;
        }
        final result = _formatter.format(number);
        if (allowFraction && filteredString.endsWith(decimalSeparator)) {
          return '$result$decimalSeparator';
        }

        // Fix the -0. and similar issues
        if (allowNegative) {
          if (allowFraction) {
            if (filteredString == '-' ||
                filteredString == '-0' ||
                filteredString == '-0.') {
              return filteredString;
            }
          }
          if (filteredString == '-') {
            return filteredString;
          }
        }

        // Fix the .0 or .01 or .10 and similar issues
        if (allowFraction && filteredString.contains('.')) {
          List<String> decimalPlacesValue = filteredString.split(".");
          String decimalOnly = decimalPlacesValue[1];
          String decimalTruncated =
          decimalOnly.substring(0, min(decimalPlaces, decimalOnly.length));
          double digitsOnly = double.tryParse(decimalPlacesValue[0]) ?? 0.0;
          String result = _formatter.format(digitsOnly);
          result = '$result.$decimalTruncated';
          return result;
        }

        return result;
      },
    );
  }
}