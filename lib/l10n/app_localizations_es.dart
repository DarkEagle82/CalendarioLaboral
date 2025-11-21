// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Lista de Tareas';

  @override
  String get tasks => 'Tareas';

  @override
  String get calendar => 'Calendario';

  @override
  String get settings => 'Configuración';

  @override
  String get addTask => 'Añadir Tarea';

  @override
  String get editTask => 'Editar Tarea';

  @override
  String get deleteTask => 'Eliminar Tarea';

  @override
  String get noTasksYet => 'No hay tareas. ¡Añade una!';

  @override
  String get taskTitle => 'Título de la Tarea';

  @override
  String get enterTaskTitle => 'Introduce el título de la tarea';

  @override
  String get add => 'AÑADIR';

  @override
  String get cancel => 'CANCELAR';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get chooseThemeColor => 'Elegir Color del Tema';

  @override
  String get pickAColor => 'Elige un color';

  @override
  String get done => 'Hecho';
}
