import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  const AddressModel({
    required this.id,
    required this.phone,
    required this.address,
    required this.city,
    required this.pincode,
    required this.state,
    this.isActive = false,
  });

  final String id;
  final String phone;
  final String address;
  final String city;
  final String pincode;
  final String state;
  final bool isActive;

  AddressModel copyWith({
    String? id,
    String? phone,
    String? address,
    String? city,
    String? pincode,
    String? state,
    bool? isActive,
  }) =>
      AddressModel(
        id: id ?? this.id,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        city: city ?? this.city,
        pincode: pincode ?? this.pincode,
        state: state ?? this.state,
        isActive: isActive ?? this.isActive,
      );

  String get fullAddress {
    final parts = [
      address,
      city,
      if (state.isNotEmpty) state,
      if (pincode.isNotEmpty) pincode,
    ];
    return parts.join(', ');
  }

  String get shortAddress {
    final parts = [address, city].where((s) => s.isNotEmpty).toList();
    return parts.join(', ');
  }

  @override
  List<Object?> get props => [id, phone, address, city, pincode, state, isActive];
}
