import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/ld_app_routes.dart';
import '../../../../app/router/ld_page_route.dart';
import '../presentation/pages/order_detail_page.dart';

class OrderDetailPageRoute implements LDPageRoute {
  @override
  GoRoute get route => GoRoute(
        name: LDAppRoute.orderDetail.name,
        path: LDAppRoute.orderDetail.path,
        pageBuilder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: OrderDetailPage(orderId: orderId),
          );
        },
      );
}
