import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../repositories/auth_repository.dart';

class SignInWithOtpUseCase {
  const SignInWithOtpUseCase(this._repository);
  final AuthRepository _repository;

  Future<Either<Failure, void>> sendOtp({required String phone}) =>
      _repository.signInWithOtp(phone: phone);
}
