import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import 'workspace_mode.dart';

class WorkspaceCalendarEvent {
  const WorkspaceCalendarEvent({
    required this.date,
    required this.title,
    required this.timeLabel,
  });

  final DateTime date;
  final String title;
  final String timeLabel;
}

class WorkspaceCalendar extends StatefulWidget {
  const WorkspaceCalendar({
    super.key,
    required this.events,
    this.initialMonth,
    this.onDaySelected,
  });

  final List<WorkspaceCalendarEvent> events;
  final DateTime? initialMonth;
  final ValueChanged<DateTime>? onDaySelected;

  @override
  State<WorkspaceCalendar> createState() => _WorkspaceCalendarState();
}

class _WorkspaceCalendarState extends State<WorkspaceCalendar> {
  late DateTime _visibleMonth;
  DateTime? _selected;

  @override
  void initState() {
    super.initState();
    final now = widget.initialMonth ?? DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
    _selected = DateTime(now.year, now.month, now.day);
  }

  List<WorkspaceCalendarEvent> get _dayEvents {
    final selected = _selected;
    if (selected == null) return const [];
    return widget.events
        .where(
          (event) =>
              event.date.year == selected.year &&
              event.date.month == selected.month &&
              event.date.day == selected.day,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    final firstDay = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final daysInMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + 1,
      0,
    ).day;
    final startWeekday = firstDay.weekday % 7;
    final totalCells = startWeekday + daysInMonth;
    final weeks = (totalCells / 7).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Previous month',
              onPressed: () {
                setState(() {
                  _visibleMonth = DateTime(
                    _visibleMonth.year,
                    _visibleMonth.month - 1,
                  );
                });
              },
              icon: Icon(Icons.chevron_left, size: metrics.iconSize),
            ),
            Expanded(
              child: Text(
                DateFormat('MMMM yyyy').format(_visibleMonth),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: metrics.bodySize,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Next month',
              onPressed: () {
                setState(() {
                  _visibleMonth = DateTime(
                    _visibleMonth.year,
                    _visibleMonth.month + 1,
                  );
                });
              },
              icon: Icon(Icons.chevron_right, size: metrics.iconSize),
            ),
          ],
        ),
        SizedBox(height: metrics.gap / 2),
        Row(
          children: [
            for (final day in const ['S', 'M', 'T', 'W', 'T', 'F', 'S'])
              Expanded(
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: metrics.labelSize,
                    fontWeight: FontWeight.w700,
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: metrics.gap / 2),
        for (var week = 0; week < weeks; week++)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                for (var weekday = 0; weekday < 7; weekday++)
                  Expanded(
                    child: _dayCell(week, weekday, startWeekday, daysInMonth),
                  ),
              ],
            ),
          ),
        SizedBox(height: metrics.gap),
        Text(
          _selected == null
              ? 'Select a day'
              : DateFormat('EEE, d MMM').format(_selected!),
          style: TextStyle(
            fontSize: metrics.bodySize,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: metrics.gap / 2),
        if (_dayEvents.isEmpty)
          Text(
            'No scheduled items for this day.',
            style: TextStyle(
              fontSize: metrics.labelSize,
              color: context.colors.onSurfaceVariant,
            ),
          )
        else
          for (final event in _dayEvents)
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: metrics.gap / 2),
              padding: EdgeInsets.all(metrics.isField ? 14 : 10),
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.08),
                borderRadius: AppRadius.borderSm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: metrics.bodySize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    event.timeLabel,
                    style: TextStyle(
                      fontSize: metrics.labelSize,
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }

  Widget _dayCell(int week, int weekday, int startWeekday, int daysInMonth) {
    final metrics = WorkspaceScope.metricsOf(context);
    final dayNumber = week * 7 + weekday - startWeekday + 1;
    if (dayNumber < 1 || dayNumber > daysInMonth) {
      return SizedBox(height: metrics.isField ? 44 : 36);
    }

    final date = DateTime(_visibleMonth.year, _visibleMonth.month, dayNumber);
    final selected =
        _selected != null &&
        _selected!.year == date.year &&
        _selected!.month == date.month &&
        _selected!.day == date.day;
    final hasEvent = widget.events.any(
      (event) =>
          event.date.year == date.year &&
          event.date.month == date.month &&
          event.date.day == date.day,
    );

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () {
        setState(() => _selected = date);
        widget.onDaySelected?.call(date);
      },
      child: SizedBox(
        height: metrics.isField ? 44 : 36,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: metrics.isField ? 34 : 28,
              height: metrics.isField ? 34 : 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? context.colors.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$dayNumber',
                style: TextStyle(
                  fontSize: metrics.labelSize,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? context.colors.onPrimary
                      : context.colors.onSurface,
                ),
              ),
            ),
            if (hasEvent)
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: selected
                      ? context.colors.onPrimary
                      : context.colors.secondary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
