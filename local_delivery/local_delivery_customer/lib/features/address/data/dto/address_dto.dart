import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/address_model.dart';

class AddressDto {
  const AddressDto({
    required this.id,
    required this.userId,
    required this.label,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.pincode,
    required this.isDefault,
  });

  final String id;
  final String userId;
  final String label;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String pincode;
  final bool isDefault;

  factory AddressDto.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AddressDto(
      id: doc.id,
      userId: data['user_id'] as String,
      label: data['label'] as String? ?? 'Home',
      addressLine1: data['address_line_1'] as String,
      addressLine2: data['address_line_2'] as String?,
      city: data['city'] as String,
      pincode: data['pincode'] as String,
      isDefault: data['is_default'] as bool? ?? false,
    );
  }

  factory AddressDto.fromFirestoreDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AddressDto(
      id: doc.id,
      userId: data['user_id'] as String,
      label: data['label'] as String? ?? 'Home',
      addressLine1: data['address_line_1'] as String,
      addressLine2: data['address_line_2'] as String?,
      city: data['city'] as String,
      pincode: data['pincode'] as String,
      isDefault: data['is_default'] as bool? ?? false,
    );
  }

  AddressModel toDomain() => AddressModel(
        id: id,
        userId: userId,
        label: label,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        city: city,
        pincode: pincode,
        isDefault: isDefault,
      );

  /// Map for Firestore write (excludes id).
  Map<String, dynamic> toFirestore() => {
        'user_id': userId,
        'label': label,
        'address_line_1': addressLine1,
        'address_line_2': addressLine2,
        'city': city,
        'pincode': pincode,
        'is_default': isDefault,
      };

  static AddressDto fromDomain(AddressModel model) => AddressDto(
        id: model.id,
        userId: model.userId,
        label: model.label,
        addressLine1: model.addressLine1,
        addressLine2: model.addressLine2,
        city: model.city,
        pincode: model.pincode,
        isDefault: model.isDefault,
      );
}
