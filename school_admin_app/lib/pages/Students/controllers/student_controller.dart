import 'package:get/get.dart';
import 'package:graphql/client.dart';
import 'package:school_admin_app/graphql_config.dart';
import '../models/student.dart';

class StudentController extends GetxController {
  var students = <Student>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchStudents();
    super.onInit();
  }

  void fetchStudents() async {
    isLoading(true);
    try {
      final client = graphqlconfig();
      const query = '''
        query {
          getStudents {
            id
            name
            age
            class
            contact
            email
          }
        }
      ''';

      final options = QueryOptions(document: gql(query));
      final result = await client.query(options);

      if (result.hasException) {
        throw result.exception!;
      }

      final data = result.data?['getStudents'] as List<dynamic>;
      final studentList =
          data.map((student) => Student.fromJson(student)).toList();
      students.assignAll(studentList);
    } catch (e) {
      print("Error fetching students: $e");
    } finally {
      isLoading(false);
    }
  }

  void addStudent(Student student) async {
    isLoading(true);
    try {
      final client = graphqlconfig();
      const mutation = '''
        mutation AddStudent(\$name: String!, \$age: Int!, \$class: String!, \$contact: String!,\$email: String!) {
          addStudent(name: \$name, age: \$age, class: \$class, contact: \$contact, email: \$email) {
            id
          }
        }
      ''';

      final options = MutationOptions(
        document: gql(mutation),
        variables: student.toJson(),
      );
      final result = await client.mutate(options);

      if (result.hasException) {
        throw result.exception!;
      }

      fetchStudents();
    } catch (e) {
      print("Error adding student: $e");
    } finally {
      isLoading(false);
    }
  }

  void deleteStudent(String id) async {
    isLoading(true);
    try {
      final client = graphqlconfig();
      const mutation = '''
        mutation DeleteStudent(\$id: ID!) {
          deleteStudent(id: \$id)
        }
      ''';

      final options = MutationOptions(
        document: gql(mutation),
        variables: {'id': id},
      );
      final result = await client.mutate(options);

      if (result.hasException) {
        throw result.exception!;
      }

      fetchStudents();
    } catch (e) {
      print("Error deleting student: $e");
    } finally {
      isLoading(false);
    }
  }

  void updateStudent(String id, Student student) async {
    isLoading(true);
    try {
      final client = graphqlconfig();
      const mutation = '''
        mutation UpdateStudent(\$id: ID!, \$name: String, \$age: Int, \$class: String, \$contact: String, \$email: String) {
          updateStudent(id: \$id, name: \$name, age: \$age, class: \$class, contact: \$contact, email: \$email) {
            id
          }
        }
      ''';

      final options = MutationOptions(
        document: gql(mutation),
        variables: {
          'id': id,
          ...student.toJson(),
        },
      );
      final result = await client.mutate(options);

      if (result.hasException) {
        throw result.exception!;
      }

      fetchStudents();
    } catch (e) {
      print("Error updating student: $e");
    } finally {
      isLoading(false);
    }
  }
}
