import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/ld_app_routes.dart';
import '../../../core/session/user_session.dart';
import '../../address/cubit/address_cubit.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this._addressCubit) : super(SplashInitial());

  final AddressCubit _addressCubit;

  /// Runs the full app-launch initialization sequence:
  ///  1. Brief brand delay.
  ///  2. If user is not logged in  → navigate to login.
  ///  3. If logged in              → initialize addresses (auto-location if needed).
  ///  4. Navigate to home.
  Future<void> initialize() async {
    emit(SplashLoading());

    // Small brand splash delay.
    await Future.delayed(const Duration(milliseconds: 1200));

    final isLoggedIn = UserSession.instance.isLoggedIn;
    if (!isLoggedIn) {
      emit(SplashNavigate(LDAppRoute.login.path));
      return;
    }

    // Run address initialization (checks location permission if no address).
    await _addressCubit.initializeAddresses();

    emit(SplashNavigate(LDAppRoute.home.path));
  }
}
