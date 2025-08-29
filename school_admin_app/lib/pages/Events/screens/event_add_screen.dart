import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_admin_app/pages/Events/controllers/event_controller.dart';
import 'package:school_admin_app/pages/Events/models/event.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatelessWidget {
  final EventController eventController = Get.put(EventController());

  final Event? event;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController venueController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  var selectedDate = DateTime.now().obs;

  // Function to pick a date
  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedDate.value = DateTime(picked.year, picked.month, picked.day);
      dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate.value);
    }
  }

  AddEventScreen({this.event}) {
    if (event != null) {
      eventNameController.text = event!.eventName;
      venueController.text = event!.venue;
      dateController.text = event!.eventDate.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event == null ? 'Add Event' : 'Edit Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: eventNameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event\'s name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: venueController,
                decoration: InputDecoration(labelText: 'Venue'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the venue';
                  }
                  return null;
                },
              ),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Select Event Date",
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                onTap: () => pickDate(context),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newEvent = Event(
                      id: event?.id ?? '',
                      eventName: eventNameController.text,
                      eventDate: selectedDate.value,
                      venue: venueController.text,
                    );

                    if (event == null) {
                      eventController.addEvent(newEvent);
                    } else {
                      eventController.updateEvent(event!.id, newEvent);
                    }

                    Get.back();
                  }
                },
                child: Text(event == null ? 'Add Event' : 'Update Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
