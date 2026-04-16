import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../../../auth/data/dto/user_dto.dart';
import '../profile_remote_source.dart';

class FirebaseProfileSource implements ProfileRemoteSource {
  FirebaseProfileSource() : _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  @override
  Future<UserDto> fetchProfile({required String userId}) async {
    final doc = await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('Profile not found: $userId');
    }
    return UserDto.fromFirestore(doc);
  }

  @override
  Future<void> updateProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(userId)
        .update(data);
  }
}
