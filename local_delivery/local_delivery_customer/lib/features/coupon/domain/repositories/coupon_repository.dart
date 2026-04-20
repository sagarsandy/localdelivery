import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/coupon_model.dart';

abstract class CouponRepository {
  /// Fetches a coupon by its code. Returns [NotFoundFailure] if missing.
  Future<Either<Failure, CouponModel>> getCouponByCode(String code);

  /// Returns true if [phone] has already used [code].
  Future<Either<Failure, bool>> isCouponUsed({
    required String code,
    required String phone,
  });

  /// Records that [phone] used [code] today.
  Future<Either<Failure, void>> markCouponUsed({
    required String code,
    required String phone,
  });
}
