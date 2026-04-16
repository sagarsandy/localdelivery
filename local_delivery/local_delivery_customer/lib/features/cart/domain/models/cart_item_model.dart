import 'package:equatable/equatable.dart';

class CartItemModel extends Equatable {
  const CartItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.storeId,
    required this.storeName,
    required this.price,
    required this.quantity,
  });

  final String productId;
  final String productName;
  final String productImage;
  final String storeId;
  final String storeName;
  final double price;
  final int quantity;

  double get totalPrice => price * quantity;

  CartItemModel copyWith({
    String? productId,
    String? productName,
    String? productImage,
    String? storeId,
    String? storeName,
    double? price,
    int? quantity,
  }) =>
      CartItemModel(
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        productImage: productImage ?? this.productImage,
        storeId: storeId ?? this.storeId,
        storeName: storeName ?? this.storeName,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
      );

  factory CartItemModel.fromMap(Map<String, dynamic> map) => CartItemModel(
        productId: map['product_id'] as String,
        productName: map['product_name'] as String,
        productImage: map['product_image'] as String? ?? '',
        storeId: map['store_id'] as String,
        storeName: map['store_name'] as String? ?? '',
        price: (map['price'] as num).toDouble(),
        quantity: map['quantity'] as int,
      );

  Map<String, dynamic> toMap() => {
        'product_id': productId,
        'product_name': productName,
        'product_image': productImage,
        'store_id': storeId,
        'store_name': storeName,
        'price': price,
        'quantity': quantity,
      };

  @override
  List<Object?> get props => [productId, quantity];
}
