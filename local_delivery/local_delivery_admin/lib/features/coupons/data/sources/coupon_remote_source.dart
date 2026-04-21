import '../dto/coupon_dto.dart';
import '../dto/used_coupon_dto.dart';
import '../../domain/models/coupon_model.dart';

abstract class CouponRemoteSource {
  Future<List<CouponDto>> fetchCoupons();
  Future<void> addCoupon(CouponModel coupon);
  Future<void> updateCoupon(CouponModel coupon);
  Future<void> deleteCoupon({required String id});
  Future<List<UsedCouponDto>> fetchUsedCoupons({required String couponCode});
}
