import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../domain/models/coupon_model.dart';
import '../../domain/repositories/coupon_repository.dart';
import '../sources/coupon_remote_source.dart';

class CouponRepositoryImpl implements CouponRepository {
  const CouponRepositoryImpl(this._source);
  final CouponRemoteSource _source;

  @override
  Future<Either<Failure, CouponModel>> getCouponByCode(String code) async {
    try {
      final dto = await _source.fetchCouponByCode(code);
      if (dto == null) {
        return const Left(NotFoundFailure('Coupon not found.'));
      }
      return Right(dto.toDomain());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isCouponUsed({
    required String code,
    required String phone,
  }) async {
    try {
      final used = await _source.isCouponUsed(code: code, phone: phone);
      return Right(used);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markCouponUsed({
    required String code,
    required String phone,
  }) async {
    try {
      await _source.markCouponUsed(code: code, phone: phone);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
