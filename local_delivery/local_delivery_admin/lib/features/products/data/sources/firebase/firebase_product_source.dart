import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../../domain/models/product_model.dart';
import '../../dto/product_dto.dart';
import '../product_remote_source.dart';

class FirebaseProductSource implements ProductRemoteSource {
  FirebaseProductSource() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference get _col =>
      _firestore.collection(FirebaseCollections.products);

  @override
  Future<List<ProductDto>> fetchProducts() async {
    final snapshot = await _col.orderBy('title').get();
    return snapshot.docs.map((doc) => ProductDto.fromFirestore(doc)).toList();
  }

  @override
  Future<void> addProduct(ProductModel product) async {
    await _col.add(ProductDto.fromModel(product));
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await _col.doc(product.id).update(ProductDto.fromModel(product));
  }

  @override
  Future<void> deleteProduct({required String id}) async {
    await _col.doc(id).delete();
  }
}
