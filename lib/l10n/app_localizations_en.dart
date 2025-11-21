// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'To-Do List';

  @override
  String get tasks => 'Tasks';

  @override
  String get calendar => 'Calendar';

  @override
  String get settings => 'Settings';

  @override
  String get addTask => 'Add Task';

  @override
  String get editTask => 'Edit Task';

  @override
  String get deleteTask => 'Delete Task';

  @override
  String get noTasksYet => 'No tasks yet. Add one!';

  @override
  String get taskTitle => 'Task Title';

  @override
  String get enterTaskTitle => 'Enter task title';

  @override
  String get add => 'ADD';

  @override
  String get cancel => 'CANCEL';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get chooseThemeColor => 'Choose App Theme Color';

  @override
  String get pickAColor => 'Pick a color';

  @override
  String get done => 'Done';
}
