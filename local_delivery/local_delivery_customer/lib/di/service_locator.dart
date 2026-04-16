import 'package:get_it/get_it.dart';
import 'data_source_locator.dart';
import 'repository_locator.dart';
import 'use_case_locator.dart';
import 'cubit_locator.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  await registerDataSources(locator);
  await registerRepositories(locator);
  await registerUseCases(locator);
  await registerCubits(locator);
}
