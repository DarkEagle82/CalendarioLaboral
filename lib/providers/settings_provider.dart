import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/work_day.dart';
import '../models/intensive_period.dart';

class SettingsProvider with ChangeNotifier {
  WorkDay _regularWorkDay = WorkDay(totalMinutes: 7 * 60 + 30);
  WorkDay _intensiveWorkDay = WorkDay(totalMinutes: 7 * 60);
  List<IntensiveRule> _intensiveRules = [];
  double _annualHours = 1620;
  int _selectedYear = DateTime.now().year;

  WorkDay get regularWorkDay => _regularWorkDay;
  WorkDay get intensiveWorkDay => _intensiveWorkDay;
  List<IntensiveRule> get intensiveRules => _intensiveRules;
  double get annualHours => _annualHours;
  int get selectedYear => _selectedYear;

  SettingsProvider() {
    _loadSettings();
  }

  void setRegularWorkDay(WorkDay workDay) {
    _regularWorkDay = workDay;
    _saveSettings();
    notifyListeners();
  }

  void setIntensiveWorkDay(WorkDay workDay) {
    _intensiveWorkDay = workDay;
    _saveSettings();
    notifyListeners();
  }

  void addIntensiveRule(IntensiveRule rule) {
    _intensiveRules.add(rule);
    _saveSettings();
    notifyListeners();
  }

  void removeIntensiveRule(String ruleId) {
    _intensiveRules.removeWhere((rule) => rule.id == ruleId);
    _saveSettings();
    notifyListeners();
  }

  void setAnnualHours(double hours) {
    _annualHours = hours;
    _saveSettings();
    notifyListeners();
  }

  void setSelectedYear(int year) {
    _selectedYear = year;
    notifyListeners();
  }

  void setStandardWorkdayHours(double hours) {
    final minutes = (hours * 60).round();
    _regularWorkDay = WorkDay(totalMinutes: minutes);
    _saveSettings();
    notifyListeners();
  }

  void setIntensiveWorkdayHours(double hours) {
    final minutes = (hours * 60).round();
    _intensiveWorkDay = WorkDay(totalMinutes: minutes);
    _saveSettings();
    notifyListeners();
  }
  
  void setAnnualHoursGoal(double hours) {
    _annualHours = hours;
    _saveSettings();
    notifyListeners();
  }


  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('regularWorkDay', json.encode(_regularWorkDay.toJson()));
    await prefs.setString('intensiveWorkDay', json.encode(_intensiveWorkDay.toJson()));
    await prefs.setStringList('intensiveRules', _intensiveRules.map((r) => json.encode(r.toJson())).toList());
    await prefs.setDouble('annualHours', _annualHours);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('regularWorkDay')) {
      _regularWorkDay = WorkDay.fromJson(json.decode(prefs.getString('regularWorkDay')!));
    } else {
      _regularWorkDay = WorkDay(totalMinutes: 7 * 60 + 30); // Default: 7.5 hours
    }

    if (prefs.containsKey('intensiveWorkDay')) {
      _intensiveWorkDay = WorkDay.fromJson(json.decode(prefs.getString('intensiveWorkDay')!));
    } else {
       _intensiveWorkDay = WorkDay(totalMinutes: 7 * 60); // Default: 7 hours
    }

    if (prefs.containsKey('intensiveRules')) {
      final rules = prefs.getStringList('intensiveRules')!;
      _intensiveRules = rules.map((r) => IntensiveRule.fromJson(json.decode(r))).toList();
    }
    if (prefs.containsKey('annualHours')) {
      _annualHours = prefs.getDouble('annualHours')!;
    }

    notifyListeners();
  }
}
