import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/day_entry.dart';
import 'package:myapp/providers/settings_provider.dart';

class CalendarProvider with ChangeNotifier {
  Map<DateTime, DayType> _dayTypes = {};
  final SettingsProvider _settingsProvider;

  Map<DateTime, DayType> get dayTypes => _dayTypes;

  CalendarProvider(this._settingsProvider) {
    _settingsProvider.addListener(() {
      loadData();
      notifyListeners();
    });
    loadData();
  }

  void markDay(DateTime date, DayType dayType) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    _dayTypes[normalizedDate] = dayType;
    saveData();
    notifyListeners();
  }

  void markDaysInRange(DateTime start, DateTime end, DayType dayType) {
    for (var i = 0; i <= end.difference(start).inDays; i++) {
      final date = start.add(Duration(days: i));
      if (date.weekday != DateTime.saturday && date.weekday != DateTime.sunday) {
        final normalizedDate = DateTime(date.year, date.month, date.day);
        _dayTypes[normalizedDate] = dayType;
      }
    }
    saveData();
    notifyListeners();
  }

  void clearDay(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    _dayTypes.remove(normalizedDate);
    saveData();
    notifyListeners();
  }

  void clearDaysInRange(DateTime start, DateTime end) {
    for (var i = 0; i <= end.difference(start).inDays; i++) {
      final date = start.add(Duration(days: i));
      final normalizedDate = DateTime(date.year, date.month, date.day);
      _dayTypes.remove(normalizedDate);
    }
    saveData();
    notifyListeners();
  }

  DayType getDayType(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return _dayTypes[normalizedDate] ?? DayType.normal;
  }

  void saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final year = _settingsProvider.selectedYear;
    final String key = 'calendar_data_$year';
    final Map<String, int> dataToSave = {};
    _dayTypes.forEach((date, dayType) {
      dataToSave[date.toIso8601String()] = dayType.index;
    });
    prefs.setString(key, json.encode(dataToSave));
  }

  void loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final year = _settingsProvider.selectedYear;
    final String key = 'calendar_data_$year';
    final data = prefs.getString(key);
    _dayTypes.clear();
    if (data != null) {
      final Map<String, dynamic> decodedData = json.decode(data);
      _dayTypes = decodedData.map((key, value) {
        return MapEntry(DateTime.parse(key), DayType.values[value]);
      });
    }
    notifyListeners();
  }

  double get totalHoursWorked {
    double total = 0;
    final year = _settingsProvider.selectedYear;
    final startDate = DateTime(year, 1, 1);
    final endDate = DateTime(year, 12, 31);

    // First, get the list of all holidays for the year
    final List<DateTime> holidays = [];
    _dayTypes.forEach((date, dayType) {
      if (dayType == DayType.holiday) {
        holidays.add(date);
      }
    });

    for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
      final date = startDate.add(Duration(days: i));

      if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
        continue;
      }

      final dayType = getDayType(date);

      if (dayType != DayType.holiday && dayType != DayType.vacation) {
        // Pass the holidays list to the checking function
        final isIntensive = _settingsProvider.isIntensiveWorkday(date, holidays);
        if (dayType == DayType.intensive || isIntensive) {
          total += _settingsProvider.intensiveWorkdayHours;
        } else {
          total += _settingsProvider.standardWorkdayHours;
        }
      }
    }
    return total;
  }

  int get totalWorkingDays {
    int total = 0;
    final year = _settingsProvider.selectedYear;
    final startDate = DateTime(year, 1, 1);
    final endDate = DateTime(year, 12, 31);

    for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
      final date = startDate.add(Duration(days: i));

      if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
        continue;
      }

      final dayType = getDayType(date);

      if (dayType != DayType.holiday && dayType != DayType.vacation) {
        total++;
      }
    }
    return total;
  }

  double get annualHours => _settingsProvider.annualHoursGoal;

  double get remainingHours => annualHours - totalHoursWorked;

  double get equivalentDays {
    if (remainingHours >= 0) {
      return 0.0;
    }
    final extraHours = -remainingHours;
    final standardDay = _settingsProvider.standardWorkdayHours;

    if (standardDay <= 0) {
      return 0.0;
    }
    
    return extraHours / standardDay;
  }
}
