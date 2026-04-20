/// App-wide constants for Local Delivery Customer app.
class LDConstants {
  LDConstants._();

  // App Info
  static const String appName = 'Local Delivery';
  static const String appVersion = '1.0.0';

  // Firestore collection names
  static const String collectionProducts = 'products';
  static const String collectionCategories = 'categories';
  static const String collectionSubcategories = 'subcategories';
  static const String collectionOrders = 'orders';
  static const String collectionOrderItems = 'order_items';
  static const String collectionAddresses = 'addresses';
  static const String collectionUsers = 'users';
  static const String collectionReviews = 'reviews';

  // Storage bucket names (Firebase Storage)
  static const String bucketProductImages = 'product-images';
  static const String bucketUserAvatars = 'user-avatars';

  // Pagination
  static const int pageSize = 20;

  // Local storage keys
  static const String keyUserId = 'user_id';
  static const String keySelectedAddressId = 'selected_address_id';

  // Order charges — change these values to update fees across the app
  static const double deliveryCharge = 10.0;
  static const double platformFee = 10.0;

  // Misc
  static const double freeDeliveryThreshold = 299.0;
}
