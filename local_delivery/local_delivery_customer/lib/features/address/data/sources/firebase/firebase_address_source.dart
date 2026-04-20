import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../dto/address_dto.dart';
import '../address_remote_source.dart';

class FirebaseAddressSource implements AddressRemoteSource {
  FirebaseAddressSource() : _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  CollectionReference get _col =>
      _firestore.collection(FirebaseCollections.addresses);

  @override
  Future<List<AddressDto>> fetchAddresses({required String phone}) async {
    final snapshot = await _col.where('phone', isEqualTo: phone).get();
    return snapshot.docs.map(AddressDto.fromFirestore).toList();
  }

  @override
  Future<AddressDto> saveAddress({required AddressDto dto}) async {
    final DocumentReference ref;

    if (dto.id.isEmpty) {
      ref = await _col.add(dto.toFirestore());
    } else {
      ref = _col.doc(dto.id);
      await ref.set(dto.toFirestore(), SetOptions(merge: true));
    }

    final saved = await ref.get();
    return AddressDto.fromFirestoreDoc(saved);
  }

  @override
  Future<void> deleteAddress({required String addressId}) async {
    await _col.doc(addressId).delete();
  }

  @override
  Future<void> setActiveAddress({
    required String phone,
    required String addressId,
  }) async {
    // Batch update: set is_active=true for the chosen address,
    // is_active=false for all others belonging to this phone.
    final snapshot = await _col.where('phone', isEqualTo: phone).get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isActive': doc.id == addressId});
    }
    await batch.commit();
  }
}
