import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat("#,###");

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove all non-digit characters
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');


    if (text.isEmpty) {
      return newValue.copyWith(text: '', selection: const TextSelection.collapsed(offset: 0));
    }

    // Format number with commas
    final formattedText = _formatter.format(int.parse(text));

    // Calculate new cursor position
    final cursorPosition = formattedText.length;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}