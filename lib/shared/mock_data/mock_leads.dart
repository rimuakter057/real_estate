import '../models/lead_model.dart';
import 'mock_properties.dart';

class MockLeads {
  MockLeads._();

  static final List<LeadModel> all = [
    LeadModel(
      id: 'l1',
      customerName: 'James Whitfield',
      customerAvatar: 'https://randomuser.me/api/portraits/men/45.jpg',
      customerPhone: '+1 (415) 555-0134',
      property: MockProperties.byId('p1'),
      contactDate: DateTime(2026, 9, 4, 10, 30),
      status: LeadStatus.newLead,
      message: 'Hi, is the villa still available? I\'d love to schedule a viewing this weekend.',
    ),
    LeadModel(
      id: 'l2',
      customerName: 'Olivia Bennett',
      customerAvatar: 'https://randomuser.me/api/portraits/women/22.jpg',
      customerPhone: '+1 (415) 555-0155',
      property: MockProperties.byId('p2'),
      contactDate: DateTime(2026, 9, 3, 16, 10),
      status: LeadStatus.contacted,
      message: 'Can you share the floor plan and maintenance fees for this loft?',
    ),
    LeadModel(
      id: 'l3',
      customerName: 'Marcus Lee',
      customerAvatar: 'https://randomuser.me/api/portraits/men/12.jpg',
      customerPhone: '+1 (415) 555-0166',
      property: MockProperties.byId('p1'),
      contactDate: DateTime(2026, 9, 2, 9, 0),
      status: LeadStatus.negotiating,
      message: 'We\'re very interested — is there any flexibility on the asking price?',
    ),
    LeadModel(
      id: 'l4',
      customerName: 'Priya Nair',
      customerAvatar: 'https://randomuser.me/api/portraits/women/33.jpg',
      customerPhone: '+1 (415) 555-0177',
      property: MockProperties.byId('p7'),
      contactDate: DateTime(2026, 8, 30, 14, 45),
      status: LeadStatus.closed,
      message: 'Thank you for the tour — we\'d like to proceed with the purchase.',
    ),
    LeadModel(
      id: 'l5',
      customerName: 'Tom Richards',
      customerAvatar: 'https://randomuser.me/api/portraits/men/61.jpg',
      customerPhone: '+1 (415) 555-0188',
      property: MockProperties.byId('p9'),
      contactDate: DateTime(2026, 8, 27, 11, 20),
      status: LeadStatus.lost,
      message: 'We ended up going with another property closer to the school.',
    ),
  ];
}
