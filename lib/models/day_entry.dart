import 'package:flutter/material.dart';
import 'package:myapp/models/work_day.dart';

class DayEntry {
  final DateTime date;
  final DayType dayType;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Duration? pauseDuration;

  DayEntry({
    required this.date,
    required this.dayType,
    this.startTime,
    this.endTime,
    this.pauseDuration,
  });

  Duration? get duration {
    if (startTime == null || endTime == null) {
      return null;
    }
    final start = DateTime(date.year, date.month, date.day, startTime!.hour, startTime!.minute);
    final end = DateTime(date.year, date.month, date.day, endTime!.hour, endTime!.minute);
    return end.difference(start) - (pauseDuration ?? Duration.zero);
  }

  DayEntry copyWith({
    DayType? dayType,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    Duration? pauseDuration,
  }) {
    return DayEntry(
      date: date,
      dayType: dayType ?? this.dayType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      pauseDuration: pauseDuration ?? this.pauseDuration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'dayType': dayType.toString(),
      'startTime': startTime != null ? '${startTime!.hour}:${startTime!.minute}' : null,
      'endTime': endTime != null ? '${endTime!.hour}:${endTime!.minute}' : null,
      'pauseDuration': pauseDuration?.inSeconds,
    };
  }

  factory DayEntry.fromJson(Map<String, dynamic> json) {
    return DayEntry(
      date: DateTime.parse(json['date']),
      dayType: DayType.values.firstWhere((e) => e.toString() == json['dayType']),
      startTime: json['startTime'] != null
          ? TimeOfDay(
              hour: int.parse(json['startTime'].split(':')[0]),
              minute: int.parse(json['startTime'].split(':')[1]),
            )
          : null,
      endTime: json['endTime'] != null
          ? TimeOfDay(
              hour: int.parse(json['endTime'].split(':')[0]),
              minute: int.parse(json['endTime'].split(':')[1]),
            )
          : null,
      pauseDuration: json['pauseDuration'] != null
          ? Duration(seconds: json['pauseDuration'])
          : null,
    );
  }
}
