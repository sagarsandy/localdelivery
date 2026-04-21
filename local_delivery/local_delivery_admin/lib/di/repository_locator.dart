import 'package:get_it/get_it.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/data/sources/auth_remote_source.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/categories/data/repositories/category_repository_impl.dart';
import '../features/categories/data/sources/category_remote_source.dart';
import '../features/categories/domain/repositories/category_repository.dart';
import '../features/subcategories/data/repositories/subcategory_repository_impl.dart';
import '../features/subcategories/data/sources/subcategory_remote_source.dart';
import '../features/subcategories/domain/repositories/subcategory_repository.dart';
import '../features/products/data/repositories/product_repository_impl.dart';
import '../features/products/data/sources/product_remote_source.dart';
import '../features/products/domain/repositories/product_repository.dart';

Future<void> registerRepositories(GetIt locator) async {
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(locator<AuthRemoteSource>()),
  );
  locator.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(locator<CategoryRemoteSource>()),
  );
  locator.registerLazySingleton<SubcategoryRepository>(
    () => SubcategoryRepositoryImpl(locator<SubcategoryRemoteSource>()),
  );
  locator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(locator<ProductRemoteSource>()),
  );
}
