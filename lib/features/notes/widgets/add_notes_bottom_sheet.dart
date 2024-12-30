import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class AddNotesBottomSheet extends StatelessWidget {
  const AddNotesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'New note',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Close Button

              const SizedBox(height: 16),
              // Add Task Input Field
              const Text(
                'Add note title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
              TextField(
                decoration: InputDecoration(
                  // labelText: 'Add task description',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 8),
              Row(mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime:
                                const TimeOfDay(hour: 10, minute: 47),
                            builder: (BuildContext context, Widget? child) {
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              );
                            },
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Time",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Material(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            showDatePicker(
                                initialDatePickerMode: DatePickerMode.day,
                                context: context,
                                firstDate: DateTime(0),
                                lastDate: DateTime(3100));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Date",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 8),

              const Text(
                'Add note description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
              TextField(
                minLines: 3,
                maxLines: 3,
                decoration: InputDecoration(
                  // labelText: 'Add task description',
                  border: OutlineInputBorder(),
                ),
              ),
              Gap(AppSizes.defaultSpace),
              // Add Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {Get.back();
                    // Handle add task action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  label: const Text(
                    'Add note',
                    style: TextStyle(
                      color: AppColors.quinary,
                    ),
                  ),
                ),
              ),
              Gap(70)
            ],
          ),
        ),
      ],
    );
  }
}

