import 'package:get/get.dart';
import 'package:school_admin_app/core/theme/size_utils.dart';
import 'package:school_admin_app/pages/admin_dashboard/models/grid_menu_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class GridMenu extends StatelessWidget {
  GridMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: menus.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.4,
        ),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => Get.toNamed(menus[index].route),
          child: Center(
            child: CircleAvatar(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image(
                    image: AssetImage(
                      menus[index].image,
                    ),
                    width: width * 0.1,
                  ),
                  Center(
                    child: Text(
                      menus[index].menuName,
                      style: textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
