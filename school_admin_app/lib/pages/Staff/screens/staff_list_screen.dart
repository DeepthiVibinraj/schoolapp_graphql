import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_admin_app/pages/SideMenu/side_menu_drawer.dart';
import 'package:school_admin_app/pages/Staff/screens/staff_add_screen.dart';
import 'package:school_admin_app/utils/app_routes.dart';
import '../controllers/staff_controller.dart';

class StaffListScreen extends StatelessWidget {
  final StaffController staffController = Get.put(StaffController());

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('Staffs'), actions: [
        IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.admin_dashboard_screen);
            },
            icon: Icon(Icons.home))
      ]),
      drawer: SideMenuDrawer(),
      body: Obx(() {
        if (staffController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (staffController.staffs.isEmpty) {
          return Center(child: Text('No staff found.'));
        }

        return ListView.builder(
          itemCount: staffController.staffs.length,
          itemBuilder: (context, index) {
            final staff = staffController.staffs[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(staff.name),
                subtitle: Text(
                    'Qualification: ${staff.qualification}, Mobiler: ${staff.contact}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Get.to(() => AddStaffScreen(staff: staff));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: colorScheme.error),
                      onPressed: () {
                        staffController.deleteStaff(staff.id);
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
          Get.to(() => AddStaffScreen());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
