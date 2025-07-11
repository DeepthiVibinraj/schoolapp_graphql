import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:school_parent_app/core/constants/api_constant.dart';
import '../models/student.dart';

class StudentController extends GetxController {
  var students = <Student>[].obs;
  var isLoading = false.obs;
  final RxInt activeStudentIndex = RxInt(0);

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
      final GraphQLClient client = GraphQLClient(
        link: HttpLink(
          graphqlEndpoint,
          defaultHeaders: {
            "Content-Type": "application/json",
          },
        ),
        cache: GraphQLCache(),
      );

      final response = await client.query(QueryOptions(
        document: gql(query),
        variables: {'email': email},
      ));

      if (response.data != null) {
        final studentsList = (response.data!['getStudentByEmail'] as List)
            .map((student) => Student.fromJson(student))
            .toList();
        students.assignAll(studentsList);
      }
    } catch (error) {
      print('Error fetching student data: $error');
    } finally {
      isLoading(false);
    }
  }
}
