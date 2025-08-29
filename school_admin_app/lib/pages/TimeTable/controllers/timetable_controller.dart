import 'package:get/get.dart';
import 'package:school_admin_app/graphql_config.dart';
import '../models/timetable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class TimeTableController extends GetxController {
  var timeTables = <TimeTable>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchTimeTables();
    super.onInit();
  }

  // Fetch all timetables
  Future<void> fetchTimeTables() async {
    final client = await graphqlconfig();
    isLoading.value = true;

    const String query = """
      query {
        timeTables {
          id
          className
          schedule {
            day
            periods
          }
        }
      }
    """;

    final result = await client.query(QueryOptions(document: gql(query)));

    if (!result.hasException) {
      timeTables.value = (result.data?['timeTables'] as List)
          .map((e) => TimeTable.fromJson(e))
          .toList();
    }

    isLoading.value = false;
  }

  // Add a new timetable
  Future<void> addTimeTable(
      String className, List<DaySchedule> schedule) async {
    final client = await graphqlconfig();
    const String mutation = """
      mutation AddTimeTable(\$className: String!, \$schedule: [DayScheduleInput!]!) {
        addTimeTable(className: \$className, schedule: \$schedule) {
          id
          className
          schedule {
            day
            periods
          }
        }
      }
    """;

    final result = await client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: {
          'className': className,
          'schedule': schedule.map((s) => s.toJson()).toList(),
        },
      ),
    );

    if (!result.hasException) {
      final newTimeTable = TimeTable.fromJson(result.data?['addTimeTable']);
      timeTables.add(newTimeTable); // Add to the observable list
    }
  }

  // Update a timetable
  Future<void> updateTimeTable(
      String id, String className, List<DaySchedule> schedule) async {
    final client = await graphqlconfig();
    const String mutation = """
      mutation UpdateTimeTable(\$id: ID!, \$className: String!, \$schedule: [DayScheduleInput!]!) {
        updateTimeTable(id: \$id, className: \$className, schedule: \$schedule) {
          id
          className
          schedule {
            day
            periods
          }
        }
      }
    """;

    final result = await client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: {
          'id': id,
          'className': className,
          'schedule': schedule.map((s) => s.toJson()).toList(),
        },
      ),
    );

    if (!result.hasException) {
      final updatedTimeTable =
          TimeTable.fromJson(result.data?['updateTimeTable']);
      final index = timeTables.indexWhere((t) => t.id == id);
      if (index != -1) {
        timeTables[index] = updatedTimeTable; // Update the observable list
      }
    }
  }

  // Delete a timetable
  Future<void> deleteTimeTable(String id) async {
    final client = await graphqlconfig();
    const String mutation = """
      mutation DeleteTimeTable(\$id: ID!) {
        deleteTimeTable(id: \$id) {
          id
        }
      }
    """;

    final result = await client.mutate(
      MutationOptions(document: gql(mutation), variables: {'id': id}),
    );

    if (!result.hasException) {
      timeTables
          .removeWhere((t) => t.id == id); // Remove from the observable list
    }
  }
}
