import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/used_coupon_model.dart';
import '../repositories/coupon_repository.dart';

class GetUsedCouponsUseCase {
  const GetUsedCouponsUseCase(this._repository);
  final CouponRepository _repository;

  Future<Either<Failure, List<UsedCouponModel>>> getUsedCoupons({
    required String couponCode,
  }) =>
      _repository.getUsedCoupons(couponCode: couponCode);
}
