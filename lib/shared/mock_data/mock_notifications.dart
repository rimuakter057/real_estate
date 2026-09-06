import '../models/notification_model.dart';

class MockNotifications {
  MockNotifications._();

  static final List<AppNotification> buyer = [
    AppNotification(
      id: 'n1',
      title: 'Visit Confirmed',
      body: 'Your visit to Modern Skyline Villa is confirmed for Sep 10, 10:00 AM.',
      time: DateTime(2026, 9, 5, 19, 0),
      kind: NotificationKind.visit,
    ),
    AppNotification(
      id: 'n2',
      title: 'New Message',
      body: 'Sofia Martinez sent you a message about Modern Skyline Villa.',
      time: DateTime(2026, 9, 5, 18, 42),
      kind: NotificationKind.message,
    ),
    AppNotification(
      id: 'n3',
      title: 'Price Drop',
      body: 'Seaview Penthouse Suite dropped in price by \$50,000.',
      time: DateTime(2026, 9, 4, 8, 0),
      kind: NotificationKind.price,
      read: true,
    ),
    AppNotification(
      id: 'n4',
      title: 'Saved Search Match',
      body: '3 new properties match your saved search in Dubai Marina.',
      time: DateTime(2026, 9, 3, 10, 15),
      kind: NotificationKind.favorite,
      read: true,
    ),
    AppNotification(
      id: 'n5',
      title: 'Welcome to EstateHub',
      body: 'Complete your profile to get personalized property recommendations.',
      time: DateTime(2026, 8, 28, 9, 0),
      kind: NotificationKind.system,
      read: true,
    ),
  ];

  static final List<AppNotification> owner = [
    AppNotification(
      id: 'on1',
      title: 'New Lead',
      body: 'James Whitfield is interested in Modern Skyline Villa.',
      time: DateTime(2026, 9, 4, 10, 30),
      kind: NotificationKind.lead,
    ),
    AppNotification(
      id: 'on2',
      title: 'Visit Request',
      body: 'Olivia Bennett requested a visit for Downtown Loft Apartment.',
      time: DateTime(2026, 9, 3, 16, 10),
      kind: NotificationKind.visit,
    ),
    AppNotification(
      id: 'on3',
      title: 'Property Approved',
      body: 'Your listing "Beachfront Apartment" has been approved and is now live.',
      time: DateTime(2026, 9, 1, 14, 0),
      kind: NotificationKind.approval,
      read: true,
    ),
    AppNotification(
      id: 'on4',
      title: 'Listing Milestone',
      body: 'Seaview Penthouse Suite just crossed 2,000 views!',
      time: DateTime(2026, 8, 30, 11, 0),
      kind: NotificationKind.system,
      read: true,
    ),
  ];
}
