import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/class_controller.dart';
import '../models/class.dart';

class AddClassScreen extends StatelessWidget {
  final ClassController classController = Get.find();

  final Class? classs;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  AddClassScreen({this.classs}) {
    if (classs != null) {
      nameController.text = classs!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(classs == null ? 'Add Class' : 'Edit Class'),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newClass = Class(
                      id: classs?.id ?? '',
                      name: nameController.text,
                    );

                    if (classs == null) {
                      classController.addClass(newClass);
                    } else {
                      classController.updateStaff(classs!.id, newClass);
                    }

                    Get.back();
                  }
                },
                child: Text(classs == null ? 'Add Class' : 'Update Class'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
