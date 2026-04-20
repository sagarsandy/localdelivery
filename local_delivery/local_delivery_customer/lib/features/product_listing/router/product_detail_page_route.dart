import 'package:go_router/go_router.dart';

import '../../../../app/router/ld_app_routes.dart';
import '../../../../app/router/ld_page_route.dart';
import '../domain/models/product_model.dart';
import '../presentation/pages/product_detail_page.dart';

class ProductDetailPageRoute implements LDPageRoute {
  @override
  GoRoute get route => GoRoute(
        name: LDAppRoute.productDetail.name,
        path: LDAppRoute.productDetail.path,
        pageBuilder: (context, state) {
          // The full ProductModel is passed via GoRouter extra so we avoid
          // a redundant Firestore fetch on the detail page.
          final product = state.extra as ProductModel;
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: ProductDetailPage(product: product),
          );
        },
      );
}
