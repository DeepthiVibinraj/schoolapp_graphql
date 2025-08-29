import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_admin_app/pages/Class/controllers/class_controller.dart';
import 'package:school_admin_app/pages/SideMenu/side_menu_drawer.dart';
import 'package:school_admin_app/pages/homework/controllers/homework_controller.dart';

import 'package:school_admin_app/pages/homework/screens/homework_add_screen.dart';
import 'package:school_admin_app/utils/app_routes.dart';

class HomeworkListScreen extends StatelessWidget {
  HomeworkListScreen({super.key});
  final HomeworkController homeworkController = Get.put(HomeworkController());
  String getClassName(String classId) {
    final classController = Get.put(ClassController());
    final matchedClass =
        classController.classes.firstWhereOrNull((c) => c.id == classId);
    return matchedClass?.name ?? classId; // Fallback to ID if not found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Homework List'), actions: [
        IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.admin_dashboard_screen);
            },
            icon: Icon(Icons.home))
      ]),
      drawer: SideMenuDrawer(),
      body: Obx(() {
        if (homeworkController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (homeworkController.homeworkList.isEmpty) {
          return Center(child: Text("No homework available."));
        }
        return ListView.builder(
          itemCount: homeworkController.homeworkList.length,
          itemBuilder: (context, index) {
            final hw = homeworkController.homeworkList[index];
            return Card(
              margin: EdgeInsets.all(12),
              child: ExpansionTile(
                title: Text("Class: ${getClassName(hw.classLevel)}"),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    homeworkController.deleteHomework(hw.id);
                  },
                ),

                //title: Text("Class: ${hw.classLevel}"),
                children: hw.subjectHomeworks.map((sub) {
                  return ListTile(
                    title: Text("Subject: ${sub.subject}"),
                    subtitle: Text("Homework: ${sub.homework}"),
                  );
                }).toList(),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddHomeworkScreen()),
        child: Icon(Icons.add),
      ),
    );
  }
}
