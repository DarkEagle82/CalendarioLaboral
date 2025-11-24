import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/providers/calendar_provider.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final calendarProvider = Provider.of<CalendarProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.summary, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          _buildSummaryRow(l10n.totalHoursWorked, calendarProvider.totalHoursWorked.toStringAsFixed(2)),
          const SizedBox(height: 8),
          _buildSummaryRow(l10n.annualHours, calendarProvider.annualHours.toStringAsFixed(2)),
          const SizedBox(height: 8),
          _buildSummaryRow(l10n.remainingHours, calendarProvider.remainingHours.toStringAsFixed(2)),
          const SizedBox(height: 8),
          if (calendarProvider.equivalentDays > 0)
            _buildSummaryRow(l10n.equivalentDays, calendarProvider.equivalentDays.toStringAsFixed(2)),
          const SizedBox(height: 8),
          _buildSummaryRow(l10n.totalWorkingDays, calendarProvider.totalWorkingDays.toString()),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
