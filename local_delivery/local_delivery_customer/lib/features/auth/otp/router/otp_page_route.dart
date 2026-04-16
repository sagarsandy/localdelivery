import 'package:go_router/go_router.dart';
import '../../../../../app/router/ld_app_routes.dart';
import '../../../../../app/router/ld_page_route.dart';
import '../presentation/pages/otp_page.dart';

class OtpPageRoute implements LDPageRoute {
  @override
  GoRoute get route => GoRoute(
        name: LDAppRoute.otp.name,
        path: LDAppRoute.otp.path,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: OtpPage(phone: extra['phone'] as String? ?? ''),
          );
        },
      );
}
