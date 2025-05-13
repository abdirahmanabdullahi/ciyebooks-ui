import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'calculator_screen.dart';

class CalculatorController extends GetxController {
  final NumberFormat formatter = NumberFormat.decimalPatternDigits(
    locale: 'en_us',
    decimalDigits: 2,
  );
  // Reactive state variables
  var number1 = '0'.obs;
  var operand = ''.obs;
  var number2 = ''.obs;

  // Button tap handler
  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
    } else if (value == Btn.clr) {
      clearAll();
    } else if (value == Btn.per) {
      convertToPercentage();
    } else if (value == Btn.calculate) {
      calculate();
    } else {
      appendValue(value);
    }
  }

  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

    final double num1 = double.parse(number1.value);
    final double num2 = double.parse(number2.value);
    if (num2 == 0) {
      return;
    }

    double result = 0.0;
    switch (operand.value) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
    }

    number1.value = formatter.format(result);
    if (number1.value.endsWith('.0')) {
      number1.value = number1.value.substring(0, number1.value.length - 2);
    }
    operand.value = '';
    number2.value = '';
  }

  void convertToPercentage() {
    if (operand.isNotEmpty) return;
    if (number1.isEmpty) return;

    final number = double.parse(number1.value);
    number1.value = (number / 100).toString();
  }

  void clearAll() {
    number1.value = '';
    operand.value = '';
    number2.value = '';
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2.value = number2.value.substring(0, number2.value.length - 1);
    } else if (operand.isNotEmpty) {
      operand.value = '0';
    } else if (number1.isNotEmpty) {
      number1.value = number1.value.substring(0, number1.value.length - 1);
    }
  }

  void appendValue(String value) {
    const maxLength = 15; // Maximum number length including decimal point

    // Check if total length of the current number exceeds the limit
    if (operand.value.isEmpty) {
      // For number1
      if (number1.value.length >= maxLength && value != Btn.dot) return;
    } else {
      // For number2
      if (number2.value.length >= maxLength && value != Btn.dot) return;
    }

    if (value != Btn.dot && int.tryParse(value) == null) {
      // Operand pressed
      if (operand.value.isNotEmpty && number2.value.isNotEmpty) {
        calculate();
      }
      operand.value = value;
    } else if (number1.value.isEmpty || operand.value.isEmpty) {
      // Check for valid decimal input for number1
      if (value == Btn.dot && number1.value.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.value.isEmpty || number1.value == Btn.n0)) {
        value = '0.';
      }
      number1.value += value;
    } else {
      // Check for valid decimal input for number2
      if (value == Btn.dot && number2.value.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.value.isEmpty || number2.value == Btn.n0)) {
        value = '0.';
      }
      number2.value += value;
    }
  }
}

String formatNumber(String value) {
  if (value.isEmpty) return "";
  final number = double.tryParse(value);
  if (number == null) return value; // Handle invalid input gracefully
  return NumberFormat("#,##0.######").format(number);
}
