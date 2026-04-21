import 'package:get_it/get_it.dart';
import '../features/auth/data/sources/auth_remote_source.dart';
import '../features/auth/data/sources/firebase/firebase_auth_source.dart';

Future<void> registerDataSources(GetIt locator) async {
  locator.registerLazySingleton<AuthRemoteSource>(() => FirebaseAuthSource());
}
