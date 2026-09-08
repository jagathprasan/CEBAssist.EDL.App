import 'package:flutter/material.dart';

import '../../core/widgets/app_status_chip.dart';
import '../../shared/widgets/widgets.dart';

class WorkspaceCalendarEvent {
  const WorkspaceCalendarEvent({
    required this.date,
    required this.title,
    required this.timeLabel,
    this.subtitle,
    this.location,
    this.tone = AppStatusTone.info,
  });

  final DateTime date;
  final String title;
  final String timeLabel;
  final String? subtitle;
  final String? location;
  final AppStatusTone tone;

  AppCalendarEvent toAppEvent() {
    return AppCalendarEvent(
      date: date,
      title: title,
      timeLabel: timeLabel,
      subtitle: subtitle,
      location: location,
      tone: tone,
    );
  }
}

/// Workspace wrapper around the shared Metronic calendar.
class WorkspaceCalendar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AppCalendar(
      events: events.map((event) => event.toAppEvent()).toList(),
      initialMonth: initialMonth,
      onDaySelected: onDaySelected,
    );
  }
}
