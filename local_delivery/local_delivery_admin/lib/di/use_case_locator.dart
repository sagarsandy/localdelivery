import 'package:get_it/get_it.dart';
import '../features/auth/domain/use_cases/sign_in_with_otp_use_case.dart';
import '../features/auth/domain/use_cases/verify_otp_use_case.dart';

Future<void> registerUseCases(GetIt locator) async {
  locator.registerLazySingleton(() => SignInWithOtpUseCase(locator()));
  locator.registerLazySingleton(() => VerifyOtpUseCase(locator()));
}
