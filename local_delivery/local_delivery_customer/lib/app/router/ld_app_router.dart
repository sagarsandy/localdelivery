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
import '../../features/product_listing/router/product_detail_page_route.dart';
import '../../features/product_listing/router/product_listing_page_route.dart';
import '../../features/profile/presentation/pages/about_us_page.dart';
import '../../features/profile/presentation/pages/refer_earn_page.dart';
import '../../features/profile/presentation/pages/support_page.dart';
import '../../features/profile/router/profile_page_route.dart';
import '../../features/splash/router/splash_page_route.dart';
import '../widgets/app_shell_widget.dart';
import 'ld_app_routes.dart';
import 'ld_page_route.dart';

class LDAppRouter {
  LDAppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: LDAppRoute.splash.path,
    redirect: _handleAuthRedirect,
    routes: [
      // ── Splash (entry point — handles auth + location init)
      SplashPageRoute().route,

      // ── Auth
      LoginPageRoute().route,
      OtpPageRoute().route,

      // ── Full-screen pages — pushed on top of the shell, no tab bar
      ProductListingPageRoute().route,
      ProductDetailPageRoute().route,
      CheckoutPageRoute().route,
      GoRoute(
        name: LDAppRoute.referEarn.name,
        path: LDAppRoute.referEarn.path,
        pageBuilder: (context, state) => buildPageWithSlideTransition(
          context: context,
          state: state,
          child: const ReferEarnPage(),
        ),
      ),
      GoRoute(
        name: LDAppRoute.support.name,
        path: LDAppRoute.support.path,
        pageBuilder: (context, state) => buildPageWithSlideTransition(
          context: context,
          state: state,
          child: const SupportPage(),
        ),
      ),
      GoRoute(
        name: LDAppRoute.aboutUs.name,
        path: LDAppRoute.aboutUs.path,
        pageBuilder: (context, state) => buildPageWithSlideTransition(
          context: context,
          state: state,
          child: const AboutUsPage(),
        ),
      ),

      // ── Tabs shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShellWidget(shell: navigationShell),
        branches: [
          // Tab 0: Home
          StatefulShellBranch(
            routes: [
              HomePageRoute().route,
            ],
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
