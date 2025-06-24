import 'package:get/get_core/src/get_main.dart';
import 'package:school_parent_app/core/theme/app_core_theme_export.dart';
import 'package:school_parent_app/core/theme/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:school_parent_app/pages/SideMenu/side_menu_drawer.dart';
import 'package:school_parent_app/utils/app_routes.dart';

class PageUnderConstruction extends StatelessWidget {
  const PageUnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.parent_dashboard_screen);
            },
            icon: Icon(Icons.home))
      ]),
      drawer: SideMenuDrawer(),
      body: Column(
        children: [
          SizedBox(
            height: height * 0.2,
          ),
          Center(
            child: Text(
              'Page Under Construction',
              style: textTheme.headlineSmall,
            ),
          ),
          SizedBox(
            height: height * 0.2,
          ),
        ],
      ),
    );
  }
}
