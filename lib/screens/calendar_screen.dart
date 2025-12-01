import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../l10n/app_localizations.dart';
import '../models/day_entry.dart';
import '../models/work_day.dart';
import '../providers/calendar_provider.dart';
import '../providers/color_provider.dart';

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
            locale: Localizations.localeOf(context).toString(),
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: calendarProvider.focusedDay,
            calendarFormat: _calendarFormat,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
            ),
            rangeSelectionMode: _rangeSelectionMode,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            enabledDayPredicate: (day) {
              return day.weekday != DateTime.saturday && day.weekday != DateTime.sunday;
            },
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
            calendarStyle: CalendarStyle(
              weekendTextStyle: TextStyle(color: Colors.grey[500]),
            ),
            calendarBuilders: CalendarBuilders(
              disabledBuilder: (context, day, focusedDay) {
                if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.rectangle,
                    ),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  );
                }
                return null;
              },
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
    final colorProvider = Provider.of<ColorProvider>(context, listen: false);
    Color color;
    switch (dayType) {
      case DayType.work:
        color = Colors.blue;
        break;
      case DayType.holiday:
        color = colorProvider.holidayColor;
        break;
      case DayType.vacation:
        color = colorProvider.vacationColor;
        break;
      default:
        return const SizedBox.shrink();
    }
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
      ),
    );
  }

  Widget _buildButtons() {
    final l10n = AppLocalizations.of(context)!;
    final calendarProvider = Provider.of<CalendarProvider>(context, listen: false);
    final colorProvider = Provider.of<ColorProvider>(context, listen: false);

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
        }, color: colorProvider.holidayColor),
        _buildButton(l10n.markAsVacation, () {
          setState(() {
            if (_rangeStart != null && _rangeEnd != null) {
              calendarProvider.markDaysInRange(_rangeStart!, _rangeEnd!, DayType.vacation);
            } else if (_selectedDay != null) {
              calendarProvider.markDay(_selectedDay!, DayType.vacation);
            }
            _clearSelection();
          });
        }, color: colorProvider.vacationColor),
        _buildButton(l10n.clearSelection, () {
          setState(() {
            if (_rangeStart != null && _rangeEnd != null) {
              calendarProvider.clearDaysInRange(_rangeStart!, _rangeEnd!);
            } else if (_selectedDay != null) {
              calendarProvider.clearDay(_selectedDay!);
            }
            _clearSelection();
          });
        }),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: color != null ? Colors.white : null,
        ),
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
