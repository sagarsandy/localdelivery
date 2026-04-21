import 'package:get_it/get_it.dart';
import '../features/auth/login/cubit/login_cubit.dart';
import '../features/auth/otp/cubit/otp_cubit.dart';

Future<void> registerCubits(GetIt locator) async {
  locator.registerFactory(() => LoginCubit(locator()));
  locator.registerFactory(() => OtpCubit(locator(), locator(), locator()));
}
