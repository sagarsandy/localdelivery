import 'package:go_router/go_router.dart';
import 'package:local_delivery_customer/core/session/user_session.dart';

import '../../features/address/router/address_page_route.dart';
import '../../features/auth/login/router/login_page_route.dart';
import '../../features/auth/otp/router/otp_page_route.dart';
import '../../features/cart/router/cart_page_route.dart';
import '../../features/checkout/router/checkout_page_route.dart';
import '../../features/home/router/home_page_route.dart';
import '../../features/order_detail/router/order_detail_page_route.dart';
import '../../features/orders/router/orders_page_route.dart';
import '../../features/profile/router/profile_page_route.dart';
import '../widgets/app_shell_widget.dart';
import 'ld_app_routes.dart';

class LDAppRouter {
  LDAppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: LDAppRoute.home.path,
    // redirect: _handleAuthRedirect,
    routes: [
      LoginPageRoute().route,
      OtpPageRoute().route,
      // Tabs shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShellWidget(shell: navigationShell),
        branches: [
          // Tab 0: Home
          StatefulShellBranch(
            routes: [HomePageRoute().route],
          ),
          // Tab 1: Orders
          StatefulShellBranch(
            routes: [
              OrdersPageRoute().route,
              OrderDetailPageRoute().route,
            ],
          ),
          // Tab 2: Cart
          StatefulShellBranch(
            routes: [
              CartPageRoute().route,
              CheckoutPageRoute().route,
            ],
          ),
          // Tab 3: More (Profile + Addresses)
          StatefulShellBranch(
            routes: [
              ProfilePageRoute().route,
              ...AddressPageRoute().routes,
            ],
          ),
        ],
      ),
    ],
  );

  static String? _handleAuthRedirect(_, GoRouterState state) {
    final isLoggedIn = UserSession.instance.isLoggedIn;
    final isAuthRoute = state.matchedLocation == LDAppRoute.login.path ||
        state.matchedLocation == LDAppRoute.otp.path;

    if (!isLoggedIn && !isAuthRoute) return LDAppRoute.login.path;
    if (isLoggedIn && isAuthRoute) return LDAppRoute.home.path;
    return null;
  }
}
