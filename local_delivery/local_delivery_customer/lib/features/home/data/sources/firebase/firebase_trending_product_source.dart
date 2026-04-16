import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../dto/trending_product_dto.dart';
import '../trending_product_remote_source.dart';

class FirebaseTrendingProductSource implements TrendingProductRemoteSource {
  FirebaseTrendingProductSource() : _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  @override
  Future<List<TrendingProductDto>> fetchTrendingProducts(
      {int limit = 10}) async {
    final snapshot = await _firestore
        .collection(FirebaseCollections.products)
        // .where('isAvailable', isEqualTo: true)
        // .where('inStock', isEqualTo: true)
        .limit(limit)
        .get();
    return snapshot.docs.map(TrendingProductDto.fromFirestore).toList();
  }
}
