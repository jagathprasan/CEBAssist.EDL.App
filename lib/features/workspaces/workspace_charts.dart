import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/extensions/context_extensions.dart';
import 'workspace_mode.dart';

class WorkspaceChartPoint {
  const WorkspaceChartPoint({required this.label, required this.value});

  final String label;
  final double value;
}

class WorkspaceLineChart extends StatelessWidget {
  const WorkspaceLineChart({super.key, required this.points});

  final List<WorkspaceChartPoint> points;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    final maxY = points
        .map((p) => p.value)
        .fold<double>(0, (a, b) => a > b ? a : b);

    return SizedBox(
      height: metrics.isField ? 240 : 200,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (points.length - 1).toDouble(),
          minY: 0,
          maxY: maxY + (maxY * 0.15),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: context.colors.outlineVariant, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: metrics.isField ? 42 : 34,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: metrics.labelSize - 1,
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: metrics.isField ? 30 : 24,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= points.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    points[index].label,
                    style: TextStyle(
                      fontSize: metrics.labelSize - 1,
                      color: context.colors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < points.length; i++)
                  FlSpot(i.toDouble(), points[i].value),
              ],
              isCurved: true,
              color: context.colors.primary,
              barWidth: metrics.isField ? 4 : 3,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: context.colors.primary.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkspaceBarChart extends StatelessWidget {
  const WorkspaceBarChart({super.key, required this.points});

  final List<WorkspaceChartPoint> points;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    final maxY = points
        .map((p) => p.value)
        .fold<double>(0, (a, b) => a > b ? a : b);

    return SizedBox(
      height: metrics.isField ? 240 : 200,
      child: BarChart(
        BarChartData(
          maxY: maxY + (maxY * 0.2),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: context.colors.outlineVariant, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: metrics.isField ? 42 : 34,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: metrics.labelSize - 1,
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: metrics.isField ? 30 : 24,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= points.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    points[index].label,
                    style: TextStyle(
                      fontSize: metrics.labelSize - 1,
                      fontWeight: FontWeight.w600,
                      color: context.colors.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < points.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: points[i].value,
                    width: metrics.isField ? 22 : 16,
                    borderRadius: BorderRadius.circular(8),
                    color: context.colors.primary,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class WorkspaceDonutChart extends StatelessWidget {
  const WorkspaceDonutChart({
    super.key,
    required this.segments,
    this.centerLabel,
  });

  final List<WorkspaceChartPoint> segments;
  final String? centerLabel;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    final total = segments.fold<double>(0, (sum, item) => sum + item.value);
    final palette = [
      context.colors.primary,
      context.colors.secondary,
      context.colors.tertiary,
      context.semantic.warning,
      context.semantic.success,
    ];

    return SizedBox(
      height: metrics.isField ? 220 : 180,
      child: Row(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: metrics.isField ? 46 : 38,
                    sections: [
                      for (var i = 0; i < segments.length; i++)
                        PieChartSectionData(
                          value: segments[i].value,
                          color: palette[i % palette.length],
                          radius: metrics.isField ? 34 : 28,
                          title: '',
                        ),
                    ],
                  ),
                ),
                if (centerLabel != null)
                  Text(
                    centerLabel!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: metrics.labelSize,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < segments.length; i++) ...[
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: palette[i % palette.length],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${segments[i].label} · ${((segments[i].value / total) * 100).round()}%',
                          style: TextStyle(
                            fontSize: metrics.labelSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: metrics.gap / 2),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
