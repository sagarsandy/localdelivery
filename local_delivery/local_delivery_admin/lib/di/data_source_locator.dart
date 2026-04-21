import 'package:get_it/get_it.dart';
import '../features/auth/data/sources/auth_remote_source.dart';
import '../features/auth/data/sources/firebase/firebase_auth_source.dart';
import '../features/categories/data/sources/category_remote_source.dart';
import '../features/categories/data/sources/firebase/firebase_category_source.dart';
import '../features/subcategories/data/sources/subcategory_remote_source.dart';
import '../features/subcategories/data/sources/firebase/firebase_subcategory_source.dart';
import '../features/products/data/sources/product_remote_source.dart';
import '../features/products/data/sources/firebase/firebase_product_source.dart';

Future<void> registerDataSources(GetIt locator) async {
  locator.registerLazySingleton<AuthRemoteSource>(() => FirebaseAuthSource());
  locator.registerLazySingleton<CategoryRemoteSource>(
      () => FirebaseCategorySource());
  locator.registerLazySingleton<SubcategoryRemoteSource>(
      () => FirebaseSubcategorySource());
  locator.registerLazySingleton<ProductRemoteSource>(
      () => FirebaseProductSource());
}
