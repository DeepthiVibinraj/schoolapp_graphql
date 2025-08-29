import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_parent_app/core/constants/constants.dart';
import 'package:school_parent_app/core/theme/size_utils.dart';
import 'package:school_parent_app/core/theme/common_components/page_under_construction.dart';
import 'package:school_parent_app/pages/Students/controllers/student_controller.dart';
import 'package:school_parent_app/pages/Students/screens/student_profile.dart';
import 'package:school_parent_app/pages/TimeTable/timetable_screen.dart';
import 'package:school_parent_app/pages/UserAuthentication/user_auth_screen.dart';
import 'package:school_parent_app/utils/app_routes.dart';

// ignore: must_be_immutable
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
    final StudentController controller = Get.put(StudentController());
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
                      Get.toNamed(AppRoutes.parent_dashboard_screen);
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => PageUnderConstruction(),
                      // ));
                      //Get.offAllNamed(AppRoutes.staffScreen);
                    },
                  ),
                  Divider(indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "Profile",
                    icon: Icons.person,
                    press: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ));
                      //Get.offAllNamed(AppRoutes.staffScreen);
                    },
                  ),
                  Divider(indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "Messages",
                    icon: Icons.message,
                    press: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PageUnderConstruction(),
                      ));
                      //Get.offAllNamed(AppRoutes.staffScreen);
                    },
                  ),
                  Divider(indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "Home Work",
                    icon: Icons.menu_book_rounded,
                    press: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PageUnderConstruction(),
                      ));
                      //Get.offAllNamed(AppRoutes.staffScreen);
                    },
                  ),
                  Divider(indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "Events",
                    icon: Icons.calendar_month,
                    press: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PageUnderConstruction(),
                      ));
                      //Get.offAllNamed(AppRoutes.staffScreen);
                    },
                  ),
                  Divider(indent: defaultPadding, endIndent: defaultPadding),
                  DrawerListTile(
                    title: "TimeTable",
                    icon: Icons.table_view,
                    press: () {
                      Get.to(TimetableScreen(),
                          arguments: controller
                              .students[controller.activeStudentIndex.value]
                              .studentClass);
                      //Get.offAllNamed(AppRoutes.staffScreen);
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
                      //Get.offAllNamed(AppRoutes.staffScreen);
                    },
                  ),
                ],
              ),
            ),
          ),
          // const Spacer(),
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
                              //FirebaseAuth.instance.signOut();
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
    // For selecting those three line once press "Command+D"
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
      //horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        color: colorScheme.secondary,
      ),
      // SvgPicture.asset(
      //   svgSrc,
      //   colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
      //   height: 16,
      // ),
      title: Text(
        title,
        style: textTheme.bodyLarge?.copyWith(color: Colors.black54),
      ),
    );
  }
}
