import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/day_entry.dart';
import '../models/work_day.dart';
import 'settings_provider.dart';

class CalendarProvider with ChangeNotifier {
  final SettingsProvider _settingsProvider;
  Map<DateTime, DayEntry> _entries = {};
  DateTime _focusedDay = DateTime.now();

  Map<DateTime, DayEntry> get entries => _entries;
  DateTime get focusedDay => _focusedDay;

  CalendarProvider(this._settingsProvider) {
    _settingsProvider.addListener(_onSettingsChanged);
    _loadEntries();
  }

  void _onSettingsChanged() {
    notifyListeners();
  }

  void setFocusedDay(DateTime day) {
    _focusedDay = day;
    notifyListeners();
  }

  void addEntry(DateTime day, DayEntry entry) {
    _entries[day] = entry;
    _saveEntries();
    notifyListeners();
  }

  void removeEntry(DateTime day) {
    _entries.remove(day);
    _saveEntries();
    notifyListeners();
  }

  void markDay(DateTime day, DayType dayType) {
    addEntry(day, DayEntry(date: day, dayType: dayType));
  }

  void markDaysInRange(DateTime start, DateTime end, DayType dayType) {
    for (var day = start; day.isBefore(end.add(const Duration(days: 1))); day = day.add(const Duration(days: 1))) {
      addEntry(day, DayEntry(date: day, dayType: dayType));
    }
  }

  void clearDay(DateTime day) {
    removeEntry(day);
  }

  DayType getDayType(DateTime day) {
    final entry = _entries[day];
    return entry?.dayType ?? DayType.none;
  }

  WorkDay getWorkDay(DateTime day) {
    final intensiveRules = _settingsProvider.intensiveRules;
    bool isIntensive = intensiveRules.any((rule) => rule.isIntensive(day, []));

    return isIntensive
        ? _settingsProvider.intensiveWorkDay
        : _settingsProvider.regularWorkDay;
  }

  double get totalHoursWorked {
    return _entries.values
        .where((entry) => entry.dayType == DayType.work && entry.duration != null)
        .fold(0.0, (sum, entry) => sum + entry.duration!.inMinutes / 60);
  }

  double get annualHours => _settingsProvider.annualHours;

  double get remainingHours => annualHours - totalHoursWorked;

  double get equivalentDays {
    final regularDayHours = _settingsProvider.regularWorkDay.hours;
    return regularDayHours > 0 ? remainingHours / regularDayHours : 0;
  }

  int get totalWorkingDays {
    return _entries.values.where((entry) => entry.dayType == DayType.work).length;
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedEntries = _entries.map((key, value) =>
        MapEntry(key.toIso8601String(), json.encode(value.toJson())));
    await prefs.setString('calendar_entries', json.encode(encodedEntries));
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEntries = prefs.getString('calendar_entries');

    if (storedEntries != null) {
      final decodedEntries = json.decode(storedEntries) as Map<String, dynamic>;
      _entries = decodedEntries.map((key, value) =>
          MapEntry(DateTime.parse(key), DayEntry.fromJson(json.decode(value))));
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _settingsProvider.removeListener(_onSettingsChanged);
    super.dispose();
  }
}
