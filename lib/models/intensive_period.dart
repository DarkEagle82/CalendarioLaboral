import 'package:flutter/material.dart';

// Enum to define the type of rule
enum IntensiveRuleType {
  dateRange,
  weeklyOnRange,
  holidayEve,
}

// Base class for all intensive rules
abstract class IntensiveRule {
  final IntensiveRuleType type;
  final String id;

  IntensiveRule({required this.type}) : id = UniqueKey().toString();

  // Method to check if a date complies with the rule
  bool isIntensive(DateTime date, List<DateTime> holidays);

  // Method for serialization (important for saving/loading)
  Map<String, dynamic> toJson();

  // A descriptive title for the UI
  String get description;

  // Factory constructor to create the correct rule from JSON
  factory IntensiveRule.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'IntensiveRuleType.dateRange':
        return DateRangeRule.fromJson(json);
      case 'IntensiveRuleType.weeklyOnRange':
        return WeeklyOnRangeRule.fromJson(json);
      case 'IntensiveRuleType.holidayEve':
        return HolidayEveRule.fromJson(json);
      default:
        throw Exception('Unknown IntensiveRuleType');
    }
  }
}

// Rule for a specific date range
class DateRangeRule extends IntensiveRule {
  final DateTime startDate;
  final DateTime endDate;

  DateRangeRule({required this.startDate, required this.endDate})
      : super(type: IntensiveRuleType.dateRange);

  @override
  bool isIntensive(DateTime date, List<DateTime> holidays) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final normalizedStartDate = DateTime(startDate.year, startDate.month, startDate.day);
    final normalizedEndDate = DateTime(endDate.year, endDate.month, endDate.day);

    return !normalizedDate.isBefore(normalizedStartDate) && !normalizedDate.isAfter(normalizedEndDate);
  }

  @override
  String get description => 'Del ${startDate.day}/${startDate.month}/${startDate.year} al ${endDate.day}/${endDate.month}/${endDate.year}';

  @override
  Map<String, dynamic> toJson() => {
        'type': type.toString(),
        'id': id,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };

  static DateRangeRule fromJson(Map<String, dynamic> json) {
    return DateRangeRule(
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}

// Rule for a specific day of the week within a date range
class WeeklyOnRangeRule extends IntensiveRule {
  final DateTime startDate;
  final DateTime endDate;
  final int weekday; // 1 for Monday, 7 for Sunday

  WeeklyOnRangeRule({
    required this.startDate,
    required this.endDate,
    required this.weekday,
  }) : super(type: IntensiveRuleType.weeklyOnRange);

  @override
  bool isIntensive(DateTime date, List<DateTime> holidays) {
    if (date.weekday != weekday) {
      return false;
    }
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final normalizedStartDate = DateTime(startDate.year, startDate.month, startDate.day);
    final normalizedEndDate = DateTime(endDate.year, endDate.month, endDate.day);

    return !normalizedDate.isBefore(normalizedStartDate) && !normalizedDate.isAfter(normalizedEndDate);
  }

  String get _weekdayString {
      switch (weekday) {
      case 1: return 'Lunes';
      case 2: return 'Martes';
      case 3: return 'Miércoles';
      case 4: return 'Jueves';
      case 5: return 'Viernes';
      case 6: return 'Sábado';
      case 7: return 'Domingo';
      default: return '';
    }
  }

  @override
  String get description => 'Cada $_weekdayString del ${startDate.day}/${startDate.month} al ${endDate.day}/${endDate.month}';


   @override
  Map<String, dynamic> toJson() => {
        'type': type.toString(),
        'id': id,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'weekday': weekday,
      };

    static WeeklyOnRangeRule fromJson(Map<String, dynamic> json) {
    return WeeklyOnRangeRule(
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      weekday: json['weekday'],
    );
  }
}

// Rule for the day before a holiday
class HolidayEveRule extends IntensiveRule {
  HolidayEveRule() : super(type: IntensiveRuleType.holidayEve);

  @override
  bool isIntensive(DateTime date, List<DateTime> holidays) {
    // A holiday eve is intensive only if it's a working day (not weekend, not a holiday itself)
     if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return false;
    }
    
    final normalizedDate = DateTime(date.year, date.month, date.day);
    if(holidays.any((holiday) => holiday.year == normalizedDate.year && holiday.month == normalizedDate.month && holiday.day == normalizedDate.day)) {
      return false;
    }

    final nextDay = normalizedDate.add(const Duration(days: 1));
    return holidays.any((holiday) =>
        holiday.year == nextDay.year &&
        holiday.month == nextDay.month &&
        holiday.day == nextDay.day);
  }

  @override
  String get description => 'Vísperas de festivos (si son laborables)';

   @override
  Map<String, dynamic> toJson() => {
        'type': type.toString(),
        'id': id,
      };

  static HolidayEveRule fromJson(Map<String, dynamic> json) {
    return HolidayEveRule();
  }
}
