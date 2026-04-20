import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/coupon_model.dart';
import '../repositories/coupon_repository.dart';

/// Validates a coupon code for a given user (identified by [phone]).
///
/// Validation steps:
///  1. Coupon exists in Firestore.
///  2. Coupon is active.
///  3. Coupon has not expired.
///  4. User has not already used this coupon.
class ValidateCouponUseCase {
  const ValidateCouponUseCase(this._repository);
  final CouponRepository _repository;

  Future<Either<Failure, CouponModel>> validateCoupon({
    required String code,
    required String phone,
  }) async {
    // 1. Fetch coupon document
    final couponResult =
        await _repository.getCouponByCode(code.trim().toUpperCase());
    if (couponResult.isLeft()) return couponResult;
    final coupon =
        couponResult.getOrElse(() => throw StateError('unreachable'));

    // 2. Active check
    if (!coupon.isActive) {
      return const Left(ValidationFailure('This coupon is no longer active.'));
    }

    // 3. Expiry check
    if (coupon.isExpired) {
      return const Left(ValidationFailure('This coupon has expired.'));
    }

    // 4. Already-used check (per phone)
    final usedResult = await _repository.isCouponUsed(
      code: coupon.code,
      phone: phone,
    );
    if (usedResult.isLeft()) {
      return Left(
          usedResult.swap().getOrElse(() => const ServerFailure()));
    }
    final alreadyUsed = usedResult.getOrElse(() => false);
    if (alreadyUsed) {
      return const Left(
          ValidationFailure('You have already used this coupon.'));
    }

    return Right(coupon);
  }
}
