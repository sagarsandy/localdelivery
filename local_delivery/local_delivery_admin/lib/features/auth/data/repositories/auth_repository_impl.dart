import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../sources/auth_remote_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._source);
  final AuthRemoteSource _source;

  @override
  Future<Either<Failure, void>> signInWithOtp({required String phone}) async {
    try {
      await _source.sendOtp(phone: phone);
      return const Right(null);
    } on Exception catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      await _source.verifyOtp(otp: otp);
      return const Right(null);
    } on Exception catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveUserProfile({
    required String userId,
    required String name,
  }) async {
    try {
      await _source.saveProfileName(userId: userId, name: name);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getExistingUserName({
    required String userId,
  }) async {
    try {
      final name = await _source.getProfileName(userId: userId);
      return Right(name);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> signOut() => _source.signOut();
}
