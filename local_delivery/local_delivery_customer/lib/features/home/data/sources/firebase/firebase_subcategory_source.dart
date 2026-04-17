import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../dto/subcategory_dto.dart';
import '../subcategory_remote_source.dart';

class FirebaseSubcategorySource implements SubcategoryRemoteSource {
  FirebaseSubcategorySource() : _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  @override
  Future<List<SubcategoryDto>> fetchSubcategories(
      {required String categoryId}) async {
    final snapshot = await _firestore
        .collection(FirebaseCollections.subcategories)
        .where('category', isEqualTo: categoryId.toLowerCase())
        .get();
    return snapshot.docs.map(SubcategoryDto.fromFirestore).toList();
  }
}
