import 'package:equatable/equatable.dart';
import '../../../orders/domain/models/order_model.dart';

class OrderItemModel extends Equatable {
  const OrderItemModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  final String productId;
  final String name;
  final double price;
  final int quantity;

  double get totalPrice => price * quantity;

  factory OrderItemModel.fromMap(Map<String, dynamic> map) => OrderItemModel(
        productId: map['product_id'] as String,
        name: map['name'] as String,
        price: (map['price'] as num).toDouble(),
        quantity: map['quantity'] as int,
      );

  Map<String, dynamic> toMap() => {
        'product_id': productId,
        'name': name,
        'price': price,
        'quantity': quantity,
      };

  @override
  List<Object?> get props => [productId, quantity];
}

class OrderDetailModel extends OrderModel {
  const OrderDetailModel({
    required super.id,
    required super.userId,
    required super.storeId,
    required super.storeName,
    required super.status,
    required super.totalAmount,
    required super.deliveryFee,
    required super.createdAt,
    required super.itemCount,
    required this.items,
    required this.address,
    required this.paymentMethod,
  });

  final List<OrderItemModel> items;
  final String address;
  final String paymentMethod;

  factory OrderDetailModel.fromMap(
    Map<String, dynamic> map,
    List<OrderItemModel> items,
    String address,
  ) =>
      OrderDetailModel(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        storeId: map['store_id'] as String,
        storeName: map['store_name'] as String? ?? '',
        status: map['status'] as String? ?? 'pending',
        totalAmount: (map['total_amount'] as num?)?.toDouble() ?? 0.0,
        deliveryFee: (map['delivery_fee'] as num?)?.toDouble() ?? 0.0,
        createdAt: map['created_at'] != null
            ? DateTime.parse(map['created_at'] as String)
            : DateTime.now(),
        itemCount: map['item_count'] as int? ?? 0,
        items: items,
        address: address,
        paymentMethod: map['payment_method'] as String? ?? 'Cash on Delivery',
      );

  @override
  List<Object?> get props => [id, status, items, address];
}
