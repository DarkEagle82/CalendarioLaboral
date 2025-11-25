import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Color _primaryColor = Colors.deepPurple;

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // ignore: deprecated_member_use
    _primaryColor = Color(prefs.getInt('primaryColor') ?? Colors.deepPurple.value);
    final isDark = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // ignore: deprecated_member_use
    prefs.setInt('primaryColor', _primaryColor.value);
    prefs.setBool('isDarkMode', isDarkMode);
  }

  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    _saveTheme();
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    _saveTheme();
    notifyListeners();
  }

  ThemeData getTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      primaryColor: _primaryColor,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    );
  }
}
