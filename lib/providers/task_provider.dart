import 'dart:convert';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  static const _tasksKey = 'tasks';

  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);

  TaskProvider() {
    loadTasks();
  }

  void addTask(String title) {
    final newTask = Task(id: DateTime.now().toString(), title: title, creationDate: DateTime.now());
    _tasks.add(newTask);
    _saveTasks();
    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    final task = _tasks.firstWhere((task) => task.id == id);
    task.isDone = !task.isDone;
    _saveTasks();
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasks();
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksList = _tasks.map((task) => json.encode(task.toJson())).toList();
    await prefs.setStringList(_tasksKey, tasksList);
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksList = prefs.getStringList(_tasksKey);
    if (tasksList != null) {
      _tasks.clear();
      _tasks.addAll(tasksList.map((task) => Task.fromJson(json.decode(task))));
    }
    notifyListeners();
  }
}
