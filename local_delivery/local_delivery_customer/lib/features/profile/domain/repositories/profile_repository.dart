import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../../../auth/domain/models/user_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserModel>> getProfile({required String userId});
  Future<Either<Failure, void>> updateProfile(UserModel user);
}
