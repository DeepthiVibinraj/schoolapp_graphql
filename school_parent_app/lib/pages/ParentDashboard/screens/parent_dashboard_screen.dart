import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_parent_app/core/constants/constants.dart';
import 'package:school_parent_app/core/theme/app_core_theme_export.dart';
import 'package:school_parent_app/pages/ParentDashboard/controllers/parent_dashboard_controller.dart';
import 'package:school_parent_app/pages/SideMenu/side_menu_drawer.dart';
import 'package:school_parent_app/pages/Students/controllers/student_controller.dart';
import 'package:school_parent_app/pages/Students/models/student.dart';
import 'package:school_parent_app/pages/Students/screens/student_profile.dart';
import 'package:school_parent_app/pages/TimeTable/timetable_screen.dart';
import 'package:school_parent_app/utils/app_routes.dart';

class ParentDashboardScreen extends StatelessWidget {
  final StudentController controller = Get.put(StudentController());
  final ParentDashboardController parentDashboardController =
      Get.put(ParentDashboardController());

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    int timeNow = DateTime.now().hour;
    final parentEmail = FirebaseAuth.instance.currentUser?.email;

    if (parentEmail != null) {
      controller.fetchStudentData(parentEmail);
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          elevation: 0,
        ),
        drawer: SideMenuDrawer(),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: size.height * 0.3,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipPath(
                    clipper: StraightClipper(),
                    child: Container(
                      width: size.width,
                      height: size.height * 0.23,
                      color: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                        //vertical: defaultPadding * 2,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              }
                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return const Center(
                                  child: Text('User data not found.'),
                                );
                              }

                              // Extract data
                              String displayName = snapshot.data!['userName'];
                              //String? photoUrl = snapshot.data!['photoURL'];
                              return Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: colorScheme.tertiary,
                                    foregroundColor: colorScheme.surface,
                                    radius: 30,
                                    child: Icon(
                                      Icons.person,
                                      size: 40,
                                    ),
                                  ),
                                  SizedBox(
                                    width: defaultPadding,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        timeNow <= 12
                                            ? 'Good Morning!'
                                            : ((timeNow > 12) &&
                                                    (timeNow <= defaultPadding))
                                                ? 'Good Afternoon!'
                                                : 'Good Evening!',
                                        style: textTheme.headlineSmall
                                            ?.copyWith(
                                                color: colorScheme.surface),
                                      ),
                                      Text(
                                        displayName,
                                        style: textTheme.titleLarge!.copyWith(
                                            color: colorScheme.surface),
                                      )
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            height: defaultPadding,
                          ),
                          Text(
                            'Registered Students',
                            style: textTheme.titleMedium!
                                .copyWith(color: colorScheme.surface),
                          ),
                          SizedBox(
                            height: defaultPadding,
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: size.height * 0.14,
                    child: Container(
                      height: size.height * 0.18,
                      decoration: BoxDecoration(),
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Obx(() {
                        print(
                            "Active Student Index: ${controller.activeStudentIndex.value}");
                        if (controller.isLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (controller.students.isEmpty) {
                          return const Center(
                              child: Text('No student data found.'));
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.students.length,
                          itemBuilder: (context, index) {
                            final Student student = controller.students[index];
                            bool isActive =
                                controller.activeStudentIndex.value == index;

                            return GestureDetector(
                              onTap: () {
                                controller.activeStudentIndex.value = index;
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(
                                    right: defaultPadding),
                                padding: const EdgeInsets.all(defaultPadding),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(defaultPadding),
                                  color: isActive
                                      ? colorScheme.secondary
                                      : colorScheme.surface,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: isActive
                                          ? colorScheme.surface
                                          : colorScheme.tertiary,
                                      radius: 25,
                                      child: Icon(
                                        Icons.person,
                                        color: isActive
                                            ? colorScheme.secondary
                                            : colorScheme.surface,
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(width: defaultPadding / 2),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          student.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isActive
                                                ? colorScheme.surface
                                                : colorScheme.onSurface,
                                          ),
                                        ),
                                        Text(
                                          student.studentClass,
                                          style: TextStyle(
                                            color: isActive
                                                ? colorScheme.surface
                                                : colorScheme.onSurface
                                                    .withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            // Quick Access Buttons
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickAccessButton(
                          icon: Icons.person,
                          label: 'Profile',
                          color: colorScheme.primary,
                          function: () {
                            Get.to(ProfilePage());
                          }),
                      _buildQuickAccessButton(
                          icon: Icons.message,
                          label: 'Messages',
                          color: colorScheme.primary,
                          function: () {}),

                      _buildQuickAccessButton(
                        icon: Icons.menu_book_rounded,
                        label: 'Home Works',
                        color: colorScheme.primary,
                        function: () {
                          Get.toNamed(AppRoutes.homeworkScreen);
                        },
                      ),

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
                          icon: Icons.calendar_month,
                          label: 'Events',
                          color: colorScheme.primary,
                          function: () {}),
                      _buildQuickAccessButton(
                          icon: Icons.table_view,
                          label: 'TimeTable',
                          color: colorScheme.primary,
                          function: () {
                            final activeStudent = controller
                                .students[controller.activeStudentIndex.value];
                            Get.to(TimetableScreen(),
                                arguments: activeStudent.studentClass);
                          }),
                      _buildQuickAccessButton(
                          icon: Icons.school,
                          label: 'Exam',
                          color: colorScheme.primary,
                          function: () {}),
                    ],
                  ),
                ],
              ),
            ),

            // Other Sections
            Padding(
              padding: getPadding(
                all: defaultPadding,
              ),
              child: Text(
                'Events',
                style: textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: height * 0.2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Container(
                      width: size.width * 0.8,
                      //margin: const EdgeInsets.only(right: defaultPadding),
                      padding: getPadding(all: defaultPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(defaultPadding),
                        color: colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.tertiary.withOpacity(0.2),
                            blurRadius: defaultPadding / 2,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Event Name ${index + 1}',
                            style: TextStyle(
                                fontSize: defaultPadding,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: defaultPadding / 2),
                          Text(
                            'Event Description',
                            style: TextStyle(
                                fontSize: 14, color: colorScheme.tertiary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: getPadding(all: defaultPadding),
              child: Text(
                'Recent Activities',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.onPrimary,
                      child:
                          Icon(Icons.check_circle, color: colorScheme.primary),
                    ),
                    title: Text('Activity ${index + 1}'),
                    subtitle: Text('Description of the activity.'),
                    trailing:
                        Icon(Icons.arrow_forward_ios, size: defaultPadding),
                  ),
                );
              },
            ),
            SizedBox(
              height: defaultPadding,
            )
          ]),
        ));
  }
}

Widget _buildQuickAccessButton({
  required IconData icon,
  required String label,
  required Color color,
  required Function() function,
}) {
  return GestureDetector(
    onTap: function,
    child: Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, size: 28, color: color),
        ),
        const SizedBox(height: defaultPadding / 2),
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

// Custom Clipper for the curved header
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2, size.height + 30, // Control point for the curve
      size.width, size.height - 50, // End point
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class StraightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height); // Straight down
    path.lineTo(size.width, size.height); // Straight across
    path.lineTo(size.width, 0); // Up to the top right
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
