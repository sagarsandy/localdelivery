import 'package:get_it/get_it.dart';
import '../features/auth/domain/use_cases/sign_in_with_otp_use_case.dart';
import '../features/auth/domain/use_cases/verify_otp_use_case.dart';
import '../features/categories/domain/use_cases/add_category_use_case.dart';
import '../features/categories/domain/use_cases/delete_category_use_case.dart';
import '../features/categories/domain/use_cases/get_categories_use_case.dart';
import '../features/categories/domain/use_cases/update_category_use_case.dart';
import '../features/subcategories/domain/use_cases/add_subcategory_use_case.dart';
import '../features/subcategories/domain/use_cases/delete_subcategory_use_case.dart';
import '../features/subcategories/domain/use_cases/get_subcategories_use_case.dart';
import '../features/subcategories/domain/use_cases/update_subcategory_use_case.dart';
import '../features/products/domain/use_cases/get_products_use_case.dart';
import '../features/products/domain/use_cases/add_product_use_case.dart';
import '../features/products/domain/use_cases/update_product_use_case.dart';
import '../features/products/domain/use_cases/delete_product_use_case.dart';
import '../features/coupons/domain/use_cases/get_coupons_use_case.dart';
import '../features/coupons/domain/use_cases/add_coupon_use_case.dart';
import '../features/coupons/domain/use_cases/update_coupon_use_case.dart';
import '../features/coupons/domain/use_cases/delete_coupon_use_case.dart';
import '../features/coupons/domain/use_cases/get_used_coupons_use_case.dart';

Future<void> registerUseCases(GetIt locator) async {
  // Auth
  locator.registerLazySingleton(() => SignInWithOtpUseCase(locator()));
  locator.registerLazySingleton(() => VerifyOtpUseCase(locator()));

  // Categories
  locator.registerLazySingleton(() => GetCategoriesUseCase(locator()));
  locator.registerLazySingleton(() => AddCategoryUseCase(locator()));
  locator.registerLazySingleton(() => UpdateCategoryUseCase(locator()));
  locator.registerLazySingleton(() => DeleteCategoryUseCase(locator()));

  // Subcategories
  locator.registerLazySingleton(() => GetSubcategoriesUseCase(locator()));
  locator.registerLazySingleton(() => AddSubcategoryUseCase(locator()));
  locator.registerLazySingleton(() => UpdateSubcategoryUseCase(locator()));
  locator.registerLazySingleton(() => DeleteSubcategoryUseCase(locator()));

  // Products
  locator.registerLazySingleton(() => GetProductsUseCase(locator()));
  locator.registerLazySingleton(() => AddProductUseCase(locator()));
  locator.registerLazySingleton(() => UpdateProductUseCase(locator()));
  locator.registerLazySingleton(() => DeleteProductUseCase(locator()));

  // Coupons
  locator.registerLazySingleton(() => GetCouponsUseCase(locator()));
  locator.registerLazySingleton(() => AddCouponUseCase(locator()));
  locator.registerLazySingleton(() => UpdateCouponUseCase(locator()));
  locator.registerLazySingleton(() => DeleteCouponUseCase(locator()));
  locator.registerLazySingleton(() => GetUsedCouponsUseCase(locator()));
}
