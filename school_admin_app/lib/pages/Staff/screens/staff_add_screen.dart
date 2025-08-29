import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/staff_controller.dart';
import '../models/staff.dart';

class AddStaffScreen extends StatelessWidget {
  final StaffController staffController = Get.find();

  final Staff? staff;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  AddStaffScreen({this.staff}) {
    if (staff != null) {
      nameController.text = staff!.name;
      ageController.text = staff!.age.toString();
      qualificationController.text = staff!.qualification;
      contactController.text = staff!.contact;
      emailController.text = staff!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(staff == null ? 'Add Staff' : 'Edit Staff'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the staff name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the staff\'s age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Age must be a number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: qualificationController,
                decoration: InputDecoration(labelText: 'Qualification'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the qualification';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: contactController,
                decoration: InputDecoration(labelText: 'Contact'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the contact number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the email ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newStaff = Staff(
                      id: staff?.id ?? '',
                      name: nameController.text,
                      age: int.parse(ageController.text),
                      qualification: qualificationController.text,
                      contact: contactController.text,
                      email: emailController.text,
                    );

                    if (staff == null) {
                      staffController.addStaff(newStaff);
                    } else {
                      staffController.updateStaff(staff!.id, newStaff);
                    }

                    Get.back();
                  }
                },
                child: Text(staff == null ? 'Add Staff' : 'Update Staff'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
