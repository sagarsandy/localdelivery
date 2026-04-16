/// Order status enum shared across the customer app.
enum OrderStatus {
  pending,
  confirmed,
  outForDelivery,
  delivered,
  cancelled;

  String get label {
    switch (this) {
      case OrderStatus.pending: return 'Pending';
      case OrderStatus.confirmed: return 'Confirmed';
      case OrderStatus.outForDelivery: return 'Out for Delivery';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.cancelled: return 'Cancelled';
    }
  }

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => OrderStatus.pending,
    );
  }
}

/// Payment method enum.
enum PaymentMethod {
  cashOnDelivery,
  online;

  String get label {
    switch (this) {
      case PaymentMethod.cashOnDelivery: return 'Cash on Delivery';
      case PaymentMethod.online: return 'Online Payment';
    }
  }
}
