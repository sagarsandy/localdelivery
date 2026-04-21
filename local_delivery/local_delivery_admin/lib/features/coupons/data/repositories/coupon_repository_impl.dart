import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../domain/models/coupon_model.dart';
import '../../domain/models/used_coupon_model.dart';
import '../../domain/repositories/coupon_repository.dart';
import '../sources/coupon_remote_source.dart';

class CouponRepositoryImpl implements CouponRepository {
  const CouponRepositoryImpl(this._source);
  final CouponRemoteSource _source;

  @override
  Future<Either<Failure, List<CouponModel>>> getCoupons() async {
    try {
      final dtos = await _source.fetchCoupons();
      return Right(dtos.map((d) => d.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addCoupon(CouponModel coupon) async {
    try {
      await _source.addCoupon(coupon);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCoupon(CouponModel coupon) async {
    try {
      await _source.updateCoupon(coupon);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCoupon({required String id}) async {
    try {
      await _source.deleteCoupon(id: id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UsedCouponModel>>> getUsedCoupons({
    required String couponCode,
  }) async {
    try {
      final dtos = await _source.fetchUsedCoupons(couponCode: couponCode);
      return Right(dtos.map((d) => d.toDomain()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
