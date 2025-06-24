import 'package:get/get.dart';
import 'package:graphql/client.dart';
import 'package:school_admin_app/graphql_config.dart';
import '../models/staff.dart';
// Import GraphQL configuration

class StaffController extends GetxController {
  var staffs = <Staff>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchStaffs();
    super.onInit();
  }

  void fetchStaffs() async {
    isLoading(true);
    try {
      final client = graphqlconfig();
      const query = '''
        query {
          getStaffs {
            id
            name
            age
            qualification
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

      final data = result.data?['getStaffs'] as List<dynamic>;
      final staffList = data.map((staff) => Staff.fromJson(staff)).toList();
      staffs.assignAll(staffList);
    } catch (e) {
      print("Error fetching staff: $e");
    } finally {
      isLoading(false);
    }
  }

  void addStaff(Staff staff) async {
    isLoading(true);
    try {
      final client = graphqlconfig();
      const mutation = '''
        mutation AddStaff(\$name: String!, \$age: Int!, \$qualification: String!, \$contact: String!,\$email: String!) {
          addStaff(name: \$name, age: \$age, qualification: \$qualification, contact: \$contact, email: \$email) {
            id
          }
        }
      ''';

      final options = MutationOptions(
        document: gql(mutation),
        variables: staff.toJson(),
      );
      final result = await client.mutate(options);

      if (result.hasException) {
        throw result.exception!;
      }

      fetchStaffs();
    } catch (e) {
      print("Error adding staff: $e");
    } finally {
      isLoading(false);
    }
  }

  void deleteStaff(String id) async {
    isLoading(true);
    try {
      final client = graphqlconfig();
      const mutation = '''
        mutation DeleteStaff(\$id: ID!) {
          deleteStaff(id: \$id)
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

      fetchStaffs();
    } catch (e) {
      print("Error deleting staff: $e");
    } finally {
      isLoading(false);
    }
  }

  void updateStaff(String id, Staff staff) async {
    isLoading(true);
    try {
      final client = graphqlconfig();
      const mutation = '''
        mutation UpdateStaff(\$id: ID!, \$name: String, \$age: Int, \$qualification: String, \$contact: String, \$email: String) {
          updateStaff(id: \$id, name: \$name, age: \$age, qualification: \$qualification, contact: \$contact, email: \$email) {
            id
          }
        }
      ''';

      final options = MutationOptions(
        document: gql(mutation),
        variables: {
          'id': id,
          ...staff.toJson(),
        },
      );
      final result = await client.mutate(options);

      if (result.hasException) {
        throw result.exception!;
      }

      fetchStaffs();
    } catch (e) {
      print("Error updating staff: $e");
    } finally {
      isLoading(false);
    }
  }
}
