import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import 'controller.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    final CalculatorController controller = Get.put(CalculatorController());

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 26.0, 0, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Output display
          Obx(
            () {
              String display = "${formatNumber(controller.number1.value)} ${controller.operand.value} ${formatNumber(controller.number2.value)}";
              return Padding(
                padding: const EdgeInsets.fromLTRB( 0.0,0,20,0),
                child: Row(
                  children: [
                    Expanded(flex:2,
                        child: IconButton(
                            onPressed: () async{
                          await Clipboard.setData(ClipboardData(text: num.parse(display.replaceAll(',', '')).toString()));

                        }, icon: Icon(Icons.copy,color: AppColors.prettyDark,))),
                    Expanded(
                      flex: 10,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Text(
                          (display.isEmpty || display == '∞') ? '0.0' : display,
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
                  ],
                ),
              );
            },
          ),
          Divider(
            color: Colors.grey.shade500,
            indent: 20,
            endIndent: 20,
          ),
          // Buttons
          Wrap(
            children: Btn.buttonValues
                .map(
                  (value) => SizedBox(
                    width: value == Btn.calculate ? 160 : 80,
                    height: 65,
                    child: _buildButton(value, controller),
                  ),
                )
                .toList(),
          ),
          // Gap(AppSizes.defaultSpace)
        ],
      ),
    );
  }

  Widget _buildButton(String value, CalculatorController controller) {    Future<void> vibrate() async {
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
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: ()  {vibrate();
            controller.onBtnTap(value);},
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
    return [Btn.del, Btn.clr].contains(value)
        ? CupertinoColors.systemBlue
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
            Btn.calculate,
            Btn.calculate,
          ].contains(value)
            ? CupertinoColors.systemBlue
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
