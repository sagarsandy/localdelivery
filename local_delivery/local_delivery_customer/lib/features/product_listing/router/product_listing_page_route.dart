import 'package:go_router/go_router.dart';
import '../../../../app/router/ld_app_routes.dart';
import '../../../../app/router/ld_page_route.dart';
import '../presentation/pages/product_listing_page.dart';

class ProductListingPageRoute implements LDPageRoute {
  @override
  GoRoute get route => GoRoute(
        name: LDAppRoute.productListing.name,
        path: LDAppRoute.productListing.path,
        pageBuilder: (context, state) {
          final subcategoryId =
              state.pathParameters['subcategoryId'] ?? '';
          final subcategoryName =
              state.uri.queryParameters['name'] ?? '';
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: ProductListingPage(
              subcategoryId: subcategoryId,
              subcategoryName: subcategoryName,
            ),
          );
        },
      );
}
