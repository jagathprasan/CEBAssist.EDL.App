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
    return const DashboardSnapshot(
      summaries: [
        DashboardSummaryItem(
          type: SummaryMetricType.consumers,
          label: 'Active Consumers',
          value: '—',
          trendLabel: 'Live data coming soon',
          isPositive: true,
        ),
        DashboardSummaryItem(
          type: SummaryMetricType.outages,
          label: 'Active Outages',
          value: '—',
          trendLabel: 'Live data coming soon',
          isPositive: true,
        ),
      ],
      energy: [],
      collection: CollectionProgress(
        monthlyTargetBillions: 0,
        collectedBillions: 0,
      ),
      outages: OutageBreakdown(planned: 0, unplanned: 0, resolvedToday: 0),
      quickActions: [],
      activities: [],
      attentionItems: [],
      projectPortfolio: ProjectPortfolio(metrics: [], attentionProjects: []),
    );
  }
}
