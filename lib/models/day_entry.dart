enum DayType { normal, holiday, vacation, intensive }

class DayEntry {
  final DateTime date;
  final DayType dayType;

  DayEntry({required this.date, required this.dayType});
}
