/// Firestore collection name constants.
///
/// All data-source files that access Firestore must import this file
/// for collection names — never use string literals directly.
/// If the backend changes, only this file (and the Firebase source impls) need
/// to be updated.
class FirebaseCollections {
  FirebaseCollections._();

  static const String stores = 'stores';
  static const String products = 'products';
  static const String categories = 'categories';
  static const String subcategories = 'subcategories';
  static const String orders = 'orders';
  static const String orderItems = 'order_items';
  static const String addresses = 'address';
  static const String users = 'users';
  static const String reviews = 'reviews';
}
