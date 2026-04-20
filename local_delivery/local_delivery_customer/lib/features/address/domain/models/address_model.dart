import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  const AddressModel({
    required this.id,
    required this.userId,
    required this.phone,
    required this.label,
    required this.address,
    required this.city,
    required this.pincode,
    this.isActive = false,
  });

  final String id;
  final String userId;
  final String phone;
  final String label; // Home / Work / Other
  final String address;
  final String city;
  final String pincode;
  final bool isActive;

  AddressModel copyWith({
    String? id,
    String? userId,
    String? phone,
    String? label,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? pincode,
    bool? isActive,
  }) =>
      AddressModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        phone: phone ?? this.phone,
        label: label ?? this.label,
        address: address,
        city: city ?? this.city,
        pincode: pincode ?? this.pincode,
        isActive: isActive ?? this.isActive,
      );

  String get fullAddress {
    final parts = [
      address,
      city,
      if (pincode.isNotEmpty) pincode,
    ];
    return parts.join(', ');
  }

  /// Short version of the address for header display.
  String get shortAddress {
    final parts = [address, city].where((s) => s.isNotEmpty).toList();
    return parts.join(', ');
  }

  @override
  List<Object?> get props => [id, userId, phone, address, city, isActive];
}
