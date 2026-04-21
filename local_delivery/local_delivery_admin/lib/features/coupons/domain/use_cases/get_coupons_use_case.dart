import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/coupon_model.dart';
import '../repositories/coupon_repository.dart';

class GetCouponsUseCase {
  const GetCouponsUseCase(this._repository);
  final CouponRepository _repository;

  Future<Either<Failure, List<CouponModel>>> getCoupons() =>
      _repository.getCoupons();
}
