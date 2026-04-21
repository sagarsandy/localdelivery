import 'package:get_it/get_it.dart';
import '../features/auth/data/sources/auth_remote_source.dart';
import '../features/auth/data/sources/firebase/firebase_auth_source.dart';
import '../features/categories/data/sources/category_remote_source.dart';
import '../features/categories/data/sources/firebase/firebase_category_source.dart';

Future<void> registerDataSources(GetIt locator) async {
  locator.registerLazySingleton<AuthRemoteSource>(() => FirebaseAuthSource());
  locator.registerLazySingleton<CategoryRemoteSource>(
      () => FirebaseCategorySource());
}
