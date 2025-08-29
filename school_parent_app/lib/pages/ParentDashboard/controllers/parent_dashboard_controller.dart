import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class ParentDashboardController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    saveFcmToken();
    super.onInit();
  }

  Future<void> saveFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (fcmToken != null && uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'fcmToken': fcmToken,
      });
    }
    print("FCM Token saved successfully");
  }
}
