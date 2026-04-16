import 'package:get_it/get_it.dart';
import '../features/auth/data/sources/auth_remote_source.dart';
import '../features/auth/data/sources/firebase/firebase_auth_source.dart';
import '../features/home/data/sources/category_remote_source.dart';
import '../features/home/data/sources/firebase/firebase_category_source.dart';
import '../features/home/data/sources/subcategory_remote_source.dart';
import '../features/home/data/sources/firebase/firebase_subcategory_source.dart';
import '../features/home/data/sources/trending_product_remote_source.dart';
import '../features/home/data/sources/firebase/firebase_trending_product_source.dart';
import '../features/orders/data/sources/orders_remote_source.dart';
import '../features/orders/data/sources/firebase/firebase_orders_source.dart';
import '../features/order_detail/data/sources/order_detail_remote_source.dart';
import '../features/order_detail/data/sources/firebase/firebase_order_detail_source.dart';
import '../features/profile/data/sources/profile_remote_source.dart';
import '../features/profile/data/sources/firebase/firebase_profile_source.dart';
import '../features/address/data/sources/address_remote_source.dart';
import '../features/address/data/sources/firebase/firebase_address_source.dart';
import '../features/checkout/data/sources/checkout_remote_source.dart';
import '../features/checkout/data/sources/firebase/firebase_checkout_source.dart';

Future<void> registerDataSources(GetIt locator) async {
  locator.registerLazySingleton<AuthRemoteSource>(() => FirebaseAuthSource());
  locator.registerLazySingleton<CategoryRemoteSource>(() => FirebaseCategorySource());
  locator.registerLazySingleton<SubcategoryRemoteSource>(() => FirebaseSubcategorySource());
  locator.registerLazySingleton<TrendingProductRemoteSource>(() => FirebaseTrendingProductSource());
  locator.registerLazySingleton<OrdersRemoteSource>(() => FirebaseOrdersSource());
  locator.registerLazySingleton<OrderDetailRemoteSource>(() => FirebaseOrderDetailSource());
  locator.registerLazySingleton<ProfileRemoteSource>(() => FirebaseProfileSource());
  locator.registerLazySingleton<AddressRemoteSource>(() => FirebaseAddressSource());
  locator.registerLazySingleton<CheckoutRemoteSource>(() => FirebaseCheckoutSource());
}
