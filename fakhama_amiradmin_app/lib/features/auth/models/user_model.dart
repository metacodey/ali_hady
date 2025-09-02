// ignore_for_file: public_member_api_docs, sort_constructors_first
// models/user_model.dart

class UserModel {
  final int? id;
  final String username;
  final String email;
  final String fullName;
  final String phone;
  final String? city;
  final String? country;
  final String? streetAddress;
  final double? latitude;
  final double? longitude;
  final bool isActive;
  final String? token;
  final DateTime? createdAt;

  UserModel(
      {this.id,
      this.username = "",
      this.email = "",
      required this.fullName,
      required this.phone,
      this.city,
      this.country,
      this.streetAddress,
      this.latitude,
      this.longitude,
      required this.isActive,
      this.createdAt,
      this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: int.tryParse(json['id'].toString()),
        username: json['username'] ?? '',
        email: json['email'] ?? '',
        fullName: json['full_name'] ?? '',
        phone: json['phone'] ?? '',
        city: json['city'] ?? '',
        country: json['country'],
        streetAddress: json['street_address'],
        latitude: double.tryParse(json['latitude'].toString()),
        longitude: double.tryParse(json['longitude'].toString()),
        isActive: json['is_active'] == 1 ? true : false,
        createdAt: DateTime.tryParse(json['created_at'].toString()),
        token: json['token']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "full_name": fullName,
      "phone": phone,
      "city": city,
      "country": country,
      "street_address": streetAddress,
      "latitude": latitude,
      "longitude": longitude,
      "is_active": isActive,
      "created_at": createdAt?.toIso8601String(),
      'token': token
    };
  }

  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? fullName,
    String? phone,
    String? city,
    String? country,
    String? streetAddress,
    double? latitude,
    double? longitude,
    bool? isActive,
    String? token,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      country: country ?? this.country,
      streetAddress: streetAddress ?? this.streetAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isActive: isActive ?? this.isActive,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
