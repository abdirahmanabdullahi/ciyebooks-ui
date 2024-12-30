import 'package:ciyebooks/features/todos/widgets/add_activity_popup.dart';
import 'package:ciyebooks/features/todos/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utils/constants/colors.dart';

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.quarternary,
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Correct context for drawer
          },
          icon: Icon(Icons.sort),
        ),
      ),
      backgroundColor: AppColors.quarternary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(6.0, 6, 6, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Friday",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "July 26, 2024",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Gap(75),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.calendar_today_outlined,
                            size: 32, color: AppColors.prettyDark),
                      ),
                      SizedBox(
                        height: 40,
                        width: 120,
                        child: FloatingActionButton(
                          elevation: 0,
                          onPressed: () {
                            showModalBottomSheet<dynamic>(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext bc) {
                                return Wrap(
                                  children: <Widget>[
                                    AddActivityBottomSheet(),
                                  ],
                                );
                              },
                            );
                          },
                          backgroundColor: AppColors.prettyDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(
                                Icons.add,
                                color: AppColors.quinary,
                              ),
                              Text(
                                'New task',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.quinary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(),
                  // Date selection
                  SizedBox(
                    height: 70,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        7,
                        (index) {
                          final isSelected = index == 3;
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 7.0),
                            child: Column(
                              children: [
                                Text(
                                  [
                                    "Tue",
                                    "Wed",
                                    "Thu",
                                    "Fri",
                                    "Sat",
                                    "Sun",
                                    "Mon"
                                  ][index],
                                  style: TextStyle(
                                    color:
                                        isSelected ? Colors.black : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.black
                                        : AppColors.quinary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "${23 + index}",
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.quinary
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Recent activities
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TaskTile(
                        priority: Colors.green,
                        title: 'Company meeting',
                        status: false,
                      ),
                      TaskTile(
                        priority: Colors.green,
                        title: 'Company meeting',
                        description:
                            'The meeting with the shareholders about the future'
                            ' of the company',
                        status: true,
                      ),
                      TaskTile(
                        priority: Colors.red,
                        title: 'Hire secretary',
                        description:
                            'Call the recruitment company for a temp to fill '
                            'the position of secretary for the time being',
                        status: false,
                      ),
                      TaskTile(
                        priority: Colors.blue,
                        title: 'Company meeting',
                        description:
                            'The meeting with the shareholders about the future'
                            ' of the company',
                        status: false,
                      ),
                      TaskTile(
                        priority: Colors.green,
                        title: 'Hire secretary',
                        description:
                            'Call the recruitment company for a temp to fill '
                            'the position of secretary for the time being',
                        status: false,
                      ),
                      TaskTile(
                        priority: Colors.blue,
                        title: 'Company meeting',
                        description:
                            'The meeting with the shareholders about the future'
                            ' of the company',
                        status: false,
                      ),
                      TaskTile(
                        priority: Colors.red,
                        title: 'Hire secretary',
                        description:
                            'Call the recruitment company for a temp to fill '
                            'the position of secretary for the time being',
                        status: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
