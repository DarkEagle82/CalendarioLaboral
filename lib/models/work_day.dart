enum DayType { work, holiday, vacation, weekend, none, intensive }

class WorkDay {
  final int totalMinutes;

  WorkDay({required this.totalMinutes});

  int get hours => totalMinutes ~/ 60;
  int get minutes => totalMinutes % 60;

  Map<String, dynamic> toJson() => {
        'totalMinutes': totalMinutes,
      };

  factory WorkDay.fromJson(Map<String, dynamic> json) {
    return WorkDay(
      totalMinutes: json['totalMinutes'],
    );
  }

  @override
  String toString() {
    return '$hours:${minutes.toString().padLeft(2, '0')}';
  }
}
