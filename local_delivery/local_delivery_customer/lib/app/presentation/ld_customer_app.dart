import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';
import '../router/ld_app_router.dart';

class LDCustomerApp extends StatelessWidget {
  const LDCustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Local Delivery',
      debugShowCheckedModeBanner: false,
      theme: LDTheme.light,
      routerConfig: LDAppRouter.router,
    );
  }
}
