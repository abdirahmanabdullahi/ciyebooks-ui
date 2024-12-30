import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../utils/constants/colors.dart';
import '../../dashboard/widgets/top_button.dart';

class ShareOrDownloadButtons extends StatelessWidget {
  const ShareOrDownloadButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          child: TopButton(
            backgroundColor: AppColors.quinary,
            iconColor: AppColors.prettyDark,
            icon: Icons.arrow_downward,
            onPressed: () {},
            heroTag: "Download",
            label: 'Download',
          ),
        ),
        Gap(30),
        TopButton(
            backgroundColor: AppColors.quinary,
            iconColor: AppColors.prettyDark,
            icon: Icons.ios_share_rounded,
            label: "Share",
            onPressed: () {},
            heroTag: "Share"),
      ],
    );
  }
}
