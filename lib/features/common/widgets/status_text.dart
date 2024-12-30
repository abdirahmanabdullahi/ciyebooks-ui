import 'package:flutter/material.dart';

class StatusText extends StatelessWidget {
  const StatusText({
    super.key,
    required this.label,
    required this.color,
  });
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "Status:  ",
                  style: Theme.of(context).textTheme.labelSmall),
              TextSpan(
                  text: label,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .apply(color: color))
            ],
          ),
        ),
      ],
    );
  }
}
