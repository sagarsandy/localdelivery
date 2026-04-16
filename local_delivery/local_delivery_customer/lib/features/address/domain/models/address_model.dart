import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  const AddressModel({
    required this.id,
    required this.userId,
    required this.label,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.pincode,
    this.isDefault = false,
  });

  final String id;
  final String userId;
  final String label; // Home / Work / Other
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String pincode;
  final bool isDefault;

  AddressModel copyWith({
    String? id,
    String? userId,
    String? label,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? pincode,
    bool? isDefault,
  }) =>
      AddressModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        label: label ?? this.label,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        city: city ?? this.city,
        pincode: pincode ?? this.pincode,
        isDefault: isDefault ?? this.isDefault,
      );

  factory AddressModel.fromMap(Map<String, dynamic> map) => AddressModel(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        label: map['label'] as String? ?? 'Home',
        addressLine1: map['address_line_1'] as String,
        addressLine2: map['address_line_2'] as String?,
        city: map['city'] as String,
        pincode: map['pincode'] as String,
        isDefault: map['is_default'] as bool? ?? false,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'label': label,
        'address_line_1': addressLine1,
        'address_line_2': addressLine2,
        'city': city,
        'pincode': pincode,
        'is_default': isDefault,
      };

  String get fullAddress {
    final parts = [
      addressLine1,
      if (addressLine2 != null && addressLine2!.isNotEmpty) addressLine2!,
      city,
      pincode,
    ];
    return parts.join(', ');
  }

  @override
  List<Object?> get props => [id, userId, addressLine1, city];
}
