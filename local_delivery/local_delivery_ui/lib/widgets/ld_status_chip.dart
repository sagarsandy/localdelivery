import 'package:flutter/material.dart';
import '../theme/ld_colors.dart';

enum LDOrderStatus { pending, confirmed, outForDelivery, delivered, cancelled }

extension LDOrderStatusExt on LDOrderStatus {
  String get label {
    switch (this) {
      case LDOrderStatus.pending: return 'Pending';
      case LDOrderStatus.confirmed: return 'Confirmed';
      case LDOrderStatus.outForDelivery: return 'Out for Delivery';
      case LDOrderStatus.delivered: return 'Delivered';
      case LDOrderStatus.cancelled: return 'Cancelled';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case LDOrderStatus.pending: return LDColors.statusPending;
      case LDOrderStatus.confirmed: return LDColors.statusConfirmed;
      case LDOrderStatus.outForDelivery: return LDColors.statusConfirmed;
      case LDOrderStatus.delivered: return LDColors.statusDelivered;
      case LDOrderStatus.cancelled: return LDColors.statusCancelled;
    }
  }

  Color get textColor {
    switch (this) {
      case LDOrderStatus.pending: return LDColors.statusPendingText;
      case LDOrderStatus.confirmed: return LDColors.statusConfirmedText;
      case LDOrderStatus.outForDelivery: return LDColors.statusConfirmedText;
      case LDOrderStatus.delivered: return LDColors.statusDeliveredText;
      case LDOrderStatus.cancelled: return LDColors.statusCancelledText;
    }
  }
}

/// Colored chip showing order status.
class LDStatusChip extends StatelessWidget {
  const LDStatusChip({super.key, required this.status});

  final LDOrderStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: status.textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
