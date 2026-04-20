import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/address_model.dart';

class AddressDto {
  const AddressDto({
    required this.id,
    required this.userId,
    required this.phone,
    required this.label,
    required this.address,
    required this.city,
    required this.pincode,
    required this.isActive,
  });

  final String id;
  final String userId;
  final String phone;
  final String label;
  final String address;
  final String city;
  final String pincode;
  final bool isActive;

  factory AddressDto.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AddressDto(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      label: data['label'] as String? ?? 'Home',
      address: data['address'] as String ?? '',
      city: data['city'] as String? ?? '',
      pincode: data['pincode'] as String? ?? '',
      isActive: data['isActive'] as bool? ?? false,
    );
  }

  factory AddressDto.fromFirestoreDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AddressDto(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      label: data['label'] as String? ?? 'Home',
      address: data['address'] as String? ?? '',
      city: data['city'] as String? ?? '',
      pincode: data['pincode'] as String? ?? '',
      isActive: data['isActive'] as bool? ?? false,
    );
  }

  AddressModel toDomain() => AddressModel(
        id: id,
        userId: userId,
        phone: phone,
        label: label,
        address: address,
        city: city,
        pincode: pincode,
        isActive: isActive,
      );

  /// Map for Firestore write (excludes id).
  Map<String, dynamic> toFirestore() => {
        'user_id': userId,
        'phone': phone,
        'label': label,
        'address': address,
        'city': city,
        'pincode': pincode,
        'is_active': isActive,
      };

  static AddressDto fromDomain(AddressModel model) => AddressDto(
        id: model.id,
        userId: model.userId,
        phone: model.phone,
        label: model.label,
        address: model.address,
        city: model.city,
        pincode: model.pincode,
        isActive: model.isActive,
      );
}
