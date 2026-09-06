import 'property_model.dart';

enum LeadStatus { newLead, contacted, negotiating, closed, lost }

extension LeadStatusX on LeadStatus {
  String get label => switch (this) {
        LeadStatus.newLead => 'New',
        LeadStatus.contacted => 'Contacted',
        LeadStatus.negotiating => 'Negotiating',
        LeadStatus.closed => 'Closed',
        LeadStatus.lost => 'Lost',
      };
}

class LeadModel {
  const LeadModel({
    required this.id,
    required this.customerName,
    required this.customerAvatar,
    required this.customerPhone,
    required this.property,
    required this.contactDate,
    required this.status,
    this.message = 'I\'m interested in scheduling a visit for this property. Is it still available?',
  });

  final String id;
  final String customerName;
  final String customerAvatar;
  final String customerPhone;
  final PropertyModel property;
  final DateTime contactDate;
  final LeadStatus status;
  final String message;
}
