import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:myapp/models/day_entry.dart';
import 'package:myapp/providers/calendar_provider.dart';
import 'package:myapp/providers/color_provider.dart';
import 'package:myapp/providers/settings_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with AutomaticKeepAliveClientMixin {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    _focusedDay = DateTime(settingsProvider.selectedYear, DateTime.now().month, 1);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;
    final calendarProvider = Provider.of<CalendarProvider>(context);
    final colorProvider = Provider.of<ColorProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    if (_focusedDay.year != settingsProvider.selectedYear) {
      _focusedDay = DateTime(settingsProvider.selectedYear, _focusedDay.month, 1);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${l10n.year}: "),
              DropdownButton<int>(
                value: settingsProvider.selectedYear,
                items: List.generate(10, (index) => DateTime.now().year - 5 + index)
                    .map((year) => DropdownMenuItem(value: year, child: Text(year.toString())))
                    .toList(),
                onChanged: (int? newYear) {
                  if (newYear != null) {
                    settingsProvider.setSelectedYear(newYear);
                    setState(() {
                      _focusedDay = DateTime(newYear, _focusedDay.month, 1);
                      _selectedDay = null;
                      _rangeStart = null;
                      _rangeEnd = null;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(settingsProvider.selectedYear, 1, 1),
                  lastDay: DateTime.utc(settingsProvider.selectedYear, 12, 31),
                  focusedDay: _focusedDay,
                  locale: 'es_ES',
                  calendarFormat: _calendarFormat,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  enabledDayPredicate: (day) {
                    return day.weekday != DateTime.saturday && day.weekday != DateTime.sunday;
                  },
                  calendarStyle: const CalendarStyle(
                    weekendTextStyle: TextStyle(color: Colors.grey),
                  ),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  onDaySelected: (selectedDay, focusedDay) {
                    if (selectedDay.weekday == DateTime.saturday || selectedDay.weekday == DateTime.sunday) return;

                    if (_rangeStart != null && _rangeEnd == null) {
                      setState(() {
                        if (selectedDay.isAfter(_rangeStart!)) {
                          _rangeEnd = selectedDay;
                        } else {
                          _rangeStart = selectedDay;
                        }
                        _focusedDay = focusedDay;
                      });
                    } else {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _rangeStart = null;
                        _rangeEnd = null;
                      });
                    }
                  },
                  onDayLongPressed: (day, focusedDay) {
                    if (day.weekday == DateTime.saturday || day.weekday == DateTime.sunday) return;
                    setState(() {
                      _rangeStart = day;
                      _rangeEnd = null;
                      _selectedDay = null;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      final dayType = calendarProvider.getDayType(date);
                      if (dayType != DayType.normal) {
                        return Positioned(
                          right: 1,
                          bottom: 1,
                          child: _buildMarker(dayType, colorProvider),
                        );
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              l10n.markHoliday,
                              colorProvider.holidayColor,
                              () {
                                if (_rangeStart != null && _rangeEnd != null) {
                                  calendarProvider.markDaysInRange(_rangeStart!, _rangeEnd!, DayType.holiday);
                                } else if (_selectedDay != null) {
                                  calendarProvider.markDay(_selectedDay!, DayType.holiday);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildActionButton(
                              l10n.markVacation,
                              colorProvider.vacationColor,
                              () {
                                if (_rangeStart != null && _rangeEnd != null) {
                                  calendarProvider.markDaysInRange(_rangeStart!, _rangeEnd!, DayType.vacation);
                                } else if (_selectedDay != null) {
                                  calendarProvider.markDay(_selectedDay!, DayType.vacation);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _selectedDay == null && _rangeStart == null
                                  ? null
                                  : () {
                                      if (_rangeStart != null && _rangeEnd != null) {
                                        calendarProvider.clearDaysInRange(_rangeStart!, _rangeEnd!);
                                      } else if (_selectedDay != null) {
                                        calendarProvider.clearDay(_selectedDay!);
                                      }
                                      setState(() {
                                        _selectedDay = null;
                                        _rangeStart = null;
                                        _rangeEnd = null;
                                      });
                                    },
                              child: Text(l10n.clearSelection),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        _buildLegend(l10n, colorProvider),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: (_selectedDay == null && (_rangeStart == null || _rangeEnd == null)) ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  Widget _buildMarker(DayType dayType, ColorProvider colorProvider) {
    Color color;
    switch (dayType) {
      case DayType.holiday:
        color = colorProvider.holidayColor;
        break;
      case DayType.vacation:
        color = colorProvider.vacationColor;
        break;
      case DayType.intensive:
        color = colorProvider.intensiveWorkdayColor;
        break;
      default:
        color = Colors.transparent;
    }
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildLegend(AppLocalizations l10n, ColorProvider colorProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(colorProvider.holidayColor, l10n.holiday),
        _buildLegendItem(colorProvider.vacationColor, l10n.vacation),
        _buildLegendItem(colorProvider.intensiveWorkdayColor, l10n.intensiveWorkday),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
