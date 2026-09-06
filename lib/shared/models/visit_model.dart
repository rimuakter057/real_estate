import 'property_model.dart';

enum VisitStatus { upcoming, completed, cancelled, pending, confirmed }

class VisitModel {
  const VisitModel({
    required this.id,
    required this.property,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.visitorName,
    required this.visitorAvatar,
    required this.visitorPhone,
    this.note,
  });

  final String id;
  final PropertyModel property;
  final DateTime date;
  final String timeSlot;
  final VisitStatus status;
  final String visitorName;
  final String visitorAvatar;
  final String visitorPhone;
  final String? note;
}
