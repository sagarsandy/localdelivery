import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../dto/product_dto.dart';
import '../product_remote_source.dart';

class FirebaseProductSource implements ProductRemoteSource {
  FirebaseProductSource() : _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  @override
  Future<List<ProductDto>> fetchProducts(
      {required String subcategoryId}) async {
    final snapshot = await _firestore
        .collection(FirebaseCollections.products)
        .where('subcategory', isEqualTo: subcategoryId.toLowerCase())
        .get();
    return snapshot.docs.map(ProductDto.fromFirestore).toList();
  }
}
