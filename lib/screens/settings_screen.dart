import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/providers/theme_provider.dart';
import 'package:myapp/providers/color_provider.dart';
import 'package:myapp/providers/settings_provider.dart';
import 'package:intl/intl.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settingsProvider = Provider.of<SettingsProvider>(context);
    _standardWorkdayController.text = settingsProvider.standardWorkdayHours.toString();
    _intensiveWorkdayController.text = settingsProvider.intensiveWorkdayHours.toString();
    _annualHoursController.text = settingsProvider.annualHoursGoal.toString();
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

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.settings, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text(l10n.chooseThemeColor, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
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
            const SizedBox(height: 16),
            Text(l10n.standardWorkday, style: Theme.of(context).textTheme.titleLarge),
            TextField(
              controller: _standardWorkdayController,
              keyboardType: TextInputType.number,
              onSubmitted: (value) => settingsProvider.setStandardWorkdayHours(double.parse(value)),
            ),
            const SizedBox(height: 16),
            Text(l10n.intensiveWorkdayHours, style: Theme.of(context).textTheme.titleLarge),
            TextField(
              controller: _intensiveWorkdayController,
              keyboardType: TextInputType.number,
              onSubmitted: (value) => settingsProvider.setIntensiveWorkdayHours(double.parse(value)),
            ),
            const SizedBox(height: 16),
            Text(l10n.annualHoursGoal, style: Theme.of(context).textTheme.titleLarge),
            TextField(
              controller: _annualHoursController,
              keyboardType: TextInputType.number,
              onSubmitted: (value) => settingsProvider.setAnnualHoursGoal(double.parse(value)),
            ),
            const SizedBox(height: 16),
            Text(l10n.intensiveWorkdayPeriod, style: Theme.of(context).textTheme.titleLarge),
            ListTile(
              title: Text(l10n.startDate),
              subtitle: Text(DateFormat.yMMMd().format(settingsProvider.intensiveWorkdayStartDate)),
              onTap: () => _selectDate(context, settingsProvider.intensiveWorkdayStartDate, (date) => settingsProvider.setIntensiveWorkdayStartDate(date)),
            ),
            ListTile(
              title: Text(l10n.endDate),
              subtitle: Text(DateFormat.yMMMd().format(settingsProvider.intensiveWorkdayEndDate)),
              onTap: () => _selectDate(context, settingsProvider.intensiveWorkdayEndDate, (date) => settingsProvider.setIntensiveWorkdayEndDate(date)),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context, AppLocalizations l10n, Color initialColor, void Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.pickAColor),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: initialColor,
              onColorChanged: onColorChanged,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.done),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate, void Function(DateTime) onDateSelected) async {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final selectedYear = settingsProvider.selectedYear;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(selectedYear, 1, 1),
      lastDate: DateTime(selectedYear, 12, 31),
    );
    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }
}
