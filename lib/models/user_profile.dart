class UserProfile {
  final String id;
  final String nationalId;
  final String fullNameArabic;
  final String fullNameEnglish;
  final String phoneNumber;
  final String? email;
  final DateTime dateOfBirth;
  final String governorate;
  final String city;
  final String street;
  final String? profilePhotoUrl;
  final KYCStatus kycStatus;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.nationalId,
    required this.fullNameArabic,
    required this.fullNameEnglish,
    required this.phoneNumber,
    this.email,
    required this.dateOfBirth,
    required this.governorate,
    required this.city,
    required this.street,
    this.profilePhotoUrl,
    this.kycStatus = KYCStatus.pending,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nationalId': nationalId,
      'fullNameArabic': fullNameArabic,
      'fullNameEnglish': fullNameEnglish,
      'phoneNumber': phoneNumber,
      'email': email,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'governorate': governorate,
      'city': city,
      'street': street,
      'profilePhotoUrl': profilePhotoUrl,
      'kycStatus': kycStatus.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      nationalId: map['nationalId'] as String,
      fullNameArabic: map['fullNameArabic'] as String,
      fullNameEnglish: map['fullNameEnglish'] as String,
      phoneNumber: map['phoneNumber'] as String,
      email: map['email'] as String?,
      dateOfBirth: DateTime.parse(map['dateOfBirth'] as String),
      governorate: map['governorate'] as String,
      city: map['city'] as String,
      street: map['street'] as String,
      profilePhotoUrl: map['profilePhotoUrl'] as String?,
      kycStatus: KYCStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['kycStatus'],
        orElse: () => KYCStatus.pending,
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}

enum KYCStatus {
  pending,
  verified,
  rejected,
}

// Egyptian Governorates
class EgyptianGovernorates {
  static const List<String> all = [
    'Cairo',
    'Giza',
    'Alexandria',
    'Dakahlia',
    'Red Sea',
    'Beheira',
    'Fayoum',
    'Gharbia',
    'Ismailia',
    'Menofia',
    'Minya',
    'Qaliubiya',
    'New Valley',
    'Suez',
    'Aswan',
    'Assiut',
    'Beni Suef',
    'Port Said',
    'Damietta',
    'Sharkia',
    'South Sinai',
    'Kafr El Sheikh',
    'Matrouh',
    'Luxor',
    'Qena',
    'North Sinai',
    'Sohag',
  ];
}
