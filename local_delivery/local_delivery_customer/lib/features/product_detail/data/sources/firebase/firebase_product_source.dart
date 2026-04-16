import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../../../store_detail/data/dto/product_dto.dart';
import '../product_remote_source.dart';

class FirebaseProductSource implements ProductRemoteSource {
  FirebaseProductSource() : _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  @override
  Future<ProductDto> fetchProduct({required String productId}) async {
    final doc = await _firestore
        .collection(FirebaseCollections.products)
        .doc(productId)
        .get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Product not found: $productId');
    }
    return ProductDto.fromFirestoreDoc(doc);
  }
}
