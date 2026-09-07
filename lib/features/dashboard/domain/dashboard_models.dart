enum SummaryMetricType { consumers, meters, complaints, outages }

enum QuickActionType {
  searchConsumer,
  viewMeter,
  reportOutage,
  checkBill,
  createRequest,
  viewReports,
}

enum ActivityType { meter, outage, billing, inventory }

enum ActivityStatus { completed, assigned, generated, approved }

enum AttentionSeverity { warning, info }

enum ProjectMetricType { active, attention, overdue, budget }

enum ProjectAttentionStatus { delayed, overdue, blocked }

class DashboardSummaryItem {
  const DashboardSummaryItem({
    required this.type,
    required this.label,
    required this.value,
    required this.trendLabel,
    required this.isPositive,
  });

  final SummaryMetricType type;
  final String label;
  final String value;
  final String trendLabel;
  final bool isPositive;
}

class EnergyConsumptionPoint {
  const EnergyConsumptionPoint({
    required this.monthLabel,
    required this.gigawattHours,
  });

  final String monthLabel;
  final double gigawattHours;
}

class CollectionProgress {
  const CollectionProgress({
    required this.monthlyTargetBillions,
    required this.collectedBillions,
  });

  final double monthlyTargetBillions;
  final double collectedBillions;

  double get completionRatio {
    if (monthlyTargetBillions == 0) return 0;
    return collectedBillions / monthlyTargetBillions;
  }

  double get completionPercent => completionRatio * 100;
}

class OutageBreakdown {
  const OutageBreakdown({
    required this.planned,
    required this.unplanned,
    required this.resolvedToday,
  });

  final int planned;
  final int unplanned;
  final int resolvedToday;

  int get totalActive => planned + unplanned;
}

class QuickActionItem {
  const QuickActionItem({required this.type, required this.label});

  final QuickActionType type;
  final String label;
}

class RecentActivity {
  const RecentActivity({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.type,
    required this.status,
  });

  final String id;
  final String title;
  final DateTime timestamp;
  final ActivityType type;
  final ActivityStatus status;
}

class AttentionItem {
  const AttentionItem({
    required this.id,
    required this.message,
    required this.severity,
  });

  final String id;
  final String message;
  final AttentionSeverity severity;
}

class ProjectPortfolioMetric {
  const ProjectPortfolioMetric({
    required this.type,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  final ProjectMetricType type;
  final String label;
  final String value;
  final String subtitle;
}

class ProjectAttentionItem {
  const ProjectAttentionItem({
    required this.id,
    required this.name,
    required this.projectCode,
    required this.progressPercent,
    required this.status,
  });

  final String id;
  final String name;
  final String projectCode;
  final int progressPercent;
  final ProjectAttentionStatus status;

  String get progressLabel => '$progressPercent% physical progress';
}

class ProjectPortfolio {
  const ProjectPortfolio({
    required this.metrics,
    required this.attentionProjects,
  });

  final List<ProjectPortfolioMetric> metrics;
  final List<ProjectAttentionItem> attentionProjects;
}

class DashboardSnapshot {
  const DashboardSnapshot({
    required this.summaries,
    required this.energy,
    required this.collection,
    required this.outages,
    required this.quickActions,
    required this.activities,
    required this.attentionItems,
    required this.projectPortfolio,
  });

  final List<DashboardSummaryItem> summaries;
  final List<EnergyConsumptionPoint> energy;
  final CollectionProgress collection;
  final OutageBreakdown outages;
  final List<QuickActionItem> quickActions;
  final List<RecentActivity> activities;
  final List<AttentionItem> attentionItems;
  final ProjectPortfolio projectPortfolio;
}

/// Contract for dashboard data. Replace the mock implementation with REST later.
abstract class DashboardRepository {
  Future<DashboardSnapshot> fetchDashboard();
}
