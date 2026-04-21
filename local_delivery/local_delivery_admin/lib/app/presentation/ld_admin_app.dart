import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';
import '../router/ld_app_router.dart';

class LDAdminApp extends StatelessWidget {
  const LDAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Local Market Admin',
      debugShowCheckedModeBanner: false,
      theme: LDTheme.light,
      routerConfig: LDAppRouter.router,
    );
  }
}
