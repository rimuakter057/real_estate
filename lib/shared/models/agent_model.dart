enum VerificationStatus { verified, pending, unverified }

class AgentModel {
  const AgentModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.title,
    required this.phone,
    required this.email,
    required this.rating,
    required this.reviewsCount,
    required this.propertiesCount,
    required this.verification,
    this.isOnline = false,
    this.active = true,
    this.company = 'Skyline Realty',
    this.about =
        'Dedicated real-estate professional with a strong track record of helping clients find their perfect home. Focused on transparent communication and fast responses.',
    this.joinedDate,
  });

  final String id;
  final String name;
  final String avatarUrl;
  final String title;
  final String phone;
  final String email;
  final double rating;
  final int reviewsCount;
  final int propertiesCount;
  final VerificationStatus verification;
  final bool isOnline;
  final bool active;
  final String company;
  final String about;
  final DateTime? joinedDate;

  AgentModel copyWith({bool? active, VerificationStatus? verification}) {
    return AgentModel(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      title: title,
      phone: phone,
      email: email,
      rating: rating,
      reviewsCount: reviewsCount,
      propertiesCount: propertiesCount,
      verification: verification ?? this.verification,
      isOnline: isOnline,
      active: active ?? this.active,
      company: company,
      about: about,
      joinedDate: joinedDate,
    );
  }
}
