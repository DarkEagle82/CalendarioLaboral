import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/work_day.dart';
import '../models/intensive_period.dart';

class SettingsProvider with ChangeNotifier {
  WorkDay _regularWorkDay = WorkDay(hours: 8, minutes: 0);
  WorkDay _intensiveWorkDay = WorkDay(hours: 7, minutes: 30);
  List<IntensivePeriod> _intensivePeriods = [];
  double _annualHours = 1800;

  WorkDay get regularWorkDay => _regularWorkDay;
  WorkDay get intensiveWorkDay => _intensiveWorkDay;
  List<IntensivePeriod> get intensivePeriods => _intensivePeriods;
  double get annualHours => _annualHours;

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

  void addIntensivePeriod(IntensivePeriod period) {
    _intensivePeriods.add(period);
    _saveSettings();
    notifyListeners();
  }

  void removeIntensivePeriod(int index) {
    _intensivePeriods.removeAt(index);
    _saveSettings();
    notifyListeners();
  }

  void setAnnualHours(double hours) {
    _annualHours = hours;
    _saveSettings();
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('regularWorkDay', json.encode(_regularWorkDay.toJson()));
    await prefs.setString('intensiveWorkDay', json.encode(_intensiveWorkDay.toJson()));
    await prefs.setStringList(
        'intensivePeriods', _intensivePeriods.map((p) => json.encode(p.toJson())).toList());
    await prefs.setDouble('annualHours', _annualHours);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('regularWorkDay')) {
      _regularWorkDay = WorkDay.fromJson(json.decode(prefs.getString('regularWorkDay')!));
    }
    if (prefs.containsKey('intensiveWorkDay')) {
      _intensiveWorkDay = WorkDay.fromJson(json.decode(prefs.getString('intensiveWorkDay')!));
    }
    if (prefs.containsKey('intensivePeriods')) {
      final periods = prefs.getStringList('intensivePeriods')!;
      _intensivePeriods = periods.map((p) => IntensivePeriod.fromJson(json.decode(p))).toList();
    }
    if (prefs.containsKey('annualHours')) {
      _annualHours = prefs.getDouble('annualHours')!;
    }

    notifyListeners();
  }
}
