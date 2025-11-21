enum DayType { work, holiday, vacation, weekend }

class WorkDay {
  final DateTime date;
  final DayType dayType;
  final Duration duration;

  WorkDay({
    required this.date,
    this.dayType = DayType.work,
    this.duration = const Duration(hours: 7, minutes: 30),
  });
}
