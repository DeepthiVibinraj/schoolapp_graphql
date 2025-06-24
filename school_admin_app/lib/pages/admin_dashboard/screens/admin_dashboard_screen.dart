import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_admin_app/core/constants/constants.dart';
import 'package:school_admin_app/core/constants/image_constant.dart';
import 'package:school_admin_app/core/theme/size_utils.dart';
import 'package:school_admin_app/pages/Class/controllers/class_controller.dart';
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
                          icon: ImageConstant.exam,
                          label: 'Exam',
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
            Padding(
              padding: getPadding(all: defaultPadding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
                      _buildQuickAccessButton(
                          icon: ImageConstant.bus,
                          label: 'Bus',
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
            Text("Recent Activities", style: textTheme.titleLarge),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.onPrimary,
                    child: Icon(Icons.check_circle, color: colorScheme.primary),
                  ),
                  title: Text("Activity ${index + 1}"),
                  subtitle: Text("Details about the activity..."),
                  trailing: Icon(Icons.arrow_forward_ios),
                );
              },
            ),

            const SizedBox(height: 20),

            // Notifications Section
            // Text("Notifications", style: textTheme.titleLarge),
            // const SizedBox(height: 10),
            // SizedBox(
            //   height: size.height * 0.2,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: 5,
            //     itemBuilder: (context, index) {
            //       return Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Container(
            //           width: size.width * 0.8,
            //           padding: const EdgeInsets.all(16.0),
            //           decoration: BoxDecoration(
            //             color: Colors.grey[200],
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text("Notification ${index + 1}",
            //                   style: TextStyle(fontWeight: FontWeight.bold)),
            //               const SizedBox(height: 5),
            //               Text("Short description of the notification..."),
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
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
