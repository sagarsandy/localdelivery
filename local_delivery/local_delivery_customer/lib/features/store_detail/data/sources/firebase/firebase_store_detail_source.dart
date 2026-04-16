import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../../../home/data/dto/store_dto.dart';
import '../../dto/product_dto.dart';
import '../store_detail_remote_source.dart';

class FirebaseStoreDetailSource implements StoreDetailRemoteSource {
  FirebaseStoreDetailSource() : _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  @override
  Future<StoreDto> fetchStore({required String storeId}) async {
    final doc = await _firestore
        .collection(FirebaseCollections.stores)
        .doc(storeId)
        .get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Store not found: $storeId');
    }
    return StoreDto.fromFirestoreDoc(doc);
  }

  @override
  Future<List<ProductDto>> fetchProducts({
    required String storeId,
    String? categoryId,
  }) async {
    Query<Map<String, dynamic>> query = _firestore
        .collection(FirebaseCollections.products)
        .where('store_id', isEqualTo: storeId)
        .where('is_available', isEqualTo: true)
        .orderBy('sort_order');

    if (categoryId != null) {
      query = query.where('category_id', isEqualTo: categoryId);
    }

    final snapshot = await query.get();
    return snapshot.docs.map(ProductDto.fromFirestore).toList();
  }
}
