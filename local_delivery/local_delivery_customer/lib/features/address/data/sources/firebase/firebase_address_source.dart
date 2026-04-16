import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../dto/address_dto.dart';
import '../address_remote_source.dart';

class FirebaseAddressSource implements AddressRemoteSource {
  FirebaseAddressSource() : _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  @override
  Future<List<AddressDto>> fetchAddresses({required String userId}) async {
    final snapshot = await _firestore
        .collection(FirebaseCollections.addresses)
        .where('user_id', isEqualTo: userId)
        .orderBy('is_default', descending: true)
        .get();
    return snapshot.docs.map(AddressDto.fromFirestore).toList();
  }

  @override
  Future<AddressDto> saveAddress({required AddressDto dto}) async {
    final DocumentReference ref;

    if (dto.id.isEmpty) {
      ref = await _firestore
          .collection(FirebaseCollections.addresses)
          .add(dto.toFirestore());
    } else {
      ref = _firestore
          .collection(FirebaseCollections.addresses)
          .doc(dto.id);
      await ref.set(dto.toFirestore(), SetOptions(merge: true));
    }

    final saved = await ref.get();
    return AddressDto.fromFirestoreDoc(saved);
  }

  @override
  Future<void> deleteAddress({required String addressId}) async {
    await _firestore
        .collection(FirebaseCollections.addresses)
        .doc(addressId)
        .delete();
  }
}
