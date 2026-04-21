import 'package:get_it/get_it.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/data/sources/auth_remote_source.dart';
import '../features/auth/domain/repositories/auth_repository.dart';

Future<void> registerRepositories(GetIt locator) async {
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(locator<AuthRemoteSource>()),
  );
}
