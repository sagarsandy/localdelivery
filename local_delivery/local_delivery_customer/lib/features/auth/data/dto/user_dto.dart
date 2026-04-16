import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/user_model.dart';

/// Firestore representation of a user document.
/// Handles Firestore-specific types (Timestamp) and ID injection from doc.id.
class UserDto {
  const UserDto({
    required this.id,
    required this.phone,
    this.name,
    this.email,
    this.avatarUrl,
    this.createdAt,
  });

  final String id;
  final String phone;
  final String? name;
  final String? email;
  final String? avatarUrl;
  final DateTime? createdAt;

  factory UserDto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserDto(
      id: doc.id,
      phone: data['phone'] as String? ?? '',
      name: data['name'] as String?,
      email: data['email'] as String?,
      avatarUrl: data['avatar_url'] as String?,
      createdAt: _toDateTime(data['created_at']),
    );
  }

  UserModel toDomain() => UserModel(
        id: id,
        phone: phone,
        name: name,
        email: email,
        avatarUrl: avatarUrl,
        createdAt: createdAt,
      );

  /// Converts to a map suitable for Firestore writes (excludes id).
  Map<String, dynamic> toFirestore() => {
        'phone': phone,
        'name': name,
        'email': email,
        'avatar_url': avatarUrl,
      };

  static DateTime? _toDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
