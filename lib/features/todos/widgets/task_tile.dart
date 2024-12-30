import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../common/styles/custom_container.dart';
import '../../../utils/constants/colors.dart';
class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.priority,
    required this.title,
    this.description, required, required this.status ,
  });
  final Color priority;
  final String title;final bool status;final String? description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: CustomContainer(
        darkColor: priority,
        width: double.infinity,
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 6.0,
          ),
          child: CustomContainer(
            borderRadius: 0,
            width: double.infinity,
            darkColor: AppColors.quinary,
            padding: EdgeInsets.zero,
            child: ListTile(
              // dense: true,
              // isThreeLine: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
              title: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .apply(color: Colors.black),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  description != null ?Gap(6):Gap(0),
                  description != null?Text(
                      description!,
                      style: Theme.of(context).textTheme.labelMedium):SizedBox(),

                  Gap(6),
                  SizedBox(height: 0, child: Divider()), Gap(6),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              size: 20,
                              Icons.schedule_outlined,
                              color: Colors.black26,
                            ),
                            Gap(10),
                            Text(
                              '10 July  12:30 pm',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 26,
                          child: Transform.scale(
                            scale: 1.4,
                            child: Checkbox(value: status, onChanged: (value) {}),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Gap(10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}