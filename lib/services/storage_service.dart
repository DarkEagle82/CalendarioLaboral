import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../models/holiday.dart';

class StorageService {
  static const String _eventsKey = 'events';
  static const String _settingsKey = 'settings';

  // --- Hard Reset Function ---
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    debugPrint("¡Todos los datos almacenados han sido borrados!");
  }
  // -------------------------

  // Guardar eventos
  Future<void> saveEvents(Map<DateTime, List<Holiday>> events) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> encodedData = events.map((key, value) {
      return MapEntry(key.toIso8601String(), value.map((e) => e.toJson()).toList());
    });
    await prefs.setString(_eventsKey, json.encode(encodedData));
  }

  // Cargar eventos
  Future<Map<DateTime, List<Holiday>>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final String? eventsString = prefs.getString(_eventsKey);

    if (eventsString == null) {
      return {};
    }
    try {
      final Map<String, dynamic> decodedData = json.decode(eventsString);
      return decodedData.map((key, value) {
        final date = DateTime.parse(key);
        final holidays = (value as List).map((item) => Holiday.fromJson(item)).toList();
        return MapEntry(date, holidays);
      });
    } catch (e) {
      debugPrint("Error al decodificar eventos, borrando datos corruptos: $e");
      await clearAllData();
      return {}; // Retorna vacío tras limpiar
    }
  }

  // Guardar configuración
  Future<void> saveSettings({
    required Duration standardWorkday,
    required Duration intensiveWorkday,
    required int annualGoalHours,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final settings = {
      'standardWorkday': standardWorkday.inMinutes,
      'intensiveWorkday': intensiveWorkday.inMinutes,
      'annualGoalHours': annualGoalHours,
    };
    await prefs.setString(_settingsKey, json.encode(settings));
  }

  // Cargar configuración
  Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? settingsString = prefs.getString(_settingsKey);

    if (settingsString == null) {
      return _defaultSettings();
    }
    try {
      return json.decode(settingsString);
    } catch (e) {
      debugPrint("Error al decodificar configuración, borrando datos corruptos: $e");
      await clearAllData();
      return _defaultSettings(); // Retorna por defecto tras limpiar
    }
  }

  Map<String, dynamic> _defaultSettings() {
    return {
        'standardWorkday': const Duration(hours: 7, minutes: 30).inMinutes,
        'intensiveWorkday': const Duration(hours: 7).inMinutes,
        'annualGoalHours': 1620,
      };
  }
}
