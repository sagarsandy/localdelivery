enum LDAppRoute {
  login,
  otp,
  home,
}

extension LDAppRouteExt on LDAppRoute {
  String get path {
    switch (this) {
      case LDAppRoute.login: return '/login';
      case LDAppRoute.otp: return '/otp';
      case LDAppRoute.home: return '/home';
    }
  }
}
