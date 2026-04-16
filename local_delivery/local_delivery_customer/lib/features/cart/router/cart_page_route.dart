import 'package:go_router/go_router.dart';
import '../../../../app/router/ld_app_routes.dart';
import '../../../../app/router/ld_page_route.dart';
import '../presentation/pages/cart_page.dart';

class CartPageRoute implements LDPageRoute {
  @override
  GoRoute get route => GoRoute(
        name: LDAppRoute.cart.name,
        path: LDAppRoute.cart.path,
        pageBuilder: (context, state) => buildPageWithSlideTransition(
          context: context,
          state: state,
          child: const CartPage(),
        ),
      );
}
