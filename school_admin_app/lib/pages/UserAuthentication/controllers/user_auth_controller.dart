import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:school_admin_app/utils/app_routes.dart';

class UserAuthenticationController extends GetxController {
  var isLoading = false.obs;

  // Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // GraphQL Configuration
  final String _graphqlEndpoint = "http://localhost:4000/graphql";
  late GraphQLClient _client;

  UserAuthenticationController() {
    final HttpLink httpLink = HttpLink(_graphqlEndpoint);
    _client = GraphQLClient(link: httpLink, cache: GraphQLCache());
  }

  // Signup method
  Future<void> signupUser(String userName, String userEmail, String password,
      String userRole) async {
    isLoading(true);

    try {
      // Firebase Signup
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: password,
      );

      String userId = userCredential.user!.uid;

      // Save user to Firestore
      await _firestore.collection('users').doc(userId).set({
        'userName': userName,
        'userEmail': userEmail,
        'userRole': userRole,
      });

      // Save user to MongoDB via GraphQL
      const String addUserMutation = '''
        mutation AddUser(\$userName: String!, \$userEmail: String!, \$userRole: String!) {
          addUser(userName: \$userName, userEmail: \$userEmail, userRole: \$userRole) {
            id
          }
        }
      ''';

      await _client.mutate(
        MutationOptions(
          document: gql(addUserMutation),
          variables: {
            'userName': userName,
            'userEmail': userEmail,
            'userRole': userRole,
          },
        ),
      );

      Get.snackbar("Success", "Signup successful");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Login method
  Future<void> loginUser(String userEmail, String password) async {
    isLoading(true);

    try {
      // Firebase Login
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: userEmail,
        password: password,
      );

      String userId = userCredential.user!.uid;

      // Check user role from Firestore
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();

      String userRole = userSnapshot['userRole'] ?? 'parent';

      // Navigate based on role
      if (userRole == 'admin') Get.toNamed(AppRoutes.admin_dashboard_screen);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
