import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/day_entry.dart';
import '../models/work_day.dart';
import 'settings_provider.dart';

class CalendarProvider with ChangeNotifier {
  late SettingsProvider _settingsProvider;
  Map<DateTime, DayEntry> _entries = {};
  DateTime _focusedDay = DateTime.now();
  int? _lastLoadedYear;

  Map<DateTime, DayEntry> get entries => _entries;
  DateTime get focusedDay => _focusedDay;

  CalendarProvider(SettingsProvider settingsProvider) {
    _settingsProvider = settingsProvider;
    _lastLoadedYear = _settingsProvider.selectedYear;
    _loadEntries();
  }

  void update(SettingsProvider newSettings) {
    final oldYear = _settingsProvider.selectedYear;
    _settingsProvider = newSettings;

    if (oldYear != newSettings.selectedYear) {
      _lastLoadedYear = newSettings.selectedYear;
      _loadEntries(); // This will load data for the new year and notify listeners
    } else {
      notifyListeners(); // For other settings changes like work hours, colors, etc.
    }
  }

  void setFocusedDay(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  void addEntry(DateTime day, DayEntry entry) {
    final dateWithoutTime = DateTime.utc(day.year, day.month, day.day);
    _entries[dateWithoutTime] = entry;
    _saveEntries();
    notifyListeners();
  }

  void removeEntry(DateTime day) {
    final dateWithoutTime = DateTime.utc(day.year, day.month, day.day);
    _entries.remove(dateWithoutTime);
    _saveEntries();
    notifyListeners();
  }

  void markDay(DateTime day, DayType dayType) {
    final dateWithoutTime = DateTime.utc(day.year, day.month, day.day);
    addEntry(dateWithoutTime, DayEntry(date: dateWithoutTime, dayType: dayType));
  }

  void markDaysInRange(DateTime start, DateTime end, DayType dayType) {
    for (var day = start; day.isBefore(end.add(const Duration(days: 1))); day = day.add(const Duration(days: 1))) {
      final dateWithoutTime = DateTime.utc(day.year, day.month, day.day);
      if (dateWithoutTime.weekday != DateTime.saturday && dateWithoutTime.weekday != DateTime.sunday) {
        addEntry(dateWithoutTime, DayEntry(date: dateWithoutTime, dayType: dayType));
      }
    }
    notifyListeners();
  }

  void clearDay(DateTime day) {
    removeEntry(day);
  }

  void clearDaysInRange(DateTime start, DateTime end) {
    for (var day = start; day.isBefore(end.add(const Duration(days: 1))); day = day.add(const Duration(days: 1))) {
      removeEntry(day);
    }
    notifyListeners();
  }

  DayType getDayType(DateTime day) {
    final dateWithoutTime = DateTime.utc(day.year, day.month, day.day);
    return _entries[dateWithoutTime]?.dayType ?? DayType.none;
  }

  WorkDay getWorkDay(DateTime day) {
    final intensiveRules = _settingsProvider.intensiveRules;
    bool isIntensive = intensiveRules.any((rule) => rule.isIntensive(day, []));

    return isIntensive ? _settingsProvider.intensiveWorkDay : _settingsProvider.regularWorkDay;
  }

  double get totalHoursWorked {
    double totalHours = 0.0;
    final year = _settingsProvider.selectedYear;
    final startDate = DateTime.utc(year, 1, 1);
    final endDate = DateTime.utc(year, 12, 31);

    for (var day = startDate; day.isBefore(endDate.add(const Duration(days: 1))); day = day.add(const Duration(days: 1))) {
      if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) {
        continue;
      }

      final entry = _entries[day];

      if (entry != null) {
        if (entry.dayType == DayType.holiday || entry.dayType == DayType.vacation) {
          totalHours += getWorkDay(day).hours;
        } else if (entry.dayType == DayType.work && entry.duration != null) {
          totalHours += entry.duration!.inMinutes / 60;
        } else {
          totalHours += getWorkDay(day).hours;
        }
      } else {
        totalHours += getWorkDay(day).hours;
      }
    }
    return totalHours;
  }

  int get totalWorkingDays {
    int workingDays = 0;
    final year = _settingsProvider.selectedYear;
    final startDate = DateTime.utc(year, 1, 1);
    final endDate = DateTime.utc(year, 12, 31);

    for (var day = startDate; day.isBefore(endDate.add(const Duration(days: 1))); day = day.add(const Duration(days: 1))) {
      if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) {
        continue;
      }
      final entry = _entries[day];
      if (entry != null && (entry.dayType == DayType.holiday || entry.dayType == DayType.vacation)) {
        continue;
      }
      workingDays++;
    }
    return workingDays;
  }

  double get annualHours => _settingsProvider.annualHours;

  double get remainingHours => annualHours - totalHoursWorked;

  double get equivalentDays {
    final regularDayHours = _settingsProvider.regularWorkDay.hours;
    if (remainingHours >= 0 || regularDayHours <= 0) {
      return 0;
    }
    return -remainingHours / regularDayHours;
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final year = _settingsProvider.selectedYear;
    final encodedEntries = _entries.map((key, value) => MapEntry(key.toIso8601String(), json.encode(value.toJson())));
    await prefs.setString('calendar_entries_$year', json.encode(encodedEntries));
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final year = _settingsProvider.selectedYear;
    final storedEntries = prefs.getString('calendar_entries_$year');

    if (storedEntries != null) {
      final decodedEntries = json.decode(storedEntries) as Map<String, dynamic>;
      _entries = decodedEntries.map((key, value) => MapEntry(DateTime.parse(key), DayEntry.fromJson(json.decode(value))));
    } else {
      _entries = {};
    }
    notifyListeners();
  }
}
