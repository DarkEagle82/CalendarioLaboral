import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/holiday.dart';
import '../services/storage_service.dart';

class CalendarProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  Map<DateTime, List<Holiday>> _events = {};

  // --- Versioning for forcing widget rebuild ---
  int _calendarKey = 0;
  int get calendarKey => _calendarKey;
  // ------------------------------------------

  // --- Color Management ---
  Color _festivoColor = Colors.red;
  Color _vacacionesColor = const Color.fromRGBO(255, 192, 0, 1);
  Color _intensivaColor = Colors.green;

  Color get festivoColor => _festivoColor;
  Color get vacacionesColor => _vacacionesColor;
  Color get intensivaColor => _intensivaColor;
  // ------------------------

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  Duration _standardWorkday = const Duration(hours: 7, minutes: 30);
  Duration _intensiveWorkday = const Duration(hours: 7);
  int _annualGoalHours = 1620;

  UnmodifiableMapView<DateTime, List<Holiday>> get events => UnmodifiableMapView(_events);
  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;
  DateTime? get rangeStart => _rangeStart;
  DateTime? get rangeEnd => _rangeEnd;
  RangeSelectionMode get rangeSelectionMode => _rangeSelectionMode;
  Duration get standardWorkday => _standardWorkday;
  Duration get intensiveWorkday => _intensiveWorkday;
  int get annualGoalHours => _annualGoalHours;

  CalendarProvider() {
    _selectedDay = _focusedDay;
  }

  Future<void> init() async {
    await _loadData();
    await _loadPreferences(); // Cargar colores al iniciar
  }

  void _incrementCalendarKey() {
    _calendarKey++;
  }

  // --- Preference & Color Loading/Saving ---
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _festivoColor = Color(prefs.getInt('festivoColor') ?? _festivoColor.value);
    _vacacionesColor = Color(prefs.getInt('vacacionesColor') ?? _vacacionesColor.value);
    _intensivaColor = Color(prefs.getInt('intensivaColor') ?? _intensivaColor.value);
    notifyListeners();
  }

  Future<void> updateColor(String type, Color color) async {
    final prefs = await SharedPreferences.getInstance();
    switch (type) {
      case 'festivo':
        _festivoColor = color;
        await prefs.setInt('festivoColor', color.value);
        break;
      case 'vacaciones':
        _vacacionesColor = color;
        await prefs.setInt('vacacionesColor', color.value);
        break;
      case 'intensiva':
        _intensivaColor = color;
        await prefs.setInt('intensivaColor', color.value);
        break;
    }
    notifyListeners();
  }
  // ----------------------------------------

  Future<void> _loadData() async {
    _events = await _storageService.loadEvents();
    final settings = await _storageService.loadSettings();
    _standardWorkday = Duration(minutes: settings['standardWorkday']);
    _intensiveWorkday = Duration(minutes: settings['intensiveWorkday']);
    _annualGoalHours = settings['annualGoalHours'];
    _incrementCalendarKey();
    notifyListeners();
  }

  Future<void> _saveEvents() async {
    await _storageService.saveEvents(_events);
  }

  Future<void> _saveSettings() async {
    await _storageService.saveSettings(
      standardWorkday: _standardWorkday,
      intensiveWorkday: _intensiveWorkday,
      annualGoalHours: _annualGoalHours,
    );
  }

  List<Holiday> getEventsForDay(DateTime day) {
    final utcDay = DateTime.utc(day.year, day.month, day.day);
    return _events[utcDay] ?? [];
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (selectedDay.weekday == DateTime.saturday || selectedDay.weekday == DateTime.sunday) {
        return;
    }
    if (!isSameDay(_selectedDay, selectedDay)) {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _rangeStart = null;
      _rangeEnd = null;
      _rangeSelectionMode = RangeSelectionMode.toggledOff;
      notifyListeners();
    }
  }

  void onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    _selectedDay = null;
    _focusedDay = focusedDay;
    _rangeStart = start;
    _rangeEnd = end;
    _rangeSelectionMode = RangeSelectionMode.toggledOn;
    notifyListeners();
  }
  
  void addHolidayForSingleDay(String name, String type) {
    if (_selectedDay == null) return;
    
    final utcDay = DateTime.utc(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    final holiday = Holiday(name: name, date: utcDay, type: type);

    _events[utcDay] = _events[utcDay] ?? [];
    if (!_events[utcDay]!.any((h) => h.name == name && h.type == type)) {
        _events[utcDay]!.add(holiday);
    }

    _events = LinkedHashMap.from(_events);
    _incrementCalendarKey();
    _saveEvents();
    notifyListeners();
  }

  void addHolidaysForRange(String name, String type) {
    if (_rangeStart == null || _rangeEnd == null) return;

    for (var day = _rangeStart!; day.isBefore(_rangeEnd!.add(const Duration(days: 1))); day = day.add(const Duration(days: 1))) {
      if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) {
        continue;
      }
      final utcDay = DateTime.utc(day.year, day.month, day.day);
      final holiday = Holiday(name: name, date: utcDay, type: type);
      
      _events[utcDay] = _events[utcDay] ?? [];
      if (!_events[utcDay]!.any((h) => h.name == name && h.type == type)) {
          _events[utcDay]!.add(holiday);
      }
    }
    
    _events = LinkedHashMap.from(_events);
    _incrementCalendarKey();
    _saveEvents();
    notifyListeners();
  }

  void clearHolidaysInRange() {
    DateTime? start = _rangeStart;
    DateTime? end = _rangeEnd;

    if (start == null && _selectedDay != null) {
      start = _selectedDay;
      end = _selectedDay;
    }

    if (start == null) return;
    end ??= start;

    for (var day = start; day.isBefore(end.add(const Duration(days: 1))); day = day.add(const Duration(days: 1))) {
      final utcDay = DateTime.utc(day.year, day.month, day.day);
      _events.remove(utcDay);
    }

    _events = LinkedHashMap.from(_events);
    _incrementCalendarKey();
    _saveEvents();
    notifyListeners();
  }

  void setStandardWorkday(Duration duration) {
    _standardWorkday = duration;
    _saveSettings();
    notifyListeners();
  }

  void setIntensiveWorkday(Duration duration) {
    _intensiveWorkday = duration;
    _saveSettings();
    notifyListeners();
  }

  void setAnnualGoalHours(int hours) {
    _annualGoalHours = hours;
    _saveSettings();
    notifyListeners();
  }

  Map<String, dynamic> calculateSummary() {
    int workDays = 0;
    int vacationDays = 0;
    int holidayDays = 0;
    double totalWorkedHours = 0;

    final year = _focusedDay.year;
    final firstDayOfYear = DateTime.utc(year, 1, 1);
    final lastDayOfYear = DateTime.utc(year, 12, 31);

    for (var day = firstDayOfYear; day.isBefore(lastDayOfYear.add(const Duration(days: 1))); day = day.add(const Duration(days: 1))) {
      final weekday = day.weekday;
      if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
        continue;
      }

      final dayEvents = getEventsForDay(day);

      bool isVacation = dayEvents.any((event) => event.type == 'vacaciones');
      bool isHoliday = dayEvents.any((event) => event.type == 'festivo');

      if(isHoliday){
        holidayDays++;
        continue;
      }
      if(isVacation){
        vacationDays++;
        continue;
      }

      workDays++;
      if (dayEvents.any((event) => event.type == 'intensiva')) {
        totalWorkedHours += _intensiveWorkday.inMinutes / 60.0;
      } else {
        totalWorkedHours += _standardWorkday.inMinutes / 60.0;
      }
    }

    final double remainingHours = _annualGoalHours - totalWorkedHours;
    final double progress = _annualGoalHours > 0 ? totalWorkedHours / _annualGoalHours : 0.0;

    return {
      'workDays': workDays,
      'targetHours': _annualGoalHours,
      'vacationDays': vacationDays,
      'holidayDays': holidayDays,
      'workedHours': totalWorkedHours,
      'remainingHours': remainingHours,
      'progress': progress.clamp(0.0, 1.0),
    };
  }
}
