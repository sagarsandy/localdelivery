import 'package:go_router/go_router.dart';
import 'package:local_delivery_customer/core/session/user_session.dart';
import 'ld_app_routes.dart';
import 'ld_page_route.dart';
import '../../features/auth/login/router/login_page_route.dart';
import '../../features/auth/otp/router/otp_page_route.dart';
import '../../features/home/router/home_page_route.dart';
import '../../features/store_detail/router/store_detail_page_route.dart';
import '../../features/product_detail/router/product_detail_page_route.dart';
import '../../features/cart/router/cart_page_route.dart';
import '../../features/checkout/router/checkout_page_route.dart';
import '../../features/orders/router/orders_page_route.dart';
import '../../features/order_detail/router/order_detail_page_route.dart';
import '../../features/profile/router/profile_page_route.dart';
import '../../features/address/router/address_page_route.dart';

class LDAppRouter {
  LDAppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: LDAppRoute.home.path,
    redirect: _handleAuthRedirect,
    routes: [
      LoginPageRoute().route,
      OtpPageRoute().route,
      HomePageRoute().route,
      StoreDetailPageRoute().route,
      ProductDetailPageRoute().route,
      CartPageRoute().route,
      CheckoutPageRoute().route,
      OrdersPageRoute().route,
      OrderDetailPageRoute().route,
      ProfilePageRoute().route,
      ...AddressPageRoute().routes,
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
