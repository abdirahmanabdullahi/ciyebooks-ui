import 'package:flutter/cupertino.dart';


class PeriodSelector extends StatelessWidget {
  const PeriodSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final dark = HelperFunctions.isDarkMode(context);
    return Center(
      child: CupertinoSlidingSegmentedControl(
          // thumbColor: AppColors.prettyDark,
          // backgroundColor: AppColors.quinary,
          // // backgroundColor: dark ? AppColors.grey : AppColors.grey,
          groupValue: 1,
          children: const {
            0: Text('Day'),
            1: Text('Month'),
            2: Text('Year'),
            3: Text('All'),
            4: Text('Custom'),
          },
          onValueChanged: (value) {}),
    );
  }
}
