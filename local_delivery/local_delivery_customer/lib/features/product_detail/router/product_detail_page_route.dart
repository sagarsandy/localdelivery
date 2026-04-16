import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/ld_app_routes.dart';
import '../../../../app/router/ld_page_route.dart';
import '../presentation/pages/product_detail_page.dart';

class ProductDetailPageRoute implements LDPageRoute {
  @override
  GoRoute get route => GoRoute(
        name: LDAppRoute.productDetail.name,
        path: LDAppRoute.productDetail.path,
        pageBuilder: (context, state) {
          final productId = state.pathParameters['productId']!;
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: ProductDetailPage(productId: productId),
          );
        },
      );
}
