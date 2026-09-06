import '../models/visit_model.dart';
import 'mock_properties.dart';

class MockVisits {
  MockVisits._();

  /// Visits from the Buyer's perspective ("My Visits").
  static final List<VisitModel> myVisits = [
    VisitModel(
      id: 'v1',
      property: MockProperties.byId('p1'),
      date: DateTime(2026, 9, 10),
      timeSlot: '10:00 AM',
      status: VisitStatus.upcoming,
      visitorName: 'James Whitfield',
      visitorAvatar: 'https://randomuser.me/api/portraits/men/45.jpg',
      visitorPhone: '+1 (415) 555-0134',
    ),
    VisitModel(
      id: 'v2',
      property: MockProperties.byId('p4'),
      date: DateTime(2026, 9, 13),
      timeSlot: '2:30 PM',
      status: VisitStatus.upcoming,
      visitorName: 'James Whitfield',
      visitorAvatar: 'https://randomuser.me/api/portraits/men/45.jpg',
      visitorPhone: '+1 (415) 555-0134',
    ),
    VisitModel(
      id: 'v3',
      property: MockProperties.byId('p3'),
      date: DateTime(2026, 8, 20),
      timeSlot: '11:00 AM',
      status: VisitStatus.completed,
      visitorName: 'James Whitfield',
      visitorAvatar: 'https://randomuser.me/api/portraits/men/45.jpg',
      visitorPhone: '+1 (415) 555-0134',
      note: 'Loved the backyard — following up on pricing.',
    ),
    VisitModel(
      id: 'v4',
      property: MockProperties.byId('p6'),
      date: DateTime(2026, 8, 12),
      timeSlot: '4:00 PM',
      status: VisitStatus.cancelled,
      visitorName: 'James Whitfield',
      visitorAvatar: 'https://randomuser.me/api/portraits/men/45.jpg',
      visitorPhone: '+1 (415) 555-0134',
      note: 'Rescheduling due to a conflict.',
    ),
  ];

  /// Visit requests from the Owner/Agent's perspective.
  static final List<VisitModel> requests = [
    VisitModel(
      id: 'r1',
      property: MockProperties.byId('p1'),
      date: DateTime(2026, 9, 10),
      timeSlot: '10:00 AM',
      status: VisitStatus.pending,
      visitorName: 'James Whitfield',
      visitorAvatar: 'https://randomuser.me/api/portraits/men/45.jpg',
      visitorPhone: '+1 (415) 555-0134',
      note: 'First-time buyer, pre-approved for financing.',
    ),
    VisitModel(
      id: 'r2',
      property: MockProperties.byId('p2'),
      date: DateTime(2026, 9, 9),
      timeSlot: '1:00 PM',
      status: VisitStatus.pending,
      visitorName: 'Olivia Bennett',
      visitorAvatar: 'https://randomuser.me/api/portraits/women/22.jpg',
      visitorPhone: '+1 (415) 555-0155',
    ),
    VisitModel(
      id: 'r3',
      property: MockProperties.byId('p9'),
      date: DateTime(2026, 9, 11),
      timeSlot: '3:30 PM',
      status: VisitStatus.confirmed,
      visitorName: 'Priya Nair',
      visitorAvatar: 'https://randomuser.me/api/portraits/women/33.jpg',
      visitorPhone: '+1 (415) 555-0177',
    ),
    VisitModel(
      id: 'r4',
      property: MockProperties.byId('p7'),
      date: DateTime(2026, 8, 28),
      timeSlot: '9:30 AM',
      status: VisitStatus.completed,
      visitorName: 'Tom Richards',
      visitorAvatar: 'https://randomuser.me/api/portraits/men/61.jpg',
      visitorPhone: '+1 (415) 555-0188',
    ),
    VisitModel(
      id: 'r5',
      property: MockProperties.byId('p6'),
      date: DateTime(2026, 8, 22),
      timeSlot: '5:00 PM',
      status: VisitStatus.cancelled,
      visitorName: 'Marcus Lee',
      visitorAvatar: 'https://randomuser.me/api/portraits/men/12.jpg',
      visitorPhone: '+1 (415) 555-0166',
      note: 'Visitor requested cancellation.',
    ),
  ];
}
