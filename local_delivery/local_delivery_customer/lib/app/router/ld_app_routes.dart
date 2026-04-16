/// Named route constants for the customer app.
enum LDAppRoute {
  splash,
  login,
  otp,
  home,
  storeDetail,
  productDetail,
  cart,
  checkout,
  orders,
  orderDetail,
  profile,
  addresses,
  addAddress,
}

extension LDAppRouteExt on LDAppRoute {
  String get path {
    switch (this) {
      case LDAppRoute.splash: return '/';
      case LDAppRoute.login: return '/login';
      case LDAppRoute.otp: return '/otp';
      case LDAppRoute.home: return '/home';
      case LDAppRoute.storeDetail: return '/store/:storeId';
      case LDAppRoute.productDetail: return '/product/:productId';
      case LDAppRoute.cart: return '/cart';
      case LDAppRoute.checkout: return '/checkout';
      case LDAppRoute.orders: return '/orders';
      case LDAppRoute.orderDetail: return '/order/:orderId';
      case LDAppRoute.profile: return '/profile';
      case LDAppRoute.addresses: return '/addresses';
      case LDAppRoute.addAddress: return '/addresses/add';
    }
  }
}
