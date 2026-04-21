import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/presentation/ld_admin_app.dart';
import 'di/service_locator.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setupLocator();

  runApp(const LDAdminApp());
}
