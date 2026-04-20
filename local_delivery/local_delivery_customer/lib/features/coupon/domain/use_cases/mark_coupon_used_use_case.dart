import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../repositories/coupon_repository.dart';

class MarkCouponUsedUseCase {
  const MarkCouponUsedUseCase(this._repository);
  final CouponRepository _repository;

  Future<Either<Failure, void>> markCouponUsed({
    required String code,
    required String phone,
  }) =>
      _repository.markCouponUsed(code: code, phone: phone);
}
