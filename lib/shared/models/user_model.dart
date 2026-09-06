enum UserRole { buyer, owner, admin }

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.role,
    this.company,
    this.verified = false,
    this.joinedDate,
    this.bio,
    this.active = true,
    this.savedCount = 0,
    this.city,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final UserRole role;
  final String? company;
  final bool verified;
  final DateTime? joinedDate;
  final String? bio;
  final bool active;
  final int savedCount;
  final String? city;

  AppUser copyWith({bool? active}) {
    return AppUser(
      id: id,
      name: name,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl,
      role: role,
      company: company,
      verified: verified,
      joinedDate: joinedDate,
      bio: bio,
      active: active ?? this.active,
      savedCount: savedCount,
      city: city,
    );
  }
}
