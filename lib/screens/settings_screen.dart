import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mi_calendario/l10n/app_localizations.dart';
import 'package:mi_calendario/models/intensive_period.dart';
import 'package:mi_calendario/providers/color_provider.dart';
import 'package:mi_calendario/providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with AutomaticKeepAliveClientMixin {
  late TextEditingController _standardWorkdayController;
  late TextEditingController _intensiveWorkdayController;
  late TextEditingController _annualHoursController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    _standardWorkdayController = TextEditingController(text: settingsProvider.standardWorkdayHours.toString());
    _intensiveWorkdayController = TextEditingController(text: settingsProvider.intensiveWorkdayHours.toString());
    _annualHoursController = TextEditingController(text: settingsProvider.annualHoursGoal.toString());
  }

  @override
  void dispose() {
    _standardWorkdayController.dispose();
    _intensiveWorkdayController.dispose();
    _annualHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final colorProvider = Provider.of<ColorProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.settings, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              Text(l10n.chooseThemeColor, style: Theme.of(context).textTheme.titleLarge),
              _buildColorSettings(l10n, colorProvider),
              const SizedBox(height: 24),
              Text(l10n.workdayHours, style: Theme.of(context).textTheme.titleLarge),
              _buildHoursSettings(l10n, settingsProvider),
              const SizedBox(height: 24),
              Text("Reglas de Jornada Intensiva", style: Theme.of(context).textTheme.titleLarge),
              _buildIntensiveRulesList(context, settingsProvider, l10n),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRuleTypeDialog(context, settingsProvider, l10n),
        child: const Icon(Icons.add),
        tooltip: "Añadir Regla",
      ),
    );
  }

  Widget _buildIntensiveRulesList(BuildContext context, SettingsProvider settingsProvider, AppLocalizations l10n) {
    if (settingsProvider.intensiveRules.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(child: Text("No hay reglas definidas. Pulsa '+' para añadir una.")),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: settingsProvider.intensiveRules.length,
      itemBuilder: (context, index) {
        final rule = settingsProvider.intensiveRules[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(rule.description, style: Theme.of(context).textTheme.bodyLarge),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _showDeleteConfirmationDialog(context, settingsProvider, rule.id, l10n),
              tooltip: l10n.delete,
            ),
          ),
        );
      },
    );
  }

  void _showAddRuleTypeDialog(BuildContext context, SettingsProvider settingsProvider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Seleccionar tipo de regla"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text("Rango de Fechas"),
              onTap: () {
                Navigator.of(context).pop();
                _showAddDateRangeRuleDialog(context, settingsProvider, l10n);
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_week),
              title: const Text("Día semanal en un rango"),
              onTap: () {
                 Navigator.of(context).pop();
                _showAddWeeklyRuleDialog(context, settingsProvider, l10n);
              },
            ),
             if (!settingsProvider.intensiveRules.any((r) => r.type == IntensiveRuleType.holidayEve))
              ListTile(
                leading: const Icon(Icons.celebration),
                title: const Text("Víspera de festivo"),
                onTap: () {
                  Navigator.of(context).pop();
                  settingsProvider.addIntensiveRule(HolidayEveRule());
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddDateRangeRuleDialog(BuildContext context, SettingsProvider settingsProvider, AppLocalizations l10n) async {
    final selectedYear = settingsProvider.selectedYear;
    DateTime? startDate = await _selectDate(context, DateTime(selectedYear));
    if (startDate == null) return;

    DateTime? endDate = await _selectDate(context, startDate);
    if (endDate == null) return;

    if (endDate.isBefore(startDate)) {
      // Show error
      return;
    }

    settingsProvider.addIntensiveRule(DateRangeRule(startDate: startDate, endDate: endDate));
  }

  Future<void> _showAddWeeklyRuleDialog(BuildContext context, SettingsProvider settingsProvider, AppLocalizations l10n) async {
    final selectedYear = settingsProvider.selectedYear;
    int selectedWeekday = 1; 

    DateTime? startDate = await _selectDate(context, DateTime(selectedYear, 1, 1));
    if (startDate == null) return;

    DateTime? endDate = await _selectDate(context, DateTime(selectedYear, 12, 31));
    if (endDate == null) return;

    if (endDate.isBefore(startDate)) {
      // show error
      return;
    }

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Selecciona el día de la semana'),
          content: DropdownButton<int>(
            value: selectedWeekday,
            onChanged: (int? newValue) {
              if (newValue != null) {
                Navigator.of(dialogContext).pop(newValue);
              }
            },
            items: List.generate(7, (index) => 
              DropdownMenuItem<int>(
                value: index + 1,
                child: Text(['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'][index]),
              )
            ),
          ),
        );
      },
    ).then((chosenWeekday) {
        if(chosenWeekday != null) {
          final rule = WeeklyOnRangeRule(startDate: startDate, endDate: endDate, weekday: chosenWeekday);
          settingsProvider.addIntensiveRule(rule);
        }
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, SettingsProvider settingsProvider, String ruleId, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeletion),
        content: Text(l10n.areYouSureYouWantToDeleteThisRule),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () {
              settingsProvider.removeIntensiveRule(ruleId);
              Navigator.of(context).pop();
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }


  Widget _buildColorSettings(AppLocalizations l10n, ColorProvider colorProvider) {
    return Column(
      children: [
        ListTile(
          title: Text(l10n.holiday),
          trailing: CircleAvatar(backgroundColor: colorProvider.holidayColor),
          onTap: () => _showColorPicker(context, l10n, colorProvider.holidayColor, (color) => colorProvider.setHolidayColor(color)),
        ),
        ListTile(
          title: Text(l10n.vacation),
          trailing: CircleAvatar(backgroundColor: colorProvider.vacationColor),
          onTap: () => _showColorPicker(context, l10n, colorProvider.vacationColor, (color) => colorProvider.setVacationColor(color)),
        ),
        ListTile(
          title: Text(l10n.intensiveWorkday),
          trailing: CircleAvatar(backgroundColor: colorProvider.intensiveWorkdayColor),
          onTap: () => _showColorPicker(context, l10n, colorProvider.intensiveWorkdayColor, (color) => colorProvider.setIntensiveWorkdayColor(color)),
        ),
      ],
    );
  }

  Widget _buildHoursSettings(AppLocalizations l10n, SettingsProvider settingsProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _standardWorkdayController,
          decoration: InputDecoration(labelText: l10n.standardWorkdayHours),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSubmitted: (value) {
            try { settingsProvider.setStandardWorkdayHours(double.parse(value)); } catch(e) {/* ignore */}
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _intensiveWorkdayController,
          decoration: InputDecoration(labelText: l10n.intensiveWorkdayHours),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSubmitted: (value) {
            try { settingsProvider.setIntensiveWorkdayHours(double.parse(value)); } catch(e) {/* ignore */}
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _annualHoursController,
          decoration: InputDecoration(labelText: l10n.annualHoursGoal),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSubmitted: (value) {
            try { settingsProvider.setAnnualHoursGoal(double.parse(value)); } catch(e) {/* ignore */}
          },
        ),
      ],
    );
  }

  void _showColorPicker(BuildContext context, AppLocalizations l10n, Color initialColor, void Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.pickAColor),
        content: SingleChildScrollView(child: ColorPicker(pickerColor: initialColor, onColorChanged: onColorChanged)),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.done))],
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context, DateTime initialDate) async {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final selectedYear = settingsProvider.selectedYear;
    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(selectedYear - 5, 1, 1),
      lastDate: DateTime(selectedYear + 5, 12, 31),
    );
  }
}
