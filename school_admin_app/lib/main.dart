import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:school_admin_app/core/theme/app_theme_data.dart';
import 'package:school_admin_app/firebase_options.dart';
import 'package:school_admin_app/graphql_config.dart';
import 'utils/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final GraphQLClient client = await graphqlconfig();
  Get.put<GraphQLClient>(client);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      initialRoute: AppRoutes.initialRoute,
      getPages: AppRoutes.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
