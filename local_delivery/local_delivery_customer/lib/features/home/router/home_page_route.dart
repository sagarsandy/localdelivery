import 'package:go_router/go_router.dart';
import '../../../../../app/router/ld_app_routes.dart';
import '../../../../../app/router/ld_page_route.dart';
import '../presentation/pages/home_page.dart';

class HomePageRoute implements LDPageRoute {
  @override
  GoRoute get route => GoRoute(
        name: LDAppRoute.home.name,
        path: LDAppRoute.home.path,
        pageBuilder: (context, state) => buildPageWithNoTransition(
          state: state,
          child: const HomePage(),
        ),
      );
}
