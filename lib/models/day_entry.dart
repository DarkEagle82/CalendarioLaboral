enum DayType { work, holiday, vacation, none }

class DayEntry {
  final DayType dayType;
  final Duration? duration;

  DayEntry({required this.dayType, this.duration});

  factory DayEntry.fromJson(Map<String, dynamic> json) {
    return DayEntry(
      dayType: DayType.values[json['dayType']],
      duration: json['duration'] != null ? Duration(microseconds: json['duration']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayType': dayType.index,
      'duration': duration?.inMicroseconds,
    };
  }
}
