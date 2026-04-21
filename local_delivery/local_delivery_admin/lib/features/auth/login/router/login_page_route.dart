import 'package:go_router/go_router.dart';
import '../../../../../app/router/ld_app_routes.dart';
import '../../../../../app/router/ld_page_route.dart';
import '../presentation/pages/login_page.dart';

class LoginPageRoute implements LDPageRoute {
  @override
  GoRoute get route => GoRoute(
        name: LDAppRoute.login.name,
        path: LDAppRoute.login.path,
        pageBuilder: (context, state) => buildPageWithNoTransition(
          state: state,
          child: const LoginPage(),
        ),
      );
}
