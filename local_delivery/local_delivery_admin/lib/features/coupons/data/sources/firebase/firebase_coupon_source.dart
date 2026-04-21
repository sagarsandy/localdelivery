import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/data/remote/firebase/firebase_collections.dart';
import '../../../domain/models/coupon_model.dart';
import '../../dto/coupon_dto.dart';
import '../../dto/used_coupon_dto.dart';
import '../coupon_remote_source.dart';

class FirebaseCouponSource implements CouponRemoteSource {
  FirebaseCouponSource() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference get _coupons =>
      _firestore.collection(FirebaseCollections.coupons);

  CollectionReference get _usedCoupons =>
      _firestore.collection(FirebaseCollections.usedCoupons);

  @override
  Future<List<CouponDto>> fetchCoupons() async {
    final snapshot = await _coupons.orderBy('coupon').get();
    return snapshot.docs.map((doc) => CouponDto.fromFirestore(doc)).toList();
  }

  @override
  Future<void> addCoupon(CouponModel coupon) async {
    await _coupons.add(CouponDto.fromModel(coupon));
  }

  @override
  Future<void> updateCoupon(CouponModel coupon) async {
    await _coupons.doc(coupon.id).update(CouponDto.fromModel(coupon));
  }

  @override
  Future<void> deleteCoupon({required String id}) async {
    await _coupons.doc(id).delete();
  }

  @override
  Future<List<UsedCouponDto>> fetchUsedCoupons({
    required String couponCode,
  }) async {
    final snapshot =
        await _usedCoupons.where('coupon', isEqualTo: couponCode).get();
    return snapshot.docs
        .map((doc) => UsedCouponDto.fromFirestore(doc))
        .toList();
  }
}
