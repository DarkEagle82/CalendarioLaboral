import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _primaryColor = Colors.deepPurple;

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    notifyListeners();
  }
}
