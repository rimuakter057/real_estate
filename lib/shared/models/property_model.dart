import 'agent_model.dart';

enum ListingKind { sale, rent }

enum PropertyType { apartment, house, villa, land, office, shop, commercial }

enum PropertyStatus { active, pending, draft, sold }

extension PropertyTypeLabel on PropertyType {
  String get label => switch (this) {
        PropertyType.apartment => 'Apartment',
        PropertyType.house => 'House',
        PropertyType.villa => 'Villa',
        PropertyType.land => 'Land',
        PropertyType.office => 'Office',
        PropertyType.shop => 'Shop',
        PropertyType.commercial => 'Commercial',
      };
}

class PropertyModel {
  const PropertyModel({
    required this.id,
    required this.title,
    required this.images,
    required this.kind,
    required this.type,
    required this.price,
    required this.location,
    required this.city,
    required this.bedrooms,
    required this.bathrooms,
    required this.areaSqft,
    required this.rating,
    required this.agent,
    required this.description,
    required this.amenities,
    this.status = PropertyStatus.active,
    this.floor,
    this.furnished = 'Semi-Furnished',
    this.propertyAge = '2 years',
    this.views = 0,
    this.interested = 0,
    this.postedDate,
    this.featured = false,
    this.lat = 25.2048,
    this.lng = 55.2708,
  });

  final String id;
  final String title;
  final List<String> images;
  final ListingKind kind;
  final PropertyType type;
  final double price;
  final String location;
  final String city;
  final int bedrooms;
  final int bathrooms;
  final int areaSqft;
  final double rating;
  final AgentModel agent;
  final String description;
  final List<String> amenities;
  final PropertyStatus status;
  final String? floor;
  final String furnished;
  final String propertyAge;
  final int views;
  final int interested;
  final DateTime? postedDate;
  final bool featured;
  final double lat;
  final double lng;

  String get priceLabel {
    final formatted = _formatPrice(price);
    return kind == ListingKind.rent ? '$formatted/mo' : formatted;
  }

  static String _formatPrice(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 1)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }
}
