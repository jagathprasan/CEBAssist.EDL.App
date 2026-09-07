import '../domain/dashboard_models.dart';

class MockDashboardRepository implements DashboardRepository {
  const MockDashboardRepository({
    this.delay = const Duration(milliseconds: 350),
  });

  final Duration delay;

  @override
  Future<DashboardSnapshot> fetchDashboard() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    final now = DateTime.now();
    return DashboardSnapshot(
      summaries: const [
        DashboardSummaryItem(
          type: SummaryMetricType.consumers,
          label: 'Active Consumers',
          value: '1.28M',
          trendLabel: '+1.4% this month',
          isPositive: true,
        ),
        DashboardSummaryItem(
          type: SummaryMetricType.meters,
          label: 'Smart Meters Online',
          value: '84,562',
          trendLabel: '98.2% availability',
          isPositive: true,
        ),
        DashboardSummaryItem(
          type: SummaryMetricType.complaints,
          label: 'Open Complaints',
          value: '326',
          trendLabel: '41 pending SLA',
          isPositive: false,
        ),
        DashboardSummaryItem(
          type: SummaryMetricType.outages,
          label: 'Active Outages',
          value: '18',
          trendLabel: '11 unplanned',
          isPositive: false,
        ),
      ],
      energy: const [
        EnergyConsumptionPoint(monthLabel: 'Jan', gigawattHours: 118),
        EnergyConsumptionPoint(monthLabel: 'Feb', gigawattHours: 124),
        EnergyConsumptionPoint(monthLabel: 'Mar', gigawattHours: 121),
        EnergyConsumptionPoint(monthLabel: 'Apr', gigawattHours: 132),
        EnergyConsumptionPoint(monthLabel: 'May', gigawattHours: 138),
        EnergyConsumptionPoint(monthLabel: 'Jun', gigawattHours: 145),
      ],
      collection: const CollectionProgress(
        monthlyTargetBillions: 12.5,
        collectedBillions: 10.8,
      ),
      outages: const OutageBreakdown(
        planned: 7,
        unplanned: 11,
        resolvedToday: 23,
      ),
      quickActions: const [
        QuickActionItem(
          type: QuickActionType.searchConsumer,
          label: 'Search Consumer',
        ),
        QuickActionItem(type: QuickActionType.viewMeter, label: 'View Meter'),
        QuickActionItem(
          type: QuickActionType.reportOutage,
          label: 'Report Outage',
        ),
        QuickActionItem(type: QuickActionType.checkBill, label: 'Check Bill'),
        QuickActionItem(
          type: QuickActionType.createRequest,
          label: 'Create Request',
        ),
        QuickActionItem(
          type: QuickActionType.viewReports,
          label: 'View Reports',
        ),
      ],
      activities: [
        RecentActivity(
          id: 'act-1',
          title: 'Smart meter activated for account 1706072309',
          timestamp: now.subtract(const Duration(minutes: 18)),
          type: ActivityType.meter,
          status: ActivityStatus.completed,
        ),
        RecentActivity(
          id: 'act-2',
          title: 'Outage complaint assigned to Area Office Kandy',
          timestamp: now.subtract(const Duration(hours: 1, minutes: 12)),
          type: ActivityType.outage,
          status: ActivityStatus.assigned,
        ),
        RecentActivity(
          id: 'act-3',
          title: 'Monthly billing report generated',
          timestamp: now.subtract(const Duration(hours: 3, minutes: 40)),
          type: ActivityType.billing,
          status: ActivityStatus.generated,
        ),
        RecentActivity(
          id: 'act-4',
          title: 'Inventory request approved',
          timestamp: now.subtract(const Duration(hours: 6)),
          type: ActivityType.inventory,
          status: ActivityStatus.approved,
        ),
      ],
      attentionItems: const [
        AttentionItem(
          id: 'att-1',
          message: '18 active outages require field coordination',
          severity: AttentionSeverity.warning,
        ),
        AttentionItem(
          id: 'att-2',
          message: '27 meters offline for more than 24 hours',
          severity: AttentionSeverity.warning,
        ),
        AttentionItem(
          id: 'att-3',
          message: '12 pending inventory approvals',
          severity: AttentionSeverity.info,
        ),
      ],
      projectPortfolio: const ProjectPortfolio(
        metrics: [
          ProjectPortfolioMetric(
            type: ProjectMetricType.active,
            label: 'Active Projects',
            value: '58',
            subtitle: '59 total in portfolio',
          ),
          ProjectPortfolioMetric(
            type: ProjectMetricType.attention,
            label: 'Needs Attention',
            value: '39',
            subtitle: 'health, blocked stages, overdue',
          ),
          ProjectPortfolioMetric(
            type: ProjectMetricType.overdue,
            label: 'Overdue',
            value: '37',
            subtitle: 'past planned end date',
          ),
          ProjectPortfolioMetric(
            type: ProjectMetricType.budget,
            label: 'Budget Utilized',
            value: '21%',
            subtitle: 'LKR 31.7B of LKR 151.7B',
          ),
        ],
        attentionProjects: [
          ProjectAttentionItem(
            id: 'prj-1',
            name:
                'Moragolla Hydropower Project : Lot A2 - Main Civil Works Contract',
            projectCode: 'CEB-XX-2026-447804',
            progressPercent: 0,
            status: ProjectAttentionStatus.delayed,
          ),
          ProjectAttentionItem(
            id: 'prj-2',
            name: 'PSSREIP - Package 2',
            projectCode: 'CEB-XX-2026-097137',
            progressPercent: 42,
            status: ProjectAttentionStatus.overdue,
          ),
          ProjectAttentionItem(
            id: 'prj-3',
            name: 'Augmentation of Bolawatta Grid Substations',
            projectCode: 'CEB-XX-2026-380514',
            progressPercent: 61,
            status: ProjectAttentionStatus.overdue,
          ),
          ProjectAttentionItem(
            id: 'prj-4',
            name:
                'Construction of 132/33 kV, 31.5 MVA New Transformer (TR4) Bay at Kurunegala',
            projectCode: 'CEB-XX-2026-526147',
            progressPercent: 28,
            status: ProjectAttentionStatus.overdue,
          ),
          ProjectAttentionItem(
            id: 'prj-5',
            name: '33 kV Feeder Upgrade',
            projectCode: 'CEB-XX-2026-666445',
            progressPercent: 18,
            status: ProjectAttentionStatus.blocked,
          ),
          ProjectAttentionItem(
            id: 'prj-6',
            name:
                'PSSREIP - Package 4 Construction of 2km Single Circuit Line In & Line Out (LILO)',
            projectCode: 'CEB-XX-2026-693256',
            progressPercent: 35,
            status: ProjectAttentionStatus.overdue,
          ),
          ProjectAttentionItem(
            id: 'prj-7',
            name: 'Augmentation of Thulhiriya Grid Substations',
            projectCode: 'CEB-XX-2026-534507',
            progressPercent: 54,
            status: ProjectAttentionStatus.overdue,
          ),
          ProjectAttentionItem(
            id: 'prj-8',
            name: 'Augmentation of Nadukuda GS',
            projectCode: 'CEB-XX-2026-497365',
            progressPercent: 47,
            status: ProjectAttentionStatus.overdue,
          ),
        ],
      ),
    );
  }
}
