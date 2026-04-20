import 'package:get_it/get_it.dart';
import '../features/auth/domain/use_cases/sign_in_with_otp_use_case.dart';
import '../features/auth/domain/use_cases/verify_otp_use_case.dart';
import '../features/home/domain/use_cases/get_categories_use_case.dart';
import '../features/home/domain/use_cases/get_fresh_subcategories_use_case.dart';
import '../features/home/domain/use_cases/get_trending_products_use_case.dart';
import '../features/cart/domain/use_cases/get_cart_use_case.dart';
import '../features/cart/domain/use_cases/update_cart_use_case.dart';
import '../features/orders/domain/use_cases/get_orders_use_case.dart';
import '../features/order_detail/domain/use_cases/get_order_detail_use_case.dart';
import '../features/profile/domain/use_cases/get_profile_use_case.dart';
import '../features/address/domain/use_cases/get_addresses_use_case.dart';
import '../features/address/domain/use_cases/save_address_use_case.dart';
import '../features/address/domain/use_cases/delete_address_use_case.dart';
import '../features/address/domain/use_cases/set_active_address_use_case.dart';
import '../features/product_listing/domain/use_cases/get_products_use_case.dart';
import '../features/coupon/domain/use_cases/validate_coupon_use_case.dart';
import '../features/coupon/domain/use_cases/mark_coupon_used_use_case.dart';

Future<void> registerUseCases(GetIt locator) async {
  // Auth
  locator.registerLazySingleton(() => SignInWithOtpUseCase(locator()));
  locator.registerLazySingleton(() => VerifyOtpUseCase(locator()));

  // Home
  locator.registerLazySingleton(() => GetCategoriesUseCase(locator()));
  locator.registerLazySingleton(() => GetSubcategoriesUseCase(locator()));
  locator.registerLazySingleton(() => GetTrendingProductsUseCase(locator()));

  // Cart
  locator.registerLazySingleton(() => GetCartUseCase(locator()));
  locator.registerLazySingleton(() => UpdateCartUseCase(locator()));

  // Orders
  locator.registerLazySingleton(() => GetOrdersUseCase(locator()));
  locator.registerLazySingleton(() => GetOrderDetailUseCase(locator()));

  // Profile
  locator.registerLazySingleton(() => GetProfileUseCase(locator()));

  // Address
  locator.registerLazySingleton(() => GetAddressesUseCase(locator()));
  locator.registerLazySingleton(() => SaveAddressUseCase(locator()));
  locator.registerLazySingleton(() => DeleteAddressUseCase(locator()));
  locator.registerLazySingleton(() => SetActiveAddressUseCase(locator()));

  // Product listing
  locator.registerLazySingleton(() => GetProductsUseCase(locator()));

  // Coupon
  locator.registerLazySingleton(() => ValidateCouponUseCase(locator()));
  locator.registerLazySingleton(() => MarkCouponUsedUseCase(locator()));
}
