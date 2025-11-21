import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/calendar_provider.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<CalendarProvider>(context);

    // TODO: Implementar la lógica de cálculo en el provider
    final summary = calendarProvider.calculateSummary();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen Anual'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildSummaryCard(
            context: context,
            title: 'Jornada Laboral',
            items: {
              'Días laborables totales': summary['workDays'].toString(),
              'Horas objetivo anuales': summary['targetHours'].toString(),
            },
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            context: context,
            title: 'Ausencias',
            items: {
              'Días de vacaciones': summary['vacationDays'].toString(),
              'Días festivos': summary['holidayDays'].toString(),
            },
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            context: context,
            title: 'Cómputo de Horas',
            items: {
              'Horas trabajadas (estimado)': summary['workedHours'].toStringAsFixed(2),
              'Horas restantes': summary['remainingHours'].toStringAsFixed(2),
            },
            progress: summary['progress'] as double,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required Map<String, String> items,
    double? progress,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: textTheme.titleLarge?.copyWith(color: colorScheme.primary)),
            const Divider(height: 20, thickness: 1),
            ...items.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key, style: textTheme.bodyMedium),
                  Text(entry.value, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            )),
            if (progress != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Progreso', style: textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
