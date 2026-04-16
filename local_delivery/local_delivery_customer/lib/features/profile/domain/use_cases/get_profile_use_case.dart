import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../auth/domain/models/user_model.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase {
  const GetProfileUseCase(this._repository);
  final ProfileRepository _repository;

  Future<Either<Failure, UserModel>> getProfile({required String userId}) =>
      _repository.getProfile(userId: userId);
}
