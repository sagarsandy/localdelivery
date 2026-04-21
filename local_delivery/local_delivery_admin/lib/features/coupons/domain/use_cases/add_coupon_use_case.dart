import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/coupon_model.dart';
import '../repositories/coupon_repository.dart';

class AddCouponUseCase {
  const AddCouponUseCase(this._repository);
  final CouponRepository _repository;

  Future<Either<Failure, void>> addCoupon(CouponModel coupon) =>
      _repository.addCoupon(coupon);
}
