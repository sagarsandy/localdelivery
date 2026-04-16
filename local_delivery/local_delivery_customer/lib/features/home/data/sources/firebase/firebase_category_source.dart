import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../dto/category_dto.dart';
import '../category_remote_source.dart';

class FirebaseCategorySource implements CategoryRemoteSource {
  FirebaseCategorySource() : _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  @override
  Future<List<CategoryDto>> fetchCategories() async {
    final snapshot = await _firestore
        .collection(FirebaseCollections.categories)
        .get();
    return snapshot.docs.map(CategoryDto.fromFirestore).toList();
  }
}
