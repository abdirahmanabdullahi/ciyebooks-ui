
import 'package:flutter/material.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.quarternary,
        automaticallyImplyLeading: true,
        leading: IconButton(

          onPressed: () {
            Scaffold.of(context).openDrawer(); // Correct context for drawer
          },
          icon: Icon(
            Icons.sort,
            color: AppColors.prettyDark,size: 30,
          ),
        ),
      ),
      backgroundColor: AppColors.quarternary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Output display
            Expanded(
              child: Obx(
                () {
                  String display =
                      "${formatNumber(controller.number1.value)} ${controller.operand.value} ${formatNumber(controller.number2.value)}";
                  return SingleChildScrollView(
                    reverse: true,
                    child: Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      child: Text(
                        display.isEmpty ? '0.0' : display,
                        style: const TextStyle(
                          color: AppColors.prettyDark,
                          fontSize: 38,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(
              color: Colors.grey.shade800,
              indent: 10,
              endIndent: 10,
            ),
            // Buttons
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : screenSize.width / 4,
                      height: screenSize.width / 5,
                      child: _buildButton(value, controller),
                    ),
                  )
                  .toList(),
            ),
            Gap(AppSizes.defaultSpace)
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String value, CalculatorController controller) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Material(
        color: _getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () => controller.onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
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
        ? Colors.orange
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate
          ].contains(value)
            ? AppColors.primary
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
