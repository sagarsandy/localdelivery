import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../repositories/coupon_repository.dart';

class DeleteCouponUseCase {
  const DeleteCouponUseCase(this._repository);
  final CouponRepository _repository;

  Future<Either<Failure, void>> deleteCoupon({required String id}) =>
      _repository.deleteCoupon(id: id);
}
