import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> signInWithOtp({required String phone});
  Future<Either<Failure, void>> verifyOtp({
    required String phone,
    required String otp,
  });
  /// Persists a display name for the authenticated user.
  /// Non-critical — failures are soft (user can update name in profile later).
  Future<Either<Failure, void>> saveUserProfile({
    required String userId,
    required String name,
  });

  /// Returns the stored name for [userId], or null if no profile exists yet.
  Future<Either<Failure, String?>> getExistingUserName({required String userId});

  Future<void> signOut();
}
