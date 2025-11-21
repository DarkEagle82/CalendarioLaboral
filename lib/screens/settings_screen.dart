import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SwitchListTile(
              title: Text(l10n.darkMode),
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (bool value) {
                themeProvider.toggleTheme(value);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showColorPicker(context, themeProvider, l10n);
              },
              child: Text(l10n.chooseThemeColor),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context, ThemeProvider themeProvider, AppLocalizations l10n) {
    Color pickerColor = themeProvider.primaryColor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.pickAColor),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) {
                pickerColor = color;
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.done),
              onPressed: () {
                themeProvider.setPrimaryColor(pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
