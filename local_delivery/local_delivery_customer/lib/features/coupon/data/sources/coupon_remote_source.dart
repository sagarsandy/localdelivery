import '../dto/coupon_dto.dart';

abstract class CouponRemoteSource {
  Future<CouponDto?> fetchCouponByCode(String code);
  Future<bool> isCouponUsed({required String code, required String phone});
  Future<void> markCouponUsed({required String code, required String phone});
}
