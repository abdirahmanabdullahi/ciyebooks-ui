import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../utils/constants/colors.dart';
import 'calculator_controller.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    final CalculatorController controller = Get.put(CalculatorController());
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Output display
        Obx(
          () {
            String display = "${formatNumber(controller.number1.value)} ${controller.operand.value} ${formatNumber(controller.number2.value)}";
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: SizedBox(
                height: 100,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(backgroundColor: AppColors.quinary),
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: num.parse(display.replaceAll(',', '')).toString()));
                      },
                      icon: Icon(
                        Icons.copy,
                        color: Colors.black38,
                      ),
                    ),
                    Row(


                      children: [

                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              reverse: true,
                              child: Text(
                                display,
                                style: TextStyle(
                                  color: AppColors.prettyDark,
                                  fontSize: display.length > 14
                                      ? 25
                                      : display.length > 30
                                          ? 20
                                          : 35,
                                  fontWeight: display.length > 14 ? FontWeight.w400 : FontWeight.w600,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Divider(
          color: Colors.grey.shade500,
          // indent: 20,
          // endIndent: 20,
        ),
        // Buttons
        Wrap(
          // spacing: 3,
          // runSpacing: 3,
          children: Btn.buttonValues
              .map(
                (value) => SizedBox(
                  width: value == Btn.calculate ? screenWidth / 2.5 : screenWidth / 5,
                  height: 70,
                  child: _buildButton(value, controller),
                ),
              )
              .toList(),
        ),
        // Gap(AppSizes.defaultSpace)
      ],
    );
  }

  Widget _buildButton(String value, CalculatorController controller) {
    Future<void> vibrate() async {
      await SystemChannels.platform.invokeMethod<void>(
        'HapticFeedback.vibrate',
        'HapticFeedbackType.lightImpact',
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: 2,
        color: _getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.quinary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: () {
            vibrate();
            controller.onBtnTap(value);
          },
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: [
                  '%',
                  '×',
                  '+',
                  '-',
                  '÷',
                  '=',
                  'D',
                  'C',
                ].contains(value)
                    ? AppColors.quinary
                    : AppColors.prettyDark,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBtnColor(String value) {
    return [
      Btn.del,
      Btn.clr,
      Btn.per,
      Btn.multiply,
      Btn.add,
      Btn.subtract,
      Btn.divide,
      Btn.calculate,
    ].contains(value)
        ? AppColors.prettyBlue
        : AppColors.quinary;
  }
}

class Btn {
  static const String del = "D";
  static const String clr = "C";
  static const String per = "%";
  static const String multiply = "×";
  static const String divide = "÷";
  static const String add = "+";
  static const String subtract = "-";
  static const String calculate = "=";
  static const String dot = ".";

  static const String n0 = "0";
  static const String n1 = "1";
  static const String n2 = "2";
  static const String n3 = "3";
  static const String n4 = "4";
  static const String n5 = "5";
  static const String n6 = "6";
  static const String n7 = "7";
  static const String n8 = "8";
  static const String n9 = "9";

  static const List<String> buttonValues = [
    del,
    clr,
    per,
    multiply,
    n7,
    n8,
    n9,
    divide,
    n4,
    n5,
    n6,
    subtract,
    n1,
    n2,
    n3,
    add,
    n0,
    dot,
    calculate,
  ];
}
