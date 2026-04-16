import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
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

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'] as String,
        phone: map['phone'] as String? ?? '',
        name: map['name'] as String?,
        email: map['email'] as String?,
        avatarUrl: map['avatar_url'] as String?,
        createdAt: map['created_at'] != null
            ? DateTime.tryParse(map['created_at'] as String)
            : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'phone': phone,
        'name': name,
        'email': email,
        'avatar_url': avatarUrl,
      };

  @override
  List<Object?> get props => [id, phone, name, email, avatarUrl];
}
