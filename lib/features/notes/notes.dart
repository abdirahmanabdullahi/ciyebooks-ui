
import 'package:ciyebooks/features/notes/widgets/add_notes_bottom_sheet.dart';
import 'package:ciyebooks/features/notes/widgets/notes_tile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utils/constants/colors.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( appBar: AppBar(
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
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
                      Gap(65),
                      IconButton(
                        onPressed: () {showDatePicker(context: context, firstDate: DateTime(0), lastDate: DateTime(34000));},
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
                                    AddNotesBottomSheet(),
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
                                ' New note',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.quinary),
                              ),
                            ],
                          ),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: SingleChildScrollView(physics: ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NotesTile(
                        title: 'Company meeting',
                        status: false,
                      ),
                      NotesTile(
                        title: 'Company meeting',
                        description:
                            'The meeting with the shareholders about the future'
                            ' of the company',
                        status: true,
                      ),
                      NotesTile(
                        title: 'Hire secretary',
                        description:
                            'Call the recruitment company for a temp to fill '
                            'the position of secretary for the time being',
                        status: false,
                      ),
                      NotesTile(
                        title: 'Company meeting',
                        description:
                            'The meeting with the shareholders about the future'
                            ' of the company',
                        status: false,
                      ),
                      NotesTile(
                        title: 'Hire secretary',
                        description:
                            'Call the recruitment company for a temp to fill '
                            'the position of secretary for the time being',
                        status: false,
                      ),
                      NotesTile(
                        title: 'Company meeting',
                        description:
                            'The meeting with the shareholders about the future'
                            ' of the company',
                        status: false,
                      ),
                      NotesTile(
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
