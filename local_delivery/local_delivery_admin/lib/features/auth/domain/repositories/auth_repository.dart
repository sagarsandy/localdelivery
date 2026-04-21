import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> signInWithOtp({required String phone});
  Future<Either<Failure, void>> verifyOtp({
    required String phone,
    required String otp,
  });
  Future<Either<Failure, void>> saveUserProfile({
    required String userId,
    required String name,
  });
  Future<Either<Failure, String?>> getExistingUserName({required String userId});
  Future<void> signOut();
}
