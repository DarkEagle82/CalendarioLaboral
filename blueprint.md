# Blueprint: To-Do List App

## Overview

A simple, yet powerful To-Do list application built with Flutter. It allows users to manage their tasks, view them on a calendar, and customize the app's theme.

## Core Features

- **Task Management:** Add, edit, delete, and mark tasks as complete.
- **Data Persistence:** Tasks are saved locally on the device.
- **Calendar View:** A calendar screen to visualize tasks by date.
- **Customization:** Change the primary theme color and switch between light and dark modes.
- **Internationalization (i18n):** Support for English and Spanish languages.

## Project Structure

```
lib/
|-- models/
|   `-- task.dart
|-- providers/
|   |-- task_provider.dart
|   `-- theme_provider.dart
|-- screens/
|   |-- calendar_screen.dart
|   |-- home_page.dart
|   `-- settings_screen.dart
|-- l10n/
|   |-- app_en.arb
|   `-- app_es.arb
`-- main.dart
```

## Feature Implementation Plan

### 1. Basic To-Do List (Completed)

- [x] Set up basic Flutter project structure.
- [x] Create `Task` model.
- [x] Implement `TaskProvider` for state management using `ChangeNotifier`.
- [x] Build the main screen (`HomePage`) to display the list of tasks.
- [x] Implement adding new tasks via a `FloatingActionButton` and `AlertDialog`.
- [x] Implement toggling task completion status.
- [x] Implement deleting tasks.

### 2. Data Persistence (Completed)

- [x] Add `shared_preferences` package.
- [x] Add serialization methods (`toJson`, `fromJson`) to the `Task` model.
- [x] Implement `saveTasks` and `loadTasks` in `TaskProvider`.
- [x] Call `loadTasks` on provider initialization.
- [x] Call `saveTasks` after any modification to the task list.

### 3. Calendar View (Completed)

- [x] Add `table_calendar` package.
- [x] Add a `creationDate` to the `Task` model.
- [x] Create `CalendarScreen` widget.
- [x] Implement `TableCalendar` to display tasks.
- [x] Add navigation to `CalendarScreen` from `HomePage`.

### 4. Theme Customization (Completed)

- [x] Add `provider` and `flutter_colorpicker` packages.
- [x] Create `ThemeProvider` to manage app theme (primary color, light/dark mode).
- [x] Create `SettingsScreen` widget.
- [x] Add a color picker to `SettingsScreen` to change the primary color.
- [x] Add a switch to toggle between light and dark mode.
- [x] Use `MultiProvider` to provide both `TaskProvider` and `ThemeProvider`.
- [x] Apply the dynamic theme to `MaterialApp`.

### 5. Code Refactoring & UI Polish (Completed)

- [x] Reorganize project structure into `models`, `providers`, and `screens` folders.
- [x] Implement a full Material 3 `ThemeData` using `ColorScheme.fromSeed` and `google_fonts`.
- [x] Use `Card` widgets for a cleaner task list UI.
- [x] Add a placeholder message for when the task list is empty.

### 6. Internationalization (i18n) (Current)

- [ ] Add `flutter_localizations` to `pubspec.yaml`.
- [ ] Create `l10n.yaml` configuration file.
- [ ] Create `.arb` translation files for English and Spanish.
- [ ] Configure `MaterialApp` with `localizationsDelegates` and `supportedLocales`.
- [ ] Run `flutter gen-l10n` to generate localization code.
- [ ] Replace hardcoded UI strings with generated localization keys.

