import 'package:get_it/get_it.dart';
import '../features/auth/domain/use_cases/sign_in_with_otp_use_case.dart';
import '../features/auth/domain/use_cases/verify_otp_use_case.dart';
import '../features/categories/domain/use_cases/add_category_use_case.dart';
import '../features/categories/domain/use_cases/delete_category_use_case.dart';
import '../features/categories/domain/use_cases/get_categories_use_case.dart';
import '../features/categories/domain/use_cases/update_category_use_case.dart';

Future<void> registerUseCases(GetIt locator) async {
  // Auth
  locator.registerLazySingleton(() => SignInWithOtpUseCase(locator()));
  locator.registerLazySingleton(() => VerifyOtpUseCase(locator()));

  // Categories
  locator.registerLazySingleton(() => GetCategoriesUseCase(locator()));
  locator.registerLazySingleton(() => AddCategoryUseCase(locator()));
  locator.registerLazySingleton(() => UpdateCategoryUseCase(locator()));
  locator.registerLazySingleton(() => DeleteCategoryUseCase(locator()));
}
