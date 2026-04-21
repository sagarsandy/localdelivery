import 'package:go_router/go_router.dart';
import '../../../app/router/ld_app_routes.dart';
import '../../../app/router/ld_page_route.dart';
import '../presentation/pages/dashboard_page.dart';

class DashboardPageRoute implements LDPageRoute {
  @override
  GoRoute get route => GoRoute(
        name: LDAppRoute.dashboard.name,
        path: LDAppRoute.dashboard.path,
        pageBuilder: (context, state) => buildPageWithNoTransition(
          state: state,
          child: const DashboardPage(),
        ),
      );
}
