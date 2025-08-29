class TimeTable {
  final String className;
  final List<DaySchedule> schedule;

  TimeTable({required this.className, required this.schedule});

  factory TimeTable.fromJson(Map<String, dynamic> json) {
    return TimeTable(
      className: json['className'],
      schedule: (json['schedule'] as List)
          .map((item) => DaySchedule.fromJson(item))
          .toList(),
    );
  }
}

class DaySchedule {
  final String day;
  final List<String> periods;

  DaySchedule({required this.day, required this.periods});

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      day: json['day'],
      periods: List<String>.from(json['periods']),
    );
  }
}
