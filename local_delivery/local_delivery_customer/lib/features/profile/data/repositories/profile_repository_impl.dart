import 'package:dartz/dartz.dart';

import '../../../../core/utils/failure.dart';
import '../../../auth/domain/models/user_model.dart';
import '../../domain/repositories/profile_repository.dart';
import '../sources/profile_remote_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._source);
  final ProfileRemoteSource _source;

  @override
  Future<Either<Failure, UserModel>> getProfile({
    required String userId,
  }) async {
    try {
      final dto = await _source.fetchProfile(userId: userId);
      return Right(dto.toDomain());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(UserModel user) async {
    try {
      await _source.updateProfile(
        userId: user.id,
        data: {
          'name': user.name,
          'email': user.email,
          'avatar_url': user.avatarUrl,
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
