import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/coupon_model.dart';
import '../repositories/coupon_repository.dart';

class UpdateCouponUseCase {
  const UpdateCouponUseCase(this._repository);
  final CouponRepository _repository;

  Future<Either<Failure, void>> updateCoupon(CouponModel coupon) =>
      _repository.updateCoupon(coupon);
}
