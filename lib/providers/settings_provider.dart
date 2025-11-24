import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  int _selectedYear = DateTime.now().year;
  double _standardWorkdayHours = 7.5;
  double _intensiveWorkdayHours = 7.0;
  double _annualHoursGoal = 1620.0;
  DateTime _intensiveWorkdayStartDate = DateTime(DateTime.now().year, 6, 10);
  DateTime _intensiveWorkdayEndDate = DateTime(DateTime.now().year, 9, 13);

  int get selectedYear => _selectedYear;
  double get standardWorkdayHours => _standardWorkdayHours;
  double get intensiveWorkdayHours => _intensiveWorkdayHours;
  double get annualHoursGoal => _annualHoursGoal;
  DateTime get intensiveWorkdayStartDate => _intensiveWorkdayStartDate;
  DateTime get intensiveWorkdayEndDate => _intensiveWorkdayEndDate;

  SettingsProvider() {
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedYear = prefs.getInt('selectedYear') ?? DateTime.now().year;
    _standardWorkdayHours = prefs.getDouble('standardWorkdayHours') ?? 7.5;
    _intensiveWorkdayHours = prefs.getDouble('intensiveWorkdayHours') ?? 7.0;
    _annualHoursGoal = prefs.getDouble('annualHoursGoal') ?? 1620.0;

    final startDateString = prefs.getString('intensiveWorkdayStartDate');
    if (startDateString != null) {
      final loadedStartDate = DateTime.parse(startDateString);
      _intensiveWorkdayStartDate = DateTime(_selectedYear, loadedStartDate.month, loadedStartDate.day);
    } else {
      _intensiveWorkdayStartDate = DateTime(_selectedYear, 6, 10);
    }

    final endDateString = prefs.getString('intensiveWorkdayEndDate');
    if (endDateString != null) {
      final loadedEndDate = DateTime.parse(endDateString);
      _intensiveWorkdayEndDate = DateTime(_selectedYear, loadedEndDate.month, loadedEndDate.day);
    } else {
       _intensiveWorkdayEndDate = DateTime(_selectedYear, 9, 13);
    }

    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedYear', _selectedYear);
    prefs.setDouble('standardWorkdayHours', _standardWorkdayHours);
    prefs.setDouble('intensiveWorkdayHours', _intensiveWorkdayHours);
    prefs.setDouble('annualHoursGoal', _annualHoursGoal);
    // Save only month and day for intensive period, to apply it to any year
    prefs.setString('intensiveWorkdayStartDate', DateTime(2000, _intensiveWorkdayStartDate.month, _intensiveWorkdayStartDate.day).toIso8601String());
    prefs.setString('intensiveWorkdayEndDate', DateTime(2000, _intensiveWorkdayEndDate.month, _intensiveWorkdayEndDate.day).toIso8601String());
  }

  void setSelectedYear(int year) {
    _selectedYear = year;
    // Update intensive dates to reflect the new year
    _intensiveWorkdayStartDate = DateTime(_selectedYear, _intensiveWorkdayStartDate.month, _intensiveWorkdayStartDate.day);
    _intensiveWorkdayEndDate = DateTime(_selectedYear, _intensiveWorkdayEndDate.month, _intensiveWorkdayEndDate.day);
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

  void setIntensiveWorkdayStartDate(DateTime date) {
    _intensiveWorkdayStartDate = date;
    _saveSettings();
    notifyListeners();
  }

  void setIntensiveWorkdayEndDate(DateTime date) {
    _intensiveWorkdayEndDate = date;
    _saveSettings();
    notifyListeners();
  }

  bool isIntensiveWorkday(DateTime date) {
    // Make sure comparison is within the same year
    final dateInSelectedYear = DateTime(_selectedYear, date.month, date.day);
    return dateInSelectedYear.isAfter(intensiveWorkdayStartDate.subtract(const Duration(days: 1))) && 
           dateInSelectedYear.isBefore(intensiveWorkdayEndDate.add(const Duration(days: 1)));
  }
}
