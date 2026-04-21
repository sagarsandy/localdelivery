import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/sign_in_with_otp_use_case.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._signInWithOtpUseCase) : super(LoginInitial());

  final SignInWithOtpUseCase _signInWithOtpUseCase;

  Future<void> sendOtp({required String phone}) async {
    emit(LoginLoading());
    final result = await _signInWithOtpUseCase.sendOtp(phone: phone);
    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (_) => emit(LoginOtpSent()),
    );
  }
}
