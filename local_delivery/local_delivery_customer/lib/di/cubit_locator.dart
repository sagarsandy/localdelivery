import 'package:get_it/get_it.dart';
import '../features/auth/login/cubit/login_cubit.dart';
import '../features/auth/otp/cubit/otp_cubit.dart';
import '../features/home/cubit/home_cubit.dart';
import '../features/cart/cubit/cart_cubit.dart';
import '../features/checkout/cubit/checkout_cubit.dart';
import '../features/checkout/domain/repositories/checkout_repository.dart';
import '../features/orders/cubit/orders_cubit.dart';
import '../features/order_detail/cubit/order_detail_cubit.dart';
import '../features/profile/cubit/profile_cubit.dart';
import '../features/address/cubit/address_cubit.dart';
import '../features/product_listing/cubit/product_listing_cubit.dart';
import '../features/splash/cubit/splash_cubit.dart';

Future<void> registerCubits(GetIt locator) async {
  // ── Singletons — shared state across the app ──────────────────────────────

  // Cart: one instance across all pages
  locator.registerLazySingleton(() => CartCubit(locator(), locator()));

  // Address: singleton so active address is visible on home, cart, and checkout
  locator.registerLazySingleton(() => AddressCubit(
        locator(), // GetAddressesUseCase
        locator(), // SaveAddressUseCase
        locator(), // DeleteAddressUseCase
        locator(), // SetActiveAddressUseCase
        locator(), // LocationService
      ));

  // ── Factories — fresh instance per page ───────────────────────────────────
  locator.registerFactory(() => LoginCubit(locator()));
  locator.registerFactory(() => OtpCubit(locator(), locator(), locator()));
  locator.registerFactory(() => HomeCubit(locator(), locator(), locator()));
  locator.registerFactory(() => CheckoutCubit(locator<CheckoutRepository>()));
  locator.registerFactory(() => OrdersCubit(locator()));
  locator.registerFactory(() => OrderDetailCubit(locator()));
  locator.registerFactory(() => ProfileCubit(locator()));
  locator.registerFactory(() => ProductListingCubit(locator()));

  // Splash: factory is fine — used once per launch
  locator.registerFactory(
    () => SplashCubit(locator<AddressCubit>()),
  );
}
