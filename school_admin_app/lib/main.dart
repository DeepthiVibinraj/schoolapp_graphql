import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:school_admin_app/core/theme/app_theme_data.dart';
import 'package:school_admin_app/firebase_options.dart';
import 'package:school_admin_app/graphql_config.dart';
import 'utils/app_routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final GraphQLClient client = await graphqlconfig();
  Get.put<GraphQLClient>(client);

  print('-----------------------------------------------');
  print('FCM Server Key: ${dotenv.env['FCM_SERVER_KEY']}');
  print(dotenv.env['FCM_SERVER_KEY']);

  User? currentUser = FirebaseAuth.instance.currentUser;

  String initialRoute;

  if (currentUser != null) {
    // User is already logged in
    // You can check role from Firestore too if needed
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    String? role = doc.data()?['userRole'] ?? 'parent';

    if (role == 'admin') {
      initialRoute = AppRoutes.admin_dashboard_screen;
    } else {
      initialRoute = AppRoutes.login;
    }
  } else {
    initialRoute = AppRoutes.login;
  }

  runApp(MyApp(initialRoute: initialRoute));

  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'School Admin App',
      theme: AppThemeData.lightThemeData.copyWith(
        platform: defaultTargetPlatform,
      ),
      darkTheme: AppThemeData.darkThemeData.copyWith(
        platform: defaultTargetPlatform,
      ),
      initialRoute: initialRoute,
      getPages: AppRoutes.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
