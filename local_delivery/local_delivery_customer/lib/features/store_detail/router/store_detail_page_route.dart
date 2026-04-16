import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/ld_app_routes.dart';
import '../../../../app/router/ld_page_route.dart';
import '../presentation/pages/store_detail_page.dart';

class StoreDetailPageRoute implements LDPageRoute {
  @override
  GoRoute get route => GoRoute(
        name: LDAppRoute.storeDetail.name,
        path: LDAppRoute.storeDetail.path,
        pageBuilder: (context, state) {
          final storeId = state.pathParameters['storeId']!;
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: StoreDetailPage(storeId: storeId),
          );
        },
      );
}
