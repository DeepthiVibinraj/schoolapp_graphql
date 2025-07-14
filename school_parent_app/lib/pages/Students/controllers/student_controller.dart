// import 'package:get/get.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:school_parent_app/core/constants/api_constant.dart';
// import 'package:school_parent_app/graphql_config.dart';
// import '../models/student.dart';

// class StudentController extends GetxController {
//   var students = <Student>[].obs;
//   var isLoading = false.obs;
//   final RxInt activeStudentIndex = RxInt(0);

//   void fetchStudentData(String email) async {
//     const query = '''
//       query GetStudentByEmail(\$email: String!) {
//         getStudentByEmail(email: \$email) {
//           id
//           name
//           age
//           class
//           contact
//           email
//         }
//       }
//     ''';

//     try {
//       isLoading(true);
//       final client = await graphqlconfig();
//       // final GraphQLClient client = GraphQLClient(
//       //   link: HttpLink(
//       //     graphqlEndpoint,
//       //     defaultHeaders: {
//       //       "Content-Type": "application/json",
//       //     },
//       //   ),
//       //   cache: GraphQLCache(),
//       // );

//       final response = await client.query(QueryOptions(
//         document: gql(query),
//         variables: {'email': email},
//       ));

//       if (response.data != null) {
//         final studentsList = (response.data!['getStudentByEmail'] as List)
//             .map((student) => Student.fromJson(student))
//             .toList();
//         students.assignAll(studentsList);
//       }
//     } catch (error) {
//       print('Error fetching student data: $error');
//     } finally {
//       isLoading(false);
//     }
//   }
//}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:school_parent_app/graphql_config.dart';
import '../models/student.dart';

class StudentController extends GetxController {
  var students = <Student>[].obs;
  var isLoading = false.obs;
  final RxInt activeStudentIndex = RxInt(0);

  @override
  void onInit() {
    super.onInit();
    final email = FirebaseAuth.instance.currentUser?.email;
    print("👤 Current user: $email");
    if (email != null) {
      fetchStudentData(email);
    } else {
      print("⚠️ No user logged in.");
    }
  }

  void fetchStudentData(String email) async {
    const query = '''
      query GetStudentByEmail(\$email: String!) {
        getStudentByEmail(email: \$email) {
          id
          name
          age
          class
          contact
          email
        }
      }
    ''';

    try {
      isLoading(true);
      print("📡 Fetching data for $email");

      final client = await graphqlconfig();

      final response = await client.query(QueryOptions(
        document: gql(query),
        variables: {'email': email},
      ));

      print("📬 GraphQL response: ${response.data}");

      if (response.hasException) {
        print("❌ GraphQL Error: ${response.exception.toString()}");
      }

      if (response.data != null) {
        final studentsList = (response.data!['getStudentByEmail'] as List)
            .map((student) => Student.fromJson(student))
            .toList();
        students.assignAll(studentsList);
        print("✅ Students loaded: ${students.length}");
      }
    } catch (error) {
      print('🚨 Error fetching student data: $error');
    } finally {
      isLoading(false);
    }
  }
}
