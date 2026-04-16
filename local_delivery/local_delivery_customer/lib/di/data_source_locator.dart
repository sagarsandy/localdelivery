import 'package:get_it/get_it.dart';
import '../features/auth/data/sources/auth_remote_source.dart';
import '../features/auth/data/sources/firebase/firebase_auth_source.dart';
import '../features/home/data/sources/store_remote_source.dart';
import '../features/home/data/sources/firebase/firebase_store_source.dart';
import '../features/home/data/sources/category_remote_source.dart';
import '../features/home/data/sources/firebase/firebase_category_source.dart';
import '../features/store_detail/data/sources/store_detail_remote_source.dart';
import '../features/store_detail/data/sources/firebase/firebase_store_detail_source.dart';
import '../features/product_detail/data/sources/product_remote_source.dart';
import '../features/product_detail/data/sources/firebase/firebase_product_source.dart';
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
  locator.registerLazySingleton<StoreRemoteSource>(() => FirebaseStoreSource());
  locator.registerLazySingleton<CategoryRemoteSource>(() => FirebaseCategorySource());
  locator.registerLazySingleton<StoreDetailRemoteSource>(() => FirebaseStoreDetailSource());
  locator.registerLazySingleton<ProductRemoteSource>(() => FirebaseProductSource());
  locator.registerLazySingleton<OrdersRemoteSource>(() => FirebaseOrdersSource());
  locator.registerLazySingleton<OrderDetailRemoteSource>(() => FirebaseOrderDetailSource());
  locator.registerLazySingleton<ProfileRemoteSource>(() => FirebaseProfileSource());
  locator.registerLazySingleton<AddressRemoteSource>(() => FirebaseAddressSource());
  locator.registerLazySingleton<CheckoutRemoteSource>(() => FirebaseCheckoutSource());
}
