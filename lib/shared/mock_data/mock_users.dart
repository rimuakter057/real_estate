import '../models/user_model.dart';

class MockUsers {
  MockUsers._();

  static const buyer = AppUser(
    id: 'u_buyer_1',
    name: 'James Whitfield',
    email: 'james.whitfield@gmail.com',
    phone: '+1 (415) 555-0134',
    avatarUrl: 'https://randomuser.me/api/portraits/men/45.jpg',
    role: UserRole.buyer,
    joinedDate: null,
    bio: 'Looking for a family-friendly home close to good schools.',
    savedCount: 8,
    city: 'Dubai, UAE',
  );

  static const admin = AppUser(
    id: 'u_admin_1',
    name: 'Rachel Kim',
    email: 'rachel.kim@estatehub.com',
    phone: '+1 (415) 555-0199',
    avatarUrl: 'https://randomuser.me/api/portraits/women/50.jpg',
    role: UserRole.admin,
    verified: true,
    city: 'Dubai, UAE',
  );

  static final List<AppUser> platformUsers = [
    const AppUser(
      id: 'u1',
      name: 'James Whitfield',
      email: 'james.whitfield@gmail.com',
      phone: '+1 (415) 555-0134',
      avatarUrl: 'https://randomuser.me/api/portraits/men/45.jpg',
      role: UserRole.buyer,
      active: true,
      savedCount: 8,
      city: 'Dubai, UAE',
    ),
    const AppUser(
      id: 'u2',
      name: 'Olivia Bennett',
      email: 'olivia.bennett@gmail.com',
      phone: '+1 (415) 555-0155',
      avatarUrl: 'https://randomuser.me/api/portraits/women/22.jpg',
      role: UserRole.buyer,
      active: true,
      savedCount: 14,
      city: 'Abu Dhabi, UAE',
    ),
    const AppUser(
      id: 'u3',
      name: 'Marcus Lee',
      email: 'marcus.lee@gmail.com',
      phone: '+1 (415) 555-0166',
      avatarUrl: 'https://randomuser.me/api/portraits/men/12.jpg',
      role: UserRole.buyer,
      active: false,
      savedCount: 2,
      city: 'Sharjah, UAE',
    ),
    const AppUser(
      id: 'u4',
      name: 'Priya Nair',
      email: 'priya.nair@gmail.com',
      phone: '+1 (415) 555-0177',
      avatarUrl: 'https://randomuser.me/api/portraits/women/33.jpg',
      role: UserRole.buyer,
      active: true,
      savedCount: 21,
      city: 'Dubai, UAE',
    ),
    const AppUser(
      id: 'u5',
      name: 'Tom Richards',
      email: 'tom.richards@gmail.com',
      phone: '+1 (415) 555-0188',
      avatarUrl: 'https://randomuser.me/api/portraits/men/61.jpg',
      role: UserRole.buyer,
      active: true,
      savedCount: 5,
      city: 'Dubai, UAE',
    ),
  ];
}
