import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import 'calendar_screen.dart';
import 'settings_screen.dart';
import '../l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tasks),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: l10n.calendar,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CalendarScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.settings,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return taskProvider.tasks.isEmpty
              ? Center(
                  child: Text(
                    l10n.noTasksYet,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskProvider.tasks[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      child: ListTile(
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isDone ? TextDecoration.lineThrough : null,
                            color: task.isDone ? Colors.grey : null,
                          ),
                        ),
                        leading: Checkbox(
                          value: task.isDone,
                          onChanged: (value) {
                            taskProvider.toggleTaskStatus(task.id);
                          },
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          tooltip: l10n.deleteTask,
                          onPressed: () {
                            taskProvider.deleteTask(task.id);
                          },
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, l10n),
        tooltip: l10n.addTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, AppLocalizations l10n) {
    final TextEditingController taskTitleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.addTask),
          content: TextField(
            controller: taskTitleController,
            autofocus: true,
            decoration: InputDecoration(hintText: l10n.enterTaskTitle),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(l10n.add),
              onPressed: () {
                if (taskTitleController.text.isNotEmpty) {
                  Provider.of<TaskProvider>(context, listen: false).addTask(taskTitleController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
