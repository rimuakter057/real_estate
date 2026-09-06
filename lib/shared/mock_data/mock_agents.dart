import '../models/agent_model.dart';

class MockAgents {
  MockAgents._();

  static const sofia = AgentModel(
    id: 'agent_1',
    name: 'Sofia Martinez',
    avatarUrl: 'https://randomuser.me/api/portraits/women/65.jpg',
    title: 'Senior Property Consultant',
    phone: '+1 (415) 555-0142',
    email: 'sofia.martinez@skylinerealty.com',
    rating: 4.9,
    reviewsCount: 128,
    propertiesCount: 24,
    verification: VerificationStatus.verified,
    isOnline: true,
  );

  static const daniel = AgentModel(
    id: 'agent_2',
    name: 'Daniel Cooper',
    avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    title: 'Luxury Homes Specialist',
    phone: '+1 (415) 555-0198',
    email: 'daniel.cooper@skylinerealty.com',
    rating: 4.8,
    reviewsCount: 96,
    propertiesCount: 18,
    verification: VerificationStatus.verified,
    isOnline: false,
  );

  static const amara = AgentModel(
    id: 'agent_3',
    name: 'Amara Johnson',
    avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
    title: 'Independent Property Owner',
    phone: '+1 (415) 555-0176',
    email: 'amara.johnson@gmail.com',
    rating: 4.6,
    reviewsCount: 41,
    propertiesCount: 6,
    verification: VerificationStatus.pending,
    isOnline: true,
  );

  static const ethan = AgentModel(
    id: 'agent_4',
    name: 'Ethan Brooks',
    avatarUrl: 'https://randomuser.me/api/portraits/men/76.jpg',
    title: 'Commercial Leasing Agent',
    phone: '+1 (415) 555-0110',
    email: 'ethan.brooks@primeestates.com',
    rating: 4.7,
    reviewsCount: 63,
    propertiesCount: 15,
    verification: VerificationStatus.verified,
    isOnline: false,
    company: 'Prime Estates',
  );

  static const maria = AgentModel(
    id: 'agent_5',
    name: 'Maria Gonzalez',
    avatarUrl: 'https://randomuser.me/api/portraits/women/68.jpg',
    title: 'Residential Sales Agent',
    phone: '+1 (415) 555-0221',
    email: 'maria.gonzalez@skylinerealty.com',
    rating: 4.9,
    reviewsCount: 154,
    propertiesCount: 31,
    verification: VerificationStatus.verified,
    isOnline: true,
  );

  static const List<AgentModel> all = [sofia, daniel, amara, ethan, maria];

  /// The signed-in Owner/Agent for the Owner role demo.
  static const me = sofia;
}
