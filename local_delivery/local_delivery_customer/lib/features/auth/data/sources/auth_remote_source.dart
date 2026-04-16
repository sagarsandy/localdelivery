import '../dto/user_dto.dart';

/// Abstract contract for authentication remote operations.
/// No Firebase imports — swap the implementation to change the backend.
abstract class AuthRemoteSource {
  /// Initiates phone OTP flow. Resolves when the code is sent (or auto-verified).
  Future<void> sendOtp({required String phone});

  /// Verifies the OTP entered by the user.
  Future<void> verifyOtp({required String otp});

  /// Fetches the stored name for [userId]. Returns null if no profile exists yet.
  Future<String?> getProfileName({required String userId});

  /// Creates or merges a user profile document with the given [name].
  Future<void> saveProfileName({required String userId, required String name});

  /// Fetches the full user profile document, or null if it doesn't exist.
  Future<UserDto?> fetchUserProfile({required String userId});

  /// Updates the user document with the provided fields (merge).
  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> data,
  });

  /// Signs the current user out.
  Future<void> signOut();
}
