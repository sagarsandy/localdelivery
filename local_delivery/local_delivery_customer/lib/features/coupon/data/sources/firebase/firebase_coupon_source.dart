import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../dto/coupon_dto.dart';
import '../coupon_remote_source.dart';

class FirebaseCouponSource implements CouponRemoteSource {
  FirebaseCouponSource() : _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  @override
  Future<CouponDto?> fetchCouponByCode(String code) async {
    final snapshot = await _firestore
        .collection(FirebaseCollections.coupons)
        .where('coupon', isEqualTo: code)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return CouponDto.fromFirestore(snapshot.docs.first);
  }

  @override
  Future<bool> isCouponUsed({
    required String code,
    required String phone,
  }) async {
    final snapshot = await _firestore
        .collection(FirebaseCollections.usedCoupons)
        .where('coupon', isEqualTo: code)
        .where('phone', isEqualTo: phone)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  @override
  Future<void> markCouponUsed({
    required String code,
    required String phone,
  }) async {
    await _firestore.collection(FirebaseCollections.usedCoupons).add({
      'coupon': code,
      'phone': phone,
      'date': FieldValue.serverTimestamp(),
    });
  }
}
