import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../dto/category_dto.dart';
import '../category_remote_source.dart';

class FirebaseCategorySource implements CategoryRemoteSource {
  FirebaseCategorySource() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference get _col =>
      _firestore.collection(FirebaseCollections.categories);

  @override
  Future<List<CategoryDto>> fetchCategories() async {
    final snapshot = await _col.orderBy('title').get();
    return snapshot.docs
        .map((doc) => CategoryDto.fromFirestore(doc))
        .toList();
  }

  @override
  Future<void> addCategory({
    required String title,
    required String image,
  }) async {
    await _col.add({'title': title.trim(), 'image': image.trim()});
  }

  @override
  Future<void> updateCategory({
    required String id,
    required String title,
    required String image,
  }) async {
    await _col.doc(id).update({'title': title.trim(), 'image': image.trim()});
  }

  @override
  Future<void> deleteCategory({required String id}) async {
    await _col.doc(id).delete();
  }
}
