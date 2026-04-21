import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/coupon_model.dart';
import '../models/used_coupon_model.dart';

abstract class CouponRepository {
  Future<Either<Failure, List<CouponModel>>> getCoupons();
  Future<Either<Failure, void>> addCoupon(CouponModel coupon);
  Future<Either<Failure, void>> updateCoupon(CouponModel coupon);
  Future<Either<Failure, void>> deleteCoupon({required String id});
  Future<Either<Failure, List<UsedCouponModel>>> getUsedCoupons({
    required String couponCode,
  });
}
