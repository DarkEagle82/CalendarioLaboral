import 'package:flutter/material.dart';

class ColorProvider with ChangeNotifier {
  Color _holidayColor = Colors.red;
  Color _vacationColor = Colors.orange;
  Color _intensiveWorkdayColor = Colors.blue;

  Color get holidayColor => _holidayColor;
  Color get vacationColor => _vacationColor;
  Color get intensiveWorkdayColor => _intensiveWorkdayColor;

  void setHolidayColor(Color color) {
    _holidayColor = color;
    notifyListeners();
  }

  void setVacationColor(Color color) {
    _vacationColor = color;
    notifyListeners();
  }

  void setIntensiveWorkdayColor(Color color) {
    _intensiveWorkdayColor = color;
    notifyListeners();
  }
}
