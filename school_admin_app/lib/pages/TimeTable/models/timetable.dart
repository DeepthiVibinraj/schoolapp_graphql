class DaySchedule {
  String day;
  List<String> periods;

  DaySchedule({required this.day, required this.periods});

  // Convert from JSON
  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      day: json['day'],
      periods: List<String>.from(json['periods']),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'periods': periods,
    };
  }
}

class TimeTable {
  String id;
  String className;
  List<DaySchedule> schedule;

  TimeTable(
      {required this.id, required this.className, required this.schedule});

  // Convert from JSON
  factory TimeTable.fromJson(Map<String, dynamic> json) {
    return TimeTable(
      id: json['id'],
      className: json['className'],
      schedule: (json['schedule'] as List)
          .map((e) => DaySchedule.fromJson(e))
          .toList(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'className': className,
      'schedule': schedule.map((s) => s.toJson()).toList(),
    };
  }
}
