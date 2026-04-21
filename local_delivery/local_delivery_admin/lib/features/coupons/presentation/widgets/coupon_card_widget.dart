import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../domain/models/coupon_model.dart';

class CouponCardWidget extends StatelessWidget {
  const CouponCardWidget({
    super.key,
    required this.coupon,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final CouponModel coupon;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final expired = coupon.isExpired;
    final statusColor = !coupon.isActive
        ? LDColors.textSecondary
        : expired
            ? LDColors.error
            : LDColors.success;
    final statusLabel =
        !coupon.isActive ? 'Inactive' : expired ? 'Expired' : 'Active';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: LDColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: LDColors.primary.withValues(alpha: 0.08),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.confirmation_number_outlined,
                      size: 18, color: LDColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    coupon.coupon,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: LDColors.primary,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const Spacer(),
                  _Badge(label: statusLabel, color: statusColor),
                  PopupMenuButton<_Action>(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.more_vert,
                        size: 20, color: LDColors.textSecondary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onSelected: (action) {
                      if (action == _Action.edit) onEdit();
                      if (action == _Action.delete) onDelete();
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: _Action.edit,
                        child: Row(children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 10),
                          Text('Edit'),
                        ]),
                      ),
                      PopupMenuItem(
                        value: _Action.delete,
                        child: Row(children: [
                          Icon(Icons.delete_outline,
                              size: 18, color: LDColors.error),
                          SizedBox(width: 10),
                          Text('Delete',
                              style: TextStyle(color: LDColors.error)),
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (coupon.description.isNotEmpty) ...[
                    Text(
                      coupon.description,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: LDColors.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                  ],
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.discount_outlined,
                        label: coupon.type == CouponType.amount
                            ? '₹${coupon.value} off'
                            : '${coupon.value}% off',
                        color: LDColors.primary,
                      ),
                      const SizedBox(width: 10),
                      _InfoChip(
                        icon: Icons.calendar_today_outlined,
                        label:
                            'Expires ${DateFormat('dd MMM yyyy').format(coupon.expiryDate)}',
                        color: expired ? LDColors.error : LDColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(
      {required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

enum _Action { edit, delete }
