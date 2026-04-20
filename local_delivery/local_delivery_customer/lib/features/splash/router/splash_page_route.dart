import 'package:go_router/go_router.dart';

import '../../../app/router/ld_app_routes.dart';
import '../presentation/pages/splash_page.dart';

class SplashPageRoute {
  GoRoute get route => GoRoute(
        name: LDAppRoute.splash.name,
        path: LDAppRoute.splash.path,
        builder: (context, state) => const SplashPage(),
      );
}
