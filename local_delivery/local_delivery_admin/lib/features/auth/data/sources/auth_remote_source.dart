import '../dto/user_dto.dart';

abstract class AuthRemoteSource {
  Future<void> sendOtp({required String phone});
  Future<void> verifyOtp({required String otp});
  Future<String?> getProfileName({required String userId});
  Future<void> saveProfileName({required String userId, required String name});
  Future<UserDto?> fetchUserProfile({required String userId});
  Future<void> updateUserProfile({
    required String userId,
    required Map<String, dynamic> data,
  });
  Future<void> signOut();
}
