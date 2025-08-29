import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_admin_app/core/constants/constants.dart';
import 'package:school_admin_app/pages/Events/controllers/event_controller.dart';
import 'package:school_admin_app/pages/Events/screens/event_add_screen.dart';
import 'package:school_admin_app/pages/SideMenu/side_menu_drawer.dart';
import 'package:school_admin_app/utils/app_routes.dart';

class EventListScreen extends StatelessWidget {
  final EventController eventController = Get.put(EventController());
  var isUpcoming = true.obs;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('Events'), actions: [
        IconButton(
            onPressed: () {
              Get.toNamed(AppRoutes.admin_dashboard_screen);
            },
            icon: Icon(Icons.home))
      ]),
      drawer: SideMenuDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      isUpcoming.value = true; //  update value
                    },
                    child: Obx(() => Chip(
                          label: Text("Upcoming"),
                          backgroundColor: isUpcoming.value
                              ? colorScheme.secondary
                              : Colors.grey[300],
                        ))),
                SizedBox(width: 8),
                GestureDetector(
                    onTap: () {
                      isUpcoming.value = false; //  update value
                    },
                    child: Obx(() => Chip(
                          label: Text("Completed"),
                          backgroundColor: !isUpcoming.value
                              ? colorScheme.secondary
                              : Colors.grey[300],
                        ))),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (eventController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (eventController.events.isEmpty) {
                return Center(child: Text('No event found.'));
              }

              final filteredEvents = eventController.events.where((event) {
                final eventDate = event.eventDate;
                if (isUpcoming.value) {
                  return eventDate.isAfter(DateTime.now());
                } else {
                  return eventDate.isBefore(DateTime.now());
                }
              }).toList();

              if (filteredEvents.isEmpty) {
                return Center(
                    child: Text(isUpcoming.value
                        ? "No upcoming events."
                        : "No completed events."));
              }

              return ListView.builder(
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(event.eventName),
                      subtitle: Text(
                        'Date: ${DateFormat('yyyy-MM-dd').format(event.eventDate)}, Venue: ${event.venue}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Get.to(() => AddEventScreen(event: event));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: colorScheme.error),
                            onPressed: () {
                              eventController.deleteEvent(event.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddEventScreen());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
