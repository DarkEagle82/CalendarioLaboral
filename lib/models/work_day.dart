enum DayType {
  work,
  holiday,
  vacation,
  weekend,
  intensive,
  none,
}

class WorkDay {
  final int hours;
  final int minutes;

  WorkDay({required this.hours, required this.minutes});

  double get totalHours => hours + (minutes / 60.0);

  factory WorkDay.fromJson(Map<String, dynamic> json) {
    return WorkDay(
      hours: json['hours'],
      minutes: json['minutes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hours': hours,
      'minutes': minutes,
    };
  }
}
