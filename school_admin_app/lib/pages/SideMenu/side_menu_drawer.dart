import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_admin_app/core/constants/constants.dart';
import 'package:school_admin_app/core/theme/common_components/page_under_construction.dart';
import 'package:school_admin_app/core/theme/size_utils.dart';

import 'package:school_admin_app/pages/UserAuthentication/user_auth_screen.dart';
import 'package:school_admin_app/utils/app_routes.dart';

class SideMenuDrawer extends StatefulWidget {
  SideMenuDrawer({
    Key? key,
  }) : super(key: key);
  //SideMenuController controller;

  @override
  State<SideMenuDrawer> createState() => _SideMenuDrawerState();
}

class _SideMenuDrawerState extends State<SideMenuDrawer> {
  @override
  Widget build(BuildContext context) {
    // final StudentController controller = Get.put(StudentController());
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      // backgroundColor: colorScheme.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: colorScheme.primary),
              child: Container(
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        backgroundColor: colorScheme.tertiary,
                        foregroundColor: colorScheme.surface,
                        radius: 35,
                        child: Icon(
                          Icons.person,
                          size: 40,
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get(),
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
                        String name = snapshot.data!['userName'];

                        return Text(
                          '$name',
                          style: textTheme.bodyLarge!
                              .copyWith(color: colorScheme.surface),
                        );
                      },
                    ),
                    //  Text(data)
                  ],
                ),
              )),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DrawerListTile(
                    title: "Dashboard",
                    icon: Icons.dashboard,
                    press: () {
                      Get.toNamed(AppRoutes.admin_dashboard_screen);
                    },
                  ),
                  Divider(indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "Students",
                    icon: Icons.people,
                    press: () {
                      Get.toNamed(AppRoutes.student_list_screen);
                      //Get.offAllNamed(AppRoutes.staffScreen);
                    },
                  ),
                  Divider(indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "Staff",
                    icon: Icons.person,
                    press: () {
                      Get.toNamed(AppRoutes.staff_list_screen);
                    },
                  ),
                  Divider(indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "Classes",
                    icon: Icons.class_,
                    press: () {
                      Get.toNamed(AppRoutes.class_list_screen);
                    },
                  ),
                  Divider(indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "Subjects",
                    icon: Icons.subject,
                    press: () {
                      Get.toNamed(AppRoutes.subject_list_screen);
                    },
                  ),
                  Divider(indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "TimeTable",
                    icon: Icons.calendar_month,
                    press: () {
                      Get.toNamed(AppRoutes.timetable_list_screen);
                    },
                  ),
                  Divider(indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "Homework",
                    icon: Icons.home_work,
                    press: () {
                      Get.toNamed(AppRoutes.homework_list_screen);
                    },
                  ),
                  Divider(indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "Events",
                    icon: Icons.event_available_sharp,
                    press: () {
                      Get.toNamed(AppRoutes.event_list_screen);
                    },
                  ),
                  Divider(indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "Attendance",
                    icon: Icons.checklist,
                    press: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PageUnderConstruction(),
                      ));
                    },
                  ),
                  Divider(indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "Exam",
                    icon: Icons.school,
                    press: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PageUnderConstruction(),
                      ));
                    },
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Divider(indent: defaultPadding, endIndent: defaultPadding),
              Padding(
                padding:
                    getPadding(left: defaultPadding, right: defaultPadding),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Version 1.0.3',
                          style: textTheme.bodyLarge
                              ?.copyWith(color: Colors.black54),
                        ),
                        IconButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut().then((value) =>
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserAuthenticationScreen())));
                            },
                            icon: Icon(
                              Icons.logout,
                              color: colorScheme.secondary,
                            ))
                      ],
                    ),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get(),
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
                        String email = snapshot.data!['userEmail'];

                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$email',
                                    style: textTheme.bodyLarge!
                                        .copyWith(color: Colors.black87),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: defaultPadding,
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      onTap: press,
      leading: Icon(
        icon,
        color: colorScheme.secondary,
      ),
      title: Text(
        title,
        style: textTheme.bodyLarge?.copyWith(color: Colors.black54),
      ),
    );
  }
}
