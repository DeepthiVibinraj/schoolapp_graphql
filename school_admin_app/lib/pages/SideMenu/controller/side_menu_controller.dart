// import 'dart:convert';

// import 'package:top_talents/core/app_core_export.dart';
// import 'package:top_talents/pages/side_menu/models/side_menu_model.dart';
// import 'package:flutter/material.dart';

// class SideMenuController extends GetxController {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   Rx<SideMenuModel> sideMenuModelObj = SideMenuModel().obs;
//   RxString givenName = ''.obs;
//   RxString profile_photo = ''.obs;

//   @override
//   void onReady() {
//     super.onReady();
//     final userDataString = Get.find<PreferencesUtils>().getAuthUser().obs.value;
//     // print("USER INFO==>");
//     if (userDataString.isNotEmpty) {
//       Map<String, dynamic> userData = json.decode(userDataString);
//       // Use the userData map
//       givenName.value = userData["given_name"] ?? 'Welcome';
//       profile_photo.value = userData["profile_photo"] ?? '';
//     }
//   }
// }
