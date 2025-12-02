import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/intensive_period.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {

  void _showAddIntensiveRuleDialog() {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    IntensiveRuleType? selectedType = IntensiveRuleType.dateRange;
    DateTime? startDate;
    DateTime? endDate;
    int? weekday;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Añadir Regla de Jornada Intensiva'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<IntensiveRuleType>(
                  value: selectedType,
                  items: [
                    if (!settingsProvider.intensiveRules.any((r) => r.type == IntensiveRuleType.holidayEve))
                      const DropdownMenuItem(
                        value: IntensiveRuleType.holidayEve,
                        child: Text('Víspera de festivo'),
                      ),
                    const DropdownMenuItem(
                      value: IntensiveRuleType.dateRange,
                      child: Text('Rango de fechas'),
                    ),
                    const DropdownMenuItem(
                      value: IntensiveRuleType.weeklyOnRange,
                      child: Text('Día de la semana en rango'),
                    ),
                  ],
                  onChanged: (value) => setState(() => selectedType = value),
                ),
                if (selectedType == IntensiveRuleType.dateRange || selectedType == IntensiveRuleType.weeklyOnRange)
                  ...[
                    ListTile(
                      title: Text(startDate == null ? 'Fecha de inicio' : DateFormat.yMd().format(startDate!)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2101));
                        if (picked != null) setState(() => startDate = picked);
                      },
                    ),
                    ListTile(
                      title: Text(endDate == null ? 'Fecha de fin' : DateFormat.yMd().format(endDate!)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2101));
                        if (picked != null) setState(() => endDate = picked);
                      },
                    ),
                  ],
                if (selectedType == IntensiveRuleType.weeklyOnRange)
                  DropdownButton<int>(
                    value: weekday,
                    hint: const Text('Selecciona un día'),
                    items: const [
                      DropdownMenuItem(value: DateTime.monday, child: Text('Lunes')),
                      DropdownMenuItem(value: DateTime.tuesday, child: Text('Martes')),
                      DropdownMenuItem(value: DateTime.wednesday, child: Text('Miércoles')),
                      DropdownMenuItem(value: DateTime.thursday, child: Text('Jueves')),
                      DropdownMenuItem(value: DateTime.friday, child: Text('Viernes')),
                    ],
                    onChanged: (value) => setState(() => weekday = value),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                  IntensivePeriodRule newRule;
                  switch (selectedType) {
                    case IntensiveRuleType.dateRange:
                      if (startDate == null || endDate == null) return;
                      newRule = DateRangeRule(startDate: startDate!, endDate: endDate!);
                      break;
                    case IntensiveRuleType.weeklyOnRange:
                      if (startDate == null || endDate == null || weekday == null) return;
                      newRule = WeeklyOnRangeRule(startDate: startDate!, endDate: endDate!, weekdays: [weekday!]);
                      break;
                    case IntensiveRuleType.holidayEve:
                      newRule = HolidayEveRule();
                      break;
                    default:
                      return;
                  }
                  Provider.of<SettingsProvider>(context, listen: false).addIntensiveRule(newRule);
                  Navigator.of(ctx).pop();
              },
              child: const Text('Añadir'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final regularWorkdayController = TextEditingController(text: settingsProvider.regularWorkDay.totalHours.toStringAsFixed(2));
    final intensiveWorkdayController = TextEditingController(text: settingsProvider.intensiveWorkDay.totalHours.toStringAsFixed(2));
    final annualHoursController = TextEditingController(text: settingsProvider.annualHours.toStringAsFixed(2));

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jornada', style: Theme.of(context).textTheme.titleLarge),
              TextFormField(
                controller: regularWorkdayController,
                decoration: const InputDecoration(labelText: 'Horas jornada estándar'),
                keyboardType: TextInputType.number,
                onFieldSubmitted: (value) => settingsProvider.setStandardWorkdayHours(double.parse(value)),
              ),
              TextFormField(
                controller: intensiveWorkdayController,
                decoration: const InputDecoration(labelText: 'Horas jornada intensiva'),
                keyboardType: TextInputType.number,
                onFieldSubmitted: (value) => settingsProvider.setIntensiveWorkdayHours(double.parse(value)),
              ),
              const SizedBox(height: 20),
              Text('Objetivo Anual', style: Theme.of(context).textTheme.titleLarge),
              TextFormField(
                controller: annualHoursController,
                decoration: const InputDecoration(labelText: 'Horas anuales'),
                keyboardType: TextInputType.number,
                onFieldSubmitted: (value) => settingsProvider.setAnnualHoursGoal(double.parse(value)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Reglas de Jornada Intensiva', style: Theme.of(context).textTheme.titleLarge),
                  IconButton(icon: const Icon(Icons.add), onPressed: _showAddIntensiveRuleDialog),
                ],
              ),
              if (settingsProvider.intensiveRules.isEmpty)
                const Center(child: Text('No hay reglas definidas.'))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: settingsProvider.intensiveRules.length,
                  itemBuilder: (ctx, index) {
                    final rule = settingsProvider.intensiveRules[index];
                    return ListTile(
                      title: Text(rule.description),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => settingsProvider.removeIntensiveRule(rule.id),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
