import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  const VerifyOtpUseCase(this._repository);
  final AuthRepository _repository;

  Future<Either<Failure, void>> verify({
    required String phone,
    required String otp,
  }) =>
      _repository.verifyOtp(phone: phone, otp: otp);
}
