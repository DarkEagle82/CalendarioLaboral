import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/models/intensive_period.dart';
import 'package:myapp/providers/color_provider.dart';
import 'package:myapp/providers/settings_provider.dart';
import 'package:myapp/providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _standardWorkdayController;
  late TextEditingController _intensiveWorkdayController;
  late TextEditingController _annualHoursController;

  @override
  void initState() {
    super.initState();
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    _standardWorkdayController = TextEditingController(text: settingsProvider.regularWorkDay.toString());
    _intensiveWorkdayController = TextEditingController(text: settingsProvider.intensiveWorkDay.toString());
    _annualHoursController = TextEditingController(text: settingsProvider.annualHours.toString());
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
              _buildThemeSection(l10n),
              const SizedBox(height: 16),
              _buildColorSettings(l10n, colorProvider),
              const SizedBox(height: 24),
              Text(l10n.workdayHours, style: Theme.of(context).textTheme.titleLarge),
              _buildHoursSettings(l10n, settingsProvider),
              const SizedBox(height: 24),
              Text(l10n.intensivePeriods, style: Theme.of(context).textTheme.titleLarge),
              _buildIntensiveRulesList(settingsProvider, l10n),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRuleTypeDialog(settingsProvider, l10n),
        tooltip: l10n.addRule,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildThemeSection(AppLocalizations l10n) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      children: [
        Text(l10n.theme, style: Theme.of(context).textTheme.titleLarge),
        const Spacer(),
        IconButton(
          icon: Icon(themeProvider.themeMode == ThemeMode.dark 
                       ? Icons.light_mode 
                       : Icons.dark_mode_outlined),
          tooltip: l10n.darkMode,
          onPressed: () => themeProvider.toggleTheme(),
        ),
      ],
    );
  }

  Widget _buildIntensiveRulesList(SettingsProvider settingsProvider, AppLocalizations l10n) {
    if (settingsProvider.intensiveRules.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Center(child: Text(l10n.noRulesDefined)),
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
              onPressed: () => _showDeleteConfirmationDialog(settingsProvider, rule.id, l10n),
              tooltip: l10n.delete,
            ),
          ),
        );
      },
    );
  }

  void _showAddRuleTypeDialog(SettingsProvider settingsProvider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.ruleType),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.date_range),
              title: Text(l10n.dateRange),
              onTap: () {
                Navigator.of(dialogContext).pop();
                _showAddDateRangeRuleDialog(settingsProvider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_week),
              title: Text(l10n.weeklyOnRange),
              onTap: () {
                Navigator.of(dialogContext).pop();
                _showAddWeeklyRuleDialog(settingsProvider, l10n);
              },
            ),
            if (!settingsProvider.intensiveRules.any((r) => r.type == IntensiveRuleType.holidayEve))
              ListTile(
                leading: const Icon(Icons.celebration),
                title: Text(l10n.holidayEve),
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  settingsProvider.addIntensiveRule(HolidayEveRule());
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddDateRangeRuleDialog(SettingsProvider settingsProvider) async {
    final selectedYear = settingsProvider.selectedYear;
    DateTime? startDate = await _selectDate(DateTime(selectedYear));
    if (startDate == null) return;

    if (!mounted) return;

    DateTime? endDate = await _selectDate(startDate);
    if (endDate == null) return;

    if (endDate.isBefore(startDate)) {
      // Optionally, show an error to the user
      return;
    }

    settingsProvider.addIntensiveRule(DateRangeRule(startDate: startDate, endDate: endDate));
  }

  Future<void> _showAddWeeklyRuleDialog(SettingsProvider settingsProvider, AppLocalizations l10n) async {
    final selectedYear = settingsProvider.selectedYear;

    DateTime? startDate = await _selectDate(DateTime(selectedYear, 1, 1));
    if (startDate == null) return;

    if (!mounted) return;

    DateTime? endDate = await _selectDate(DateTime(selectedYear, 12, 31));
    if (endDate == null) return;

    if (endDate.isBefore(startDate)) {
      // Optionally, show an error to the user
      return;
    }

    if (!mounted) return;

    final int? chosenWeekday = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.selectWeekDay),
          content: DropdownButton<int>(
            value: 1,
            onChanged: (int? newValue) {
              if (newValue != null) {
                Navigator.of(dialogContext).pop(newValue);
              }
            },
            items: List.generate(
              7,
              (index) => DropdownMenuItem<int>(
                value: index + 1,
                child: Text([
                  l10n.monday,
                  l10n.tuesday,
                  l10n.wednesday,
                  l10n.thursday,
                  l10n.friday,
                  l10n.saturday,
                  l10n.sunday
                ][index]),
              ),
            ),
          ),
        );
      },
    );

    if (chosenWeekday != null) {
      final rule = WeeklyOnRangeRule(startDate: startDate, endDate: endDate, weekday: chosenWeekday);
      settingsProvider.addIntensiveRule(rule);
    }
  }

  void _showDeleteConfirmationDialog(SettingsProvider settingsProvider, String ruleId, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.confirmDeletion),
        content: Text(l10n.areYouSureYouWantToDeleteThisRule),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () {
              settingsProvider.removeIntensiveRule(ruleId);
              Navigator.of(dialogContext).pop();
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
          onTap: () => _showColorPicker(l10n, colorProvider.holidayColor, (color) => colorProvider.setHolidayColor(color)),
        ),
        ListTile(
          title: Text(l10n.vacation),
          trailing: CircleAvatar(backgroundColor: colorProvider.vacationColor),
          onTap: () => _showColorPicker(l10n, colorProvider.vacationColor, (color) => colorProvider.setVacationColor(color)),
        ),
        ListTile(
          title: Text(l10n.intensiveWorkday),
          trailing: CircleAvatar(backgroundColor: colorProvider.intensiveWorkdayColor),
          onTap: () => _showColorPicker(l10n, colorProvider.intensiveWorkdayColor, (color) => colorProvider.setIntensiveWorkdayColor(color)),
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
          decoration: InputDecoration(labelText: l10n.standardWorkday),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSubmitted: (value) {
            try {
              settingsProvider.setStandardWorkdayHours(double.parse(value));
            } catch (e) { /* ignore */ }
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _intensiveWorkdayController,
          decoration: InputDecoration(labelText: l10n.intensiveWorkday),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSubmitted: (value) {
            try {
              settingsProvider.setIntensiveWorkdayHours(double.parse(value));
            } catch (e) { /* ignore */ }
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _annualHoursController,
          decoration: InputDecoration(labelText: l10n.annualHours),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onSubmitted: (value) {
            try {
              settingsProvider.setAnnualHoursGoal(double.parse(value));
            } catch (e) { /* ignore */ }
          },
        ),
      ],
    );
  }

  void _showColorPicker(AppLocalizations l10n, Color initialColor, void Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.selectColor),
        content: SingleChildScrollView(child: ColorPicker(pickerColor: initialColor, onColorChanged: onColorChanged)),
        actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(l10n.confirm))],
      ),
    );
  }

  Future<DateTime?> _selectDate(DateTime initialDate) async {
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
