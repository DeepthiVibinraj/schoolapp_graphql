import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_parent_app/core/constants/constants.dart';
import 'package:school_parent_app/core/theme/app_core_theme_export.dart';
import 'package:school_parent_app/core/theme/common_components/custom_container.dart';
import 'package:school_parent_app/pages/SideMenu/side_menu_drawer.dart';
import 'package:school_parent_app/pages/Students/controllers/student_controller.dart';
import 'package:school_parent_app/pages/Students/models/student.dart';

class ProfilePage extends StatelessWidget {
  final StudentController controller = Get.put(StudentController());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final parentEmail = FirebaseAuth.instance.currentUser?.email;

    if (parentEmail != null) {
      controller.fetchStudentData(parentEmail);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      drawer: SideMenuDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width,
            padding: getPadding(all: defaultPadding),
            decoration: BoxDecoration(color: colorScheme.primary),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.tertiary,
                  foregroundColor: colorScheme.surface,
                  radius: 35,
                  child: Icon(
                    Icons.person,
                    size: 40,
                  ),
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: defaultPadding,
                  ),
                  Row(
                    children: [
                      Text('Email: '),
                      SizedBox(
                        width: defaultPadding,
                      ),
                      Expanded(child: Text(parentEmail!)),
                    ],
                  ),
                  SizedBox(
                    height: defaultPadding,
                  ),
                  Text(
                    'Registered Students',
                    style: textTheme.titleMedium,
                  ),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (controller.students.isEmpty) {
                        return Center(child: Text('No student data found.'));
                      }

                      return ListView.builder(
                        itemCount: controller.students.length,
                        itemBuilder: (context, index) {
                          final Student student = controller.students[index];
                          return CustomContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(student.name),
                                SizedBox(
                                  height: defaultPadding / 2,
                                ),
                                Row(
                                  children: [
                                    Text('Class: ${student.studentClass}'),
                                    SizedBox(
                                      width: defaultPadding,
                                    ),
                                    Text('Age: ${student.age}'),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
