import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/address_model.dart';

class AddressDto {
  const AddressDto({
    required this.id,
    required this.phone,
    required this.address,
    required this.city,
    required this.pincode,
    required this.state,
    required this.isActive,
  });

  final String id;
  final String phone;
  final String address;
  final String city;
  final String pincode;
  final String state;
  final bool isActive;

  factory AddressDto.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AddressDto(
      id: doc.id,
      phone: data['phone'] as String? ?? '',
      address: data['address'] as String? ?? '',
      city: data['city'] as String? ?? '',
      pincode: data['pincode'] as String? ?? '',
      state: data['state'] as String? ?? '',
      isActive: data['isActive'] as bool? ?? false,
    );
  }

  factory AddressDto.fromFirestoreDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AddressDto(
      id: doc.id,
      phone: data['phone'] as String? ?? '',
      address: data['address'] as String? ?? '',
      city: data['city'] as String? ?? '',
      pincode: data['pincode'] as String? ?? '',
      state: data['state'] as String? ?? '',
      isActive: data['isActive'] as bool? ?? false,
    );
  }

  AddressModel toDomain() => AddressModel(
        id: id,
        phone: phone,
        address: address,
        city: city,
        pincode: pincode,
        state: state,
        isActive: isActive,
      );

  /// Map for Firestore write (excludes id).
  Map<String, dynamic> toFirestore() => {
        'phone': phone,
        'address': address,
        'city': city,
        'pincode': pincode,
        'state': state,
        'isActive': isActive,
      };

  static AddressDto fromDomain(AddressModel model) => AddressDto(
        id: model.id,
        phone: model.phone,
        address: model.address,
        city: model.city,
        pincode: model.pincode,
        state: model.state,
        isActive: model.isActive,
      );
}
