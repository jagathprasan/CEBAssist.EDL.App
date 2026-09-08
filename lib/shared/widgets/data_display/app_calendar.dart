import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../layout/app_layout_utils.dart';

/// Calendar event shown as a Metronic-style agenda post.
class AppCalendarEvent {
  const AppCalendarEvent({
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
}

/// Professional month calendar with visible event posts (Metronic DayPicker look).
class AppCalendar extends StatefulWidget {
  const AppCalendar({
    super.key,
    required this.events,
    this.initialMonth,
    this.onDaySelected,
    this.compact = false,
  });

  final List<AppCalendarEvent> events;
  final DateTime? initialMonth;
  final ValueChanged<DateTime>? onDaySelected;
  final bool compact;

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  late DateTime _visibleMonth;
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    final now = widget.initialMonth ?? DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
    _selected = DateTime(now.year, now.month, now.day);
  }

  List<AppCalendarEvent> _eventsOn(DateTime date) {
    return widget.events
        .where(
          (event) =>
              event.date.year == date.year &&
              event.date.month == date.month &&
              event.date.day == date.day,
        )
        .toList();
  }

  Color _toneColor(BuildContext context, AppStatusTone tone) {
    final semantic = context.semantic;
    return switch (tone) {
      AppStatusTone.success => semantic.success,
      AppStatusTone.warning => semantic.warning,
      AppStatusTone.error => context.colors.error,
      AppStatusTone.info => context.colors.primary,
      AppStatusTone.neutral => context.colors.onSurfaceVariant,
    };
  }

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month, 1);
    final startWeekday = firstOfMonth.weekday % 7;
    final daysInMonth = DateTime(
      _visibleMonth.year,
      _visibleMonth.month + 1,
      0,
    ).day;
    final cellCount = startWeekday + daysInMonth;
    final weeks = (cellCount / 7).ceil();
    final dayEvents = _eventsOn(_selected);
    final cellSize = widget.compact ? 40.0 : 48.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _NavButton(
              icon: Icons.chevron_left,
              tooltip: 'Previous month',
              onPressed: () {
                setState(() {
                  _visibleMonth = DateTime(
                    _visibleMonth.year,
                    _visibleMonth.month - 1,
                  );
                });
              },
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    DateFormat('MMMM yyyy').format(_visibleMonth),
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${widget.events.where((e) => e.date.month == _visibleMonth.month && e.date.year == _visibleMonth.year).length} scheduled',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                final now = DateTime.now();
                setState(() {
                  _visibleMonth = DateTime(now.year, now.month);
                  _selected = DateTime(now.year, now.month, now.day);
                });
                widget.onDaySelected?.call(_selected);
              },
              child: const Text('Today'),
            ),
            _NavButton(
              icon: Icons.chevron_right,
              tooltip: 'Next month',
              onPressed: () {
                setState(() {
                  _visibleMonth = DateTime(
                    _visibleMonth.year,
                    _visibleMonth.month + 1,
                  );
                });
              },
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            for (final day in const ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'])
              Expanded(
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.onSurfaceVariant.withValues(
                      alpha: 0.8,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        for (var week = 0; week < weeks; week++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                for (var weekday = 0; weekday < 7; weekday++)
                  Expanded(
                    child: _DayCell(
                      size: cellSize,
                      date: _cellDate(
                        week,
                        weekday,
                        startWeekday,
                        firstOfMonth,
                      ),
                      visibleMonth: _visibleMonth,
                      selected: _selected,
                      events: widget.events,
                      toneColor: (tone) => _toneColor(context, tone),
                      onTap: (date) {
                        setState(() {
                          _selected = date;
                          _visibleMonth = DateTime(date.year, date.month);
                        });
                        widget.onDaySelected?.call(date);
                      },
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: Text(
                DateFormat('EEEE, d MMM').format(_selected),
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            AppStatusChip(
              label:
                  '${dayEvents.length} post${dayEvents.length == 1 ? '' : 's'}',
              tone: dayEvents.isEmpty
                  ? AppStatusTone.neutral
                  : AppStatusTone.info,
              compact: true,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (dayEvents.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLow,
              borderRadius: AppRadius.borderSm,
              border: Border.all(color: context.colors.outlineVariant),
            ),
            child: Text(
              'No posts scheduled for this day.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          )
        else
          for (final event in dayEvents) ...[
            AppFeedPost(
              title: event.title,
              timeLabel: event.timeLabel,
              subtitle: event.subtitle,
              location: event.location,
              tone: event.tone,
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
      ],
    );
  }

  DateTime _cellDate(
    int week,
    int weekday,
    int startWeekday,
    DateTime firstOfMonth,
  ) {
    final dayNumber = week * 7 + weekday - startWeekday + 1;
    return DateTime(firstOfMonth.year, firstOfMonth.month, dayNumber);
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        foregroundColor: context.colors.onSurfaceVariant,
        minimumSize: const Size(40, 40),
      ),
      icon: Icon(icon, size: 20),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.size,
    required this.date,
    required this.visibleMonth,
    required this.selected,
    required this.events,
    required this.toneColor,
    required this.onTap,
  });

  final double size;
  final DateTime date;
  final DateTime visibleMonth;
  final DateTime selected;
  final List<AppCalendarEvent> events;
  final Color Function(AppStatusTone tone) toneColor;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isOutside = date.month != visibleMonth.month;
    final isSelected =
        date.year == selected.year &&
        date.month == selected.month &&
        date.day == selected.day;
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final dayEvents = events
        .where(
          (event) =>
              event.date.year == date.year &&
              event.date.month == date.month &&
              event.date.day == date.day,
        )
        .toList();

    return InkWell(
      borderRadius: AppRadius.borderXs,
      onTap: () => onTap(date),
      child: SizedBox(
        height: size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? context.colors.primary : Colors.transparent,
                borderRadius: AppRadius.borderXs,
                border: isToday && !isSelected
                    ? Border.all(color: context.colors.primary, width: 1.4)
                    : null,
              ),
              child: Text(
                '${date.day}',
                style: context.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? context.colors.onPrimary
                      : isOutside
                      ? context.colors.onSurface.withValues(alpha: 0.28)
                      : context.colors.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final event in dayEvents.take(3))
                  Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.colors.primary
                          : toneColor(event.tone),
                      shape: BoxShape.circle,
                    ),
                  ),
                if (dayEvents.isEmpty) const SizedBox(width: 5, height: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Activity / calendar post row used in feeds and agenda lists.
class AppFeedPost extends StatelessWidget {
  const AppFeedPost({
    super.key,
    required this.title,
    required this.timeLabel,
    this.subtitle,
    this.location,
    this.author,
    this.tone = AppStatusTone.info,
    this.onTap,
  });

  final String title;
  final String timeLabel;
  final String? subtitle;
  final String? location;
  final String? author;
  final AppStatusTone tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      AppStatusTone.success => context.semantic.success,
      AppStatusTone.warning => context.semantic.warning,
      AppStatusTone.error => context.colors.error,
      AppStatusTone.info => context.colors.primary,
      AppStatusTone.neutral => context.colors.onSurfaceVariant,
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderSm,
        child: Ink(
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerLow,
            borderRadius: AppRadius.borderSm,
            border: Border.all(color: context.colors.outlineVariant),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(AppRadius.sm),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.sm,
                      AppSpacing.sm,
                      AppSpacing.sm,
                      AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(
                                  alpha: context.isDark ? 0.22 : 0.12,
                                ),
                                borderRadius: AppRadius.borderXs,
                              ),
                              child: Text(
                                timeLabel,
                                style: context.textTheme.labelSmall?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (author != null) ...[
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: Text(
                                  author!,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.textTheme.labelSmall?.copyWith(
                                    color: context.colors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ] else
                              const Spacer(),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          title,
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                        if (location != null) ...[
                          const SizedBox(height: 4),
                          AppIconLabel(
                            icon: Icons.place_outlined,
                            label: location!,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
