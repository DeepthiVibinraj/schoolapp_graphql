import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_admin_app/core/constants/constants.dart';
import 'package:school_admin_app/core/constants/image_constant.dart';
import 'package:school_admin_app/core/theme/size_utils.dart';
import 'package:school_admin_app/pages/Class/controllers/class_controller.dart';
import 'package:school_admin_app/pages/Events/controllers/event_controller.dart';
import 'package:school_admin_app/pages/SideMenu/side_menu_drawer.dart';
import 'package:school_admin_app/pages/Staff/controllers/staff_controller.dart';
import 'package:school_admin_app/pages/Students/controllers/student_controller.dart';
import 'package:school_admin_app/utils/app_routes.dart';

class AdminDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    StudentController studentController = Get.put(StudentController());
    StaffController staffController = Get.put(StaffController());
    ClassController classController = Get.put(ClassController());
    final EventController eventController = Get.put(EventController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "",
        ),
        backgroundColor: colorScheme.primary,
      ),
      drawer: SideMenuDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Quick Overview", style: textTheme.titleLarge),
            const SizedBox(height: 10),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard(
                      "Students",
                      studentController.students.length.toString(),
                      Icons.school,
                      Colors.blue),
                  _buildStatCard(
                      "Staffs",
                      staffController.staffs.length.toString(),
                      Icons.person,
                      Colors.green),
                  _buildStatCard(
                      "Classes",
                      classController.classes.length.toString(),
                      Icons.class_,
                      Colors.orange),
                ],
              );
            }),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickAccessButton(
                          icon: ImageConstant.students,
                          label: 'Students',
                          color: colorScheme.primary,
                          function: () {
                            Get.toNamed(AppRoutes.student_list_screen);
                          }),
                      _buildQuickAccessButton(
                          icon: ImageConstant.staff,
                          label: 'Staffs',
                          color: colorScheme.primary,
                          function: () {
                            Get.toNamed(AppRoutes.staff_list_screen);
                          }),
                      _buildQuickAccessButton(
                          icon: ImageConstant.classes,
                          label: 'Classes',
                          color: colorScheme.primary,
                          function: () {
                            Get.toNamed(AppRoutes.class_list_screen);
                          }),
                      // _buildQuickAccessButton(
                      //     icon: Icons.fact_check,
                      //     label: 'Attendance',
                      //     color: colorScheme.primary,
                      //     function: () {}),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: getPadding(all: defaultPadding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickAccessButton(
                          icon: ImageConstant.subject,
                          label: 'Subjects',
                          color: colorScheme.primary,
                          function: () {
                            Get.toNamed(AppRoutes.subject_list_screen);
                          }),
                      _buildQuickAccessButton(
                          icon: ImageConstant.timetable,
                          label: 'TimeTable',
                          color: colorScheme.primary,
                          function: () {
                            Get.toNamed(AppRoutes.timetable_list_screen);
                          }),
                      _buildQuickAccessButton(
                          icon: ImageConstant.homework,
                          label: 'Homework',
                          color: colorScheme.primary,
                          function: () {
                            Get.toNamed(AppRoutes.homework_list_screen);
                          }),
                      // _buildQuickAccessButton(
                      //     icon: Icons.school,
                      //     label: 'Exam',
                      //     color: colorScheme.primary,
                      //     function: () {}),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: getPadding(all: defaultPadding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickAccessButton(
                          icon: ImageConstant.events,
                          label: 'Events',
                          color: colorScheme.primary,
                          function: () {
                            Get.toNamed(AppRoutes.event_list_screen);
                          }),
                      _buildQuickAccessButton(
                          icon: ImageConstant.attendance,
                          label: 'Attendance',
                          color: colorScheme.primary,
                          function: () {
                            Get.toNamed(AppRoutes.page_under_construction);
                          }),
                      _buildQuickAccessButton(
                          icon: ImageConstant.fees,
                          label: 'Fees',
                          color: colorScheme.primary,
                          function: () {
                            Get.toNamed(AppRoutes.page_under_construction);
                          }),

                      // _buildQuickAccessButton(
                      //     icon: Icons.school,
                      //     label: 'Exam',
                      //     color: colorScheme.primary,
                      //     function: () {}),
                    ],
                  ),
                ],
              ),
            ),

            //GridMenu(),
            const SizedBox(height: 20),

            // Recent Activities Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Upcoming Events", style: textTheme.titleLarge),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.event_list_screen);
                  },
                  child: Text(
                    "View more",
                    style: textTheme.bodyMedium!
                        .copyWith(color: colorScheme.secondary),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Obx(() {
              final upcomingEventList = eventController.events
                  .where((event) {
                    return event.eventDate.isAfter(DateTime.now());
                  })
                  .take(5)
                  .toList();
              if (eventController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (upcomingEventList.isEmpty) {
                return Center(
                  child: Text("No upcomingEvents"),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: upcomingEventList.length,
                itemBuilder: (context, index) {
                  var event = upcomingEventList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.onPrimary,
                      child:
                          Icon(Icons.check_circle, color: colorScheme.primary),
                    ),
                    title: Text(
                      event.eventName,
                      style: textTheme.titleLarge,
                    ),
                    subtitle: Row(
                      children: [
                        // Icon(
                        //   Icons.location_on,
                        //   color: colorScheme.tertiary,
                        //   size: 20,
                        // ),
                        Text(event.venue),
                      ],
                    ),
                    trailing: Text(
                      DateFormat('yyyy-MM-dd').format(event.eventDate),
                      style: textTheme.titleMedium,
                    ),
                  );
                },
              );
            }),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String count, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(count,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

Widget _buildQuickAccessButton({
  required String icon,
  required String label,
  required Color color,
  required Function() function,
}) {
  return GestureDetector(
    onTap: function,
    child: Column(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: color.withOpacity(0.2),
          child: Image.asset(
            icon,
            height: 40,
            width: 40,
          ),
        ),
        const SizedBox(height: defaultPadding / 2),
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
