import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../l10n/app_localizations.dart';
import '../models/day_entry.dart';
import '../providers/calendar_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final calendarProvider = Provider.of<CalendarProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calendar),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                calendarProvider.setFocusedDay(DateTime.now());
                _selectedDay = DateTime.now();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: calendarProvider.focusedDay,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  calendarProvider.setFocusedDay(focusedDay);
                  _rangeStart = null;
                  _rangeEnd = null;
                  _rangeSelectionMode = RangeSelectionMode.toggledOff;
                });
              }
            },
            onRangeSelected: (start, end, focusedDay) {
              setState(() {
                _selectedDay = null;
                calendarProvider.setFocusedDay(focusedDay);
                _rangeStart = start;
                _rangeEnd = end;
                _rangeSelectionMode = RangeSelectionMode.toggledOn;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              calendarProvider.setFocusedDay(focusedDay);
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final dayType = calendarProvider.getDayType(date);
                if (dayType != DayType.none) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildMarker(dayType),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: _buildButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildMarker(DayType dayType) {
    Color color;
    IconData icon;
    switch (dayType) {
      case DayType.work:
        color = Colors.blue;
        icon = Icons.work;
        break;
      case DayType.holiday:
        color = Colors.red;
        icon = Icons.beach_access;
        break;
      case DayType.vacation:
        color = Colors.green;
        icon = Icons.airplanemode_active;
        break;
      default:
        return const SizedBox.shrink();
    }
    return Icon(icon, color: color, size: 16);
  }

  Widget _buildButtons() {
    final l10n = AppLocalizations.of(context)!;
    final calendarProvider = Provider.of<CalendarProvider>(context, listen: false);

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 3,
      children: [
        _buildButton(l10n.markAsHoliday, () {
          setState(() {
            if (_rangeStart != null && _rangeEnd != null) {
              calendarProvider.markDaysInRange(_rangeStart!, _rangeEnd!, DayType.holiday);
            } else if (_selectedDay != null) {
              calendarProvider.markDay(_selectedDay!, DayType.holiday);
            }
            _clearSelection();
          });
        }),
        _buildButton(l10n.markAsVacation, () {
          setState(() {
            if (_rangeStart != null && _rangeEnd != null) {
              calendarProvider.markDaysInRange(_rangeStart!, _rangeEnd!, DayType.vacation);
            } else if (_selectedDay != null) {
              calendarProvider.markDay(_selectedDay!, DayType.vacation);
            }
            _clearSelection();
          });
        }),
        _buildButton(l10n.clearSelection, () {
          setState(() {
            if (_selectedDay != null) {
              calendarProvider.clearDay(_selectedDay!);
            }
            _clearSelection();
          });
        }),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }

  void _clearSelection() {
    _selectedDay = null;
    _rangeStart = null;
    _rangeEnd = null;
    _rangeSelectionMode = RangeSelectionMode.toggledOff;
  }
}
