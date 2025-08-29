import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_admin_app/core/theme/size_utils.dart';
import 'package:school_admin_app/pages/Class/controllers/class_controller.dart';
import 'package:school_admin_app/pages/Class/models/class.dart';
import 'package:school_admin_app/pages/Subjects/controllers/subject_controller.dart';
import '../controllers/timetable_controller.dart';
import '../models/timetable.dart';

class AddTimeTableScreen extends StatefulWidget {
  final TimeTable? timeTable;

  AddTimeTableScreen({this.timeTable});

  @override
  _AddTimeTableScreenState createState() => _AddTimeTableScreenState();
}

class _AddTimeTableScreenState extends State<AddTimeTableScreen> {
  final TimeTableController timeTableController =
      Get.put(TimeTableController());
  final _formKey = GlobalKey<FormState>();
  late String className;
  List<DaySchedule> schedule = [];

  @override
  void initState() {
    super.initState();
    if (widget.timeTable != null) {
      className = widget.timeTable!.className;
      schedule = widget.timeTable!.schedule;
    } else {
      className = '';
    }
  }

  void _addDaySchedule() {
    setState(() {
      schedule.add(DaySchedule(day: '', periods: []));
    });
  }

  void _removeDaySchedule(int index) {
    setState(() {
      schedule.removeAt(index);
    });
  }

  final ClassController classController = Get.put(ClassController());
  final SubjectController subjectController = Get.put(SubjectController());
  final Rxn<Class> selectedClass = Rxn<Class>(); // For selected class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.timeTable == null ? 'Add TimeTable' : 'Edit TimeTable'),
      ),
      body: Container(
        height: size.height,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Obx(() {
                    return DropdownButtonFormField<Class>(
                      value: classController.classes.isNotEmpty
                          ? classController.classes
                              .firstWhereOrNull((c) => c.name == className)
                          : null,
                      decoration: InputDecoration(labelText: 'Class Name'),
                      items: classController.classes.map((Class classOption) {
                        return DropdownMenuItem<Class>(
                          value: classOption,
                          child: Text(classOption.name),
                        );
                      }).toList(),
                      onChanged: (Class? selectedClass) {
                        className = selectedClass?.name ?? '';
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Class name is required';
                        }
                        return null;
                      },
                    );
                  }),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: schedule.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: schedule[index].day.isNotEmpty
                                ? schedule[index].day
                                : null, // Initial value
                            decoration: InputDecoration(labelText: 'Day Name'),
                            items: [
                              'Monday',
                              'Tuesday',
                              'Wednesday',
                              'Thursday',
                              'Friday',
                              'Saturday',
                              'Sunday'
                            ].map((String classOption) {
                              return DropdownMenuItem<String>(
                                value: classOption,
                                child: Text(classOption),
                              );
                            }).toList(),
                            onChanged: (value) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  schedule[index].day = value!;
                                });
                              });
                            },
                            // onChanged: (value) {
                            //   setState(() {
                            //     schedule[index].day = value!;
                            //   });
                            // },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Day name is required';
                              }
                              return null;
                            },
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 8, // Total number of periods
                            itemBuilder: (context, periodIndex) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Period ${periodIndex + 1}: ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Expanded(
                                      child: Obx(() {
                                        return DropdownButtonFormField<String>(
                                          value:
                                              schedule[index].periods.length >
                                                      periodIndex
                                                  ? schedule[index]
                                                      .periods[periodIndex]
                                                  : null,
                                          decoration: InputDecoration(
                                            labelText: 'Select Subject',
                                            border: OutlineInputBorder(),
                                          ),
                                          items: subjectController.subjects
                                              .map((subject) {
                                            return DropdownMenuItem<String>(
                                              value: subject
                                                  .name, // Assuming subject has a `name` field
                                              child: Text(subject.name),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              setState(() {
                                                if (schedule[index]
                                                        .periods
                                                        .length >
                                                    periodIndex) {
                                                  schedule[index].periods[
                                                      periodIndex] = value!;
                                                } else {
                                                  schedule[index]
                                                      .periods
                                                      .add(value!);
                                                }
                                              });
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select a subject for Period ${periodIndex + 1}';
                                            }
                                            return null;
                                          },
                                          isExpanded: true,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _removeDaySchedule(index),
                          ),
                        ],
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: _addDaySchedule,
                    child: Text('Add Day Schedule'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (widget.timeTable == null) {
                          timeTableController.addTimeTable(className, schedule);
                        } else {
                          timeTableController.updateTimeTable(
                              widget.timeTable!.id, className, schedule);
                        }
                        Get.back();
                      }
                    },
                    child: Text(widget.timeTable == null
                        ? 'Add TimeTable'
                        : 'Update TimeTable'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
