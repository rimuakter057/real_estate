import '../models/report_model.dart';
import 'mock_properties.dart';

class MockReports {
  MockReports._();

  static final List<ReportModel> all = [
    ReportModel(
      id: 'rep1',
      property: MockProperties.byId('p6'),
      reason: 'Misleading price',
      reporterName: 'Marcus Lee',
      reporterAvatar: 'https://randomuser.me/api/portraits/men/12.jpg',
      date: DateTime(2026, 9, 3),
      status: ReportStatus.pending,
      details: 'The listed price does not match what the agent quoted over the phone.',
    ),
    ReportModel(
      id: 'rep2',
      property: MockProperties.byId('p11'),
      reason: 'Duplicate listing',
      reporterName: 'Priya Nair',
      reporterAvatar: 'https://randomuser.me/api/portraits/women/33.jpg',
      date: DateTime(2026, 9, 1),
      status: ReportStatus.pending,
      details: 'This shop appears to be listed twice under different agents.',
    ),
    ReportModel(
      id: 'rep3',
      property: MockProperties.byId('p10'),
      reason: 'Incorrect location',
      reporterName: 'Tom Richards',
      reporterAvatar: 'https://randomuser.me/api/portraits/men/61.jpg',
      date: DateTime(2026, 8, 26),
      status: ReportStatus.resolved,
      details: 'Map pin points to a different neighborhood than described.',
    ),
    ReportModel(
      id: 'rep4',
      property: MockProperties.byId('p5'),
      reason: 'Spam / Fake listing',
      reporterName: 'Olivia Bennett',
      reporterAvatar: 'https://randomuser.me/api/portraits/women/22.jpg',
      date: DateTime(2026, 8, 20),
      status: ReportStatus.dismissed,
      details: 'Reported in error — listing verified as legitimate.',
    ),
  ];
}
