import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_admin_app/pages/Class/screens/class_add_screen.dart';
import 'package:school_admin_app/pages/SideMenu/side_menu_drawer.dart';
import 'package:school_admin_app/utils/app_routes.dart';
import '../controllers/class_controller.dart';

class ClassListScreen extends StatelessWidget {
  final ClassController classController = Get.put(ClassController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes'),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(AppRoutes.admin_dashboard_screen);
              },
              icon: Icon(Icons.home))
        ],
      ),
      drawer: SideMenuDrawer(),
      body: Obx(() {
        if (classController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (classController.classes.isEmpty) {
          return Center(child: Text('No Class found.'));
        }

        return ListView.builder(
          itemCount: classController.classes.length,
          itemBuilder: (context, index) {
            final classs = classController.classes[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(classs.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Get.to(() => AddClassScreen(classs: classs));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        classController.deleteClass(classs.id);
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
          Get.to(() => AddClassScreen());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
