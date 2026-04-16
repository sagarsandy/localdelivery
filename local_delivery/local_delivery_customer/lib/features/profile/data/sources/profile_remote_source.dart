import '../../../auth/data/dto/user_dto.dart';

abstract class ProfileRemoteSource {
  Future<UserDto> fetchProfile({required String userId});
  Future<void> updateProfile({
    required String userId,
    required Map<String, dynamic> data,
  });
}
