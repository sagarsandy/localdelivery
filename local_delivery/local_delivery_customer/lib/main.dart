import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/presentation/ld_customer_app.dart';
import 'di/service_locator.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Setup dependency injection
  await setupLocator();

  runApp(const LDCustomerApp());
}
