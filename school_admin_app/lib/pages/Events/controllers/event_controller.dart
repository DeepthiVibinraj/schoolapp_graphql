import 'package:get/get.dart';
import 'package:graphql/client.dart';
import 'package:school_admin_app/graphql_config.dart';
import 'package:school_admin_app/pages/Events/models/event.dart';

// Import GraphQL configuration

class EventController extends GetxController {
  var events = <Event>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchEvents();
    super.onInit();
  }

  void fetchEvents() async {
    isLoading(true);
    try {
      final client = await graphqlconfig();
      const query = '''
        query {
          getEvents {
            id
            eventName
            eventDate
            venue
          }
        }
      ''';

      final options = QueryOptions(document: gql(query));
      final result = await client.query(options);

      if (result.hasException) {
        throw result.exception!;
      }

      final data = result.data?['getEvents'] as List<dynamic>;
      final eventsList = data.map((event) => Event.fromJson(event)).toList();
      events.assignAll(eventsList);
    } catch (e) {
      print("Error fetching event: $e");
    } finally {
      isLoading(false);
    }
  }

  void addEvent(Event event) async {
    isLoading(true);
    try {
      final client = await graphqlconfig();
      const mutation = '''
        mutation AddEvent(\$eventName: String!, \$eventDate: String!, \$venue: String!,) {
          addEvent(eventName: \$eventName, eventDate: \$eventDate, venue: \$venue,) {
            id
          }
        }
      ''';

      final options = MutationOptions(
        document: gql(mutation),
        variables: event.toJson(),
      );
      final result = await client.mutate(options);

      if (result.hasException) {
        throw result.exception!;
      }

      fetchEvents();
    } catch (e) {
      print("Error adding event: $e");
    } finally {
      isLoading(false);
    }
  }

  void deleteEvent(String id) async {
    isLoading(true);
    try {
      final client = await graphqlconfig();
      const mutation = '''
        mutation DeleteEvent(\$id: ID!) {
          deleteEvent(id: \$id)
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

      fetchEvents();
    } catch (e) {
      print("Error deleting event: $e");
    } finally {
      isLoading(false);
    }
  }

  void updateEvent(String id, Event event) async {
    isLoading(true);
    try {
      final client = await graphqlconfig();
      const mutation = '''
        mutation UpdateEvent(\$id: ID!, \$eventName: String, \$eventDate: String, \$venue: String,) {
          updateEvent(id: \$id, eventName: \$eventName, eventDate: \$eventDate, venue: \$venue, ) {
            id
          }
        }
      ''';

      final options = MutationOptions(
        document: gql(mutation),
        variables: {
          'id': id,
          ...event.toJson(),
        },
      );
      final result = await client.mutate(options);

      if (result.hasException) {
        throw result.exception!;
      }

      fetchEvents();
    } catch (e) {
      print("Error updating event: $e");
    } finally {
      isLoading(false);
    }
  }
}
