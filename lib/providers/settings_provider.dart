import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/models/intensive_period.dart';

class SettingsProvider with ChangeNotifier {
  int _selectedYear = DateTime.now().year;
  double _standardWorkdayHours = 7.5;
  double _intensiveWorkdayHours = 7.0;
  double _annualHoursGoal = 1620.0;
  
  // The new flexible list of intensive rules
  List<IntensiveRule> _intensiveRules = [];

  int get selectedYear => _selectedYear;
  double get standardWorkdayHours => _standardWorkdayHours;
  double get intensiveWorkdayHours => _intensiveWorkdayHours;
  double get annualHoursGoal => _annualHoursGoal;
  List<IntensiveRule> get intensiveRules => _intensiveRules;

  SettingsProvider() {
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedYear = prefs.getInt('selectedYear') ?? DateTime.now().year;
    _standardWorkdayHours = prefs.getDouble('standardWorkdayHours') ?? 7.5;
    _intensiveWorkdayHours = prefs.getDouble('intensiveWorkdayHours') ?? 7.0;
    _annualHoursGoal = prefs.getDouble('annualHoursGoal') ?? 1620.0;

    // New logic to load the list of rules from a JSON string
    final rulesJsonString = prefs.getString('intensiveRulesJson');
    if (rulesJsonString != null) {
      final List<dynamic> decodedList = jsonDecode(rulesJsonString);
      _intensiveRules = decodedList.map((json) {
        final type = IntensiveRuleType.values.firstWhere((e) => e.toString() == json['type']);
        switch (type) {
          case IntensiveRuleType.dateRange:
            return DateRangeRule.fromJson(json);
          case IntensiveRuleType.weeklyOnRange:
            return WeeklyOnRangeRule.fromJson(json);
          case IntensiveRuleType.holidayEve:
            return HolidayEveRule.fromJson(json);
        }
      }).toList();
    }

    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedYear', _selectedYear);
    prefs.setDouble('standardWorkdayHours', _standardWorkdayHours);
    prefs.setDouble('intensiveWorkdayHours', _intensiveWorkdayHours);
    prefs.setDouble('annualHoursGoal', _annualHoursGoal);

    // New logic to save the list of rules as a JSON string
    final rulesJsonString = jsonEncode(_intensiveRules.map((rule) => rule.toJson()).toList());
    prefs.setString('intensiveRulesJson', rulesJsonString);
  }

  void setSelectedYear(int year) {
    _selectedYear = year;
    _saveSettings();
    notifyListeners();
  }

  void setStandardWorkdayHours(double hours) {
    _standardWorkdayHours = hours;
    _saveSettings();
    notifyListeners();
  }

  void setIntensiveWorkdayHours(double hours) {
    _intensiveWorkdayHours = hours;
    _saveSettings();
    notifyListeners();
  }

  void setAnnualHoursGoal(double hours) {
    _annualHoursGoal = hours;
    _saveSettings();
    notifyListeners();
  }

  // Method to add a new rule
  Future<void> addIntensiveRule(IntensiveRule rule) async {
    _intensiveRules.add(rule);
    await _saveSettings();
    notifyListeners();
  }

  // Method to remove a rule by its unique ID
  Future<void> removeIntensiveRule(String ruleId) async {
    _intensiveRules.removeWhere((rule) => rule.id == ruleId);
    await _saveSettings();
    notifyListeners();
  }

  // The heart of the new logic: checks a date against all rules.
  bool isIntensiveWorkday(DateTime date, List<DateTime> holidays) {
    for (var rule in _intensiveRules) {
      if (rule.isIntensive(date, holidays)) {
        return true; // If any rule matches, the day is intensive
      }
    }
    return false; // If no rules match, it's a standard day
  }
}
