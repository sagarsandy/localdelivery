import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../dto/store_dto.dart';
import '../store_remote_source.dart';

class FirebaseStoreSource implements StoreRemoteSource {
  FirebaseStoreSource() : _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  @override
  Future<List<StoreDto>> fetchStores({String? categoryId}) async {
    Query<Map<String, dynamic>> query = _firestore
        .collection(FirebaseCollections.stores)
        .where('is_active', isEqualTo: true)
        .orderBy('name');

    if (categoryId != null) {
      query = query.where('category_ids', arrayContains: categoryId);
    }

    final snapshot = await query.get();
    return snapshot.docs.map(StoreDto.fromFirestore).toList();
  }
}
