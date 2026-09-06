import 'property_model.dart';

enum ReportStatus { pending, resolved, dismissed }

class ReportModel {
  const ReportModel({
    required this.id,
    required this.property,
    required this.reason,
    required this.reporterName,
    required this.reporterAvatar,
    required this.date,
    required this.status,
    this.details,
  });

  final String id;
  final PropertyModel property;
  final String reason;
  final String reporterName;
  final String reporterAvatar;
  final DateTime date;
  final ReportStatus status;
  final String? details;
}
