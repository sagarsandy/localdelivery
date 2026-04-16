import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/user_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/sign_in_with_otp_use_case.dart';
import '../../domain/use_cases/verify_otp_use_case.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit(this._verifyOtp, this._signInWithOtp, this._authRepository)
      : super(OtpInitial());

  final VerifyOtpUseCase _verifyOtp;
  final SignInWithOtpUseCase _signInWithOtp;
  final AuthRepository _authRepository;

  Future<void> verifyOtp({required String phone, required String otp}) async {
    emit(OtpLoading());
    final result = await _verifyOtp.verify(phone: phone, otp: otp);
    result.fold(
      (failure) => emit(OtpError(failure.message)),
      (_) async {
        final userId = UserSession.instance.userId;
        if (userId == null) {
          emit(OtpVerifiedNeedName());
          return;
        }
        final nameResult =
            await _authRepository.getExistingUserName(userId: userId);
        nameResult.fold(
          (_) => emit(OtpVerifiedNeedName()),
          (name) => name != null ? emit(OtpVerified()) : emit(OtpVerifiedNeedName()),
        );
      },
    );
  }

  Future<void> saveName({required String name}) async {
    final userId = UserSession.instance.userId;
    if (userId == null) {
      emit(OtpVerified());
      return;
    }
    emit(OtpSavingName());
    await _authRepository.saveUserProfile(userId: userId, name: name.trim());
    emit(OtpVerified());
  }

  Future<void> resendOtp({required String phone}) async {
    emit(OtpResending());
    final result = await _signInWithOtp.sendOtp(phone: phone);
    result.fold(
      (failure) => emit(OtpError(failure.message)),
      (_) => emit(OtpResent()),
    );
  }
}
