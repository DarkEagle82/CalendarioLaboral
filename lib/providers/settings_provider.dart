import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/intensive_period.dart';
import '../models/work_day.dart';

class SettingsProvider with ChangeNotifier {
  WorkDay _regularWorkDay = WorkDay(hours: 7, minutes: 30); 
  WorkDay _intensiveWorkDay = WorkDay(hours: 7, minutes: 0);
  double _annualHours = 1620;
  List<IntensivePeriodRule> _intensiveRules = [];
  int _selectedYear = DateTime.now().year;

  WorkDay get regularWorkDay => _regularWorkDay;
  WorkDay get intensiveWorkDay => _intensiveWorkDay;
  double get annualHours => _annualHours;
  List<IntensivePeriodRule> get intensiveRules => _intensiveRules;
  int get selectedYear => _selectedYear;

  SettingsProvider() {
    _loadSettings();
  }

  void setStandardWorkdayHours(double hours) {
    final h = hours.truncate();
    final m = ((hours - h) * 60).round();
    _regularWorkDay = WorkDay(hours: h, minutes: m);
    _saveSettings();
    notifyListeners();
  }

  void setIntensiveWorkdayHours(double hours) {
    final h = hours.truncate();
    final m = ((hours - h) * 60).round();
    _intensiveWorkDay = WorkDay(hours: h, minutes: m);
    _saveSettings();
    notifyListeners();
  }

  void setAnnualHoursGoal(double hours) {
    _annualHours = hours;
    _saveSettings();
    notifyListeners();
  }

  void addIntensiveRule(IntensivePeriodRule rule) {
    _intensiveRules.add(rule);
    _saveSettings();
    notifyListeners();
  }

  void removeIntensiveRule(String id) {
    _intensiveRules.removeWhere((rule) => rule.id == id);
    _saveSettings();
    notifyListeners();
  }
  
  void setSelectedYear(int year) {
    _selectedYear = year;
    _loadSettings(); 
    notifyListeners();
  }


  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final year = _selectedYear;
    final settings = {
      'regularWorkDay': _regularWorkDay.toJson(),
      'intensiveWorkDay': _intensiveWorkDay.toJson(),
      'annualHours': _annualHours,
      'intensiveRules': _intensiveRules.map((rule) => rule.toJson()).toList(),
    };
    await prefs.setString('settings_$year', json.encode(settings));
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final year = _selectedYear;
    final settingsString = prefs.getString('settings_$year');

    if (settingsString != null) {
      final settings = json.decode(settingsString) as Map<String, dynamic>;
      _regularWorkDay = WorkDay.fromJson(settings['regularWorkDay']);
      _intensiveWorkDay = WorkDay.fromJson(settings['intensiveWorkDay']);
      _annualHours = settings['annualHours'];
      _intensiveRules = (settings['intensiveRules'] as List)
          .map((data) => IntensivePeriodRule.fromJson(data))
          .toList();
    } else {
      _regularWorkDay = WorkDay(hours: 7, minutes: 30);
      _intensiveWorkDay = WorkDay(hours: 7, minutes: 0);
      _annualHours = 1620;
      _intensiveRules = [];
    }
    notifyListeners();
  }
}
