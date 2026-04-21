import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../dto/subcategory_dto.dart';
import '../subcategory_remote_source.dart';

class FirebaseSubcategorySource implements SubcategoryRemoteSource {
  FirebaseSubcategorySource() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference get _col =>
      _firestore.collection(FirebaseCollections.subcategories);

  @override
  Future<List<SubcategoryDto>> fetchSubcategories() async {
    final snapshot = await _col.orderBy('title').get();
    return snapshot.docs
        .map((doc) => SubcategoryDto.fromFirestore(doc))
        .toList();
  }

  @override
  Future<void> addSubcategory({
    required String title,
    required String image,
    required String category,
  }) async {
    await _col.add({
      'title': title.trim(),
      'image': image.trim(),
      'category': category.toLowerCase(),
    });
  }

  @override
  Future<void> updateSubcategory({
    required String id,
    required String title,
    required String image,
    required String category,
  }) async {
    await _col.doc(id).update({
      'title': title.trim(),
      'image': image.trim(),
      'category': category.toLowerCase(),
    });
  }

  @override
  Future<void> deleteSubcategory({required String id}) async {
    await _col.doc(id).delete();
  }
}
