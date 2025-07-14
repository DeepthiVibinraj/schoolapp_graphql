import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_parent_app/core/constants/constants.dart';
import 'package:school_parent_app/pages/SideMenu/side_menu_drawer.dart';
import 'package:school_parent_app/pages/TimeTable/controllers/timetable_controller.dart';
import 'package:school_parent_app/utils/app_routes.dart';

class TimetableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final String className = Get.arguments ?? 'unknown class';
    final timetableController = Get.put(TimetableController(className));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable'),
        backgroundColor: colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Get.toNamed(AppRoutes.parent_dashboard_screen);
            },
          )
        ],
      ),
      drawer: SideMenuDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Class: $className',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Obx(() {
            if (timetableController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final timetable = timetableController.timetable.value;

            if (timetable == null) {
              return const Center(child: Text('No timetable data found.'));
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Table(
                    border: TableBorder.all(color: colorScheme.tertiary),
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    children: [
                      // Header Row
                      TableRow(
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1)),
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Day',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ...List.generate(8, (index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Period ${index + 1}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }),
                        ],
                      ),
                      // Data Rows
                      ...timetable.schedule.map((entry) {
                        final day = entry.day;
                        final periods = entry.periods;

                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                day,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ...periods.map((subject) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  subject.isEmpty ? '-' : subject,
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
