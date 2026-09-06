enum NotificationKind { message, visit, favorite, price, system, lead, approval }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.kind,
    this.read = false,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String body;
  final DateTime time;
  final NotificationKind kind;
  final bool read;
  final String? imageUrl;
}
