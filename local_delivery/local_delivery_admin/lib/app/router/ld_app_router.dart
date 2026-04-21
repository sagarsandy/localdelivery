import 'package:go_router/go_router.dart';
import '../../core/session/user_session.dart';
import 'ld_app_routes.dart';
import '../../features/auth/login/router/login_page_route.dart';
import '../../features/auth/otp/router/otp_page_route.dart';
import '../../features/dashboard/router/dashboard_page_route.dart';

class LDAppRouter {
  LDAppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: LDAppRoute.dashboard.path,
    redirect: _handleAuthRedirect,
    routes: [
      LoginPageRoute().route,
      OtpPageRoute().route,
      DashboardPageRoute().route,
    ],
  );

  static String? _handleAuthRedirect(_, GoRouterState state) {
    final isLoggedIn = UserSession.instance.isLoggedIn;
    final isAuthRoute = state.matchedLocation == LDAppRoute.login.path ||
        state.matchedLocation == LDAppRoute.otp.path;

    if (!isLoggedIn && !isAuthRoute) return LDAppRoute.login.path;
    if (isLoggedIn && isAuthRoute) return LDAppRoute.dashboard.path;
    return null;
  }
}
