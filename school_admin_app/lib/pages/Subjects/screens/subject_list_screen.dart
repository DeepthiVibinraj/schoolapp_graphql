import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_admin_app/pages/SideMenu/side_menu_drawer.dart';
import 'package:school_admin_app/pages/Subjects/screens/subject_add_screen.dart';
import 'package:school_admin_app/utils/app_routes.dart';

import '../controllers/subject_controller.dart';

class SubjectListScreen extends StatelessWidget {
  final SubjectController subjectController = Get.put(SubjectController());

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('Subjects'), actions: [
        IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.admin_dashboard_screen);
            },
            icon: Icon(Icons.home))
      ]),
      drawer: SideMenuDrawer(),
      body: Obx(() {
        if (subjectController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (subjectController.subjects.isEmpty) {
          return Center(child: Text('No subjects found.'));
        }

        return ListView.builder(
          itemCount: subjectController.subjects.length,
          itemBuilder: (context, index) {
            final subject = subjectController.subjects[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(subject.name),
                // subtitle:
                //     Text('Class: ${subject.studentClass}, Age: ${subject.age}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                      ),
                      onPressed: () {
                        Get.to(() => AddSubjectScreen(subject: subject));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: colorScheme.error),
                      onPressed: () {
                        subjectController.deleteSubject(subject.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddSubjectScreen());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
