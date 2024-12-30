import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../common/styles/custom_container.dart';
import '../../../utils/constants/colors.dart';

class StatsBox extends StatelessWidget {
  const StatsBox({
    super.key,
    required this.label,
    required this.usd,
    required this.kes,
    required this.heroTag,
  });

  final String label, usd, kes, heroTag;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(border: Border.all(color: Colors.grey, width: 0.3),
      darkColor: AppColors.quinary,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 10, 10),
      child: Stack(
        children: [
          Positioned(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Positioned(
            top: 38,
            left: 10,
            child: Row(
              children: [
                Text(
                  "USD",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Gap(6),
                Text(
                  usd,
                  style: const TextStyle(
                      fontFamily: "Oswald",
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          Positioned(
            top: 80,
            left: 10,
            child: Row(
              children: [
                Text(
                  "KES",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Gap(6),
                Text(
                  kes,
                  style: const TextStyle(
                      fontFamily: "Oswald",
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 25,
              child: FloatingActionButton(
                foregroundColor: AppColors.quinary,
                heroTag: heroTag,
                backgroundColor: AppColors.quinary,
                elevation: .9,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () {},
                child: const Icon(
                  Icons.more_horiz,
                  color: AppColors.prettyDark,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
