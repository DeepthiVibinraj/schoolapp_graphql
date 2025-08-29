import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_admin_app/pages/SideMenu/side_menu_drawer.dart';
import 'package:school_admin_app/pages/Students/screens/student_add_screen.dart';
import 'package:school_admin_app/utils/app_routes.dart';
import '../controllers/student_controller.dart';

class StudentListScreen extends StatelessWidget {
  final StudentController studentController = Get.put(StudentController());

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('Students'), actions: [
        IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.admin_dashboard_screen);
            },
            icon: Icon(Icons.home))
      ]),
      drawer: SideMenuDrawer(),
      body: Obx(() {
        if (studentController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (studentController.students.isEmpty) {
          return Center(child: Text('No students found.'));
        }

        return ListView.builder(
          itemCount: studentController.students.length,
          itemBuilder: (context, index) {
            final student = studentController.students[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(student.name),
                subtitle:
                    Text('Class: ${student.studentClass}, Age: ${student.age}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                      ),
                      onPressed: () {
                        Get.to(() => AddStudentScreen(student: student));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: colorScheme.error),
                      onPressed: () {
                        studentController.deleteStudent(student.id);
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
          Get.to(() => AddStudentScreen());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
