import 'package:go_router/go_router.dart';
import '../../../../app/router/ld_app_routes.dart';
import '../../../../app/router/ld_page_route.dart';
import '../presentation/pages/profile_page.dart';

class ProfilePageRoute implements LDPageRoute {
  @override
  GoRoute get route => GoRoute(
        name: LDAppRoute.profile.name,
        path: LDAppRoute.profile.path,
        pageBuilder: (context, state) => buildPageWithSlideTransition(
          context: context,
          state: state,
          child: const ProfilePage(),
        ),
      );
}
