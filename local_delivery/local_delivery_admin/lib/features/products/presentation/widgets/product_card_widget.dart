import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../domain/models/product_model.dart';

class ProductCardWidget extends StatelessWidget {
  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: SizedBox(
              width: 100,
              height: 110,
              child: LDNetworkImage(
                url: product.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      PopupMenuButton<_Action>(
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
                  const SizedBox(height: 4),
                  Text(
                    product.subcategory,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: LDColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: LDColors.primary,
                            ),
                      ),
                      if (product.originalPrice > product.price) ...[
                        const SizedBox(width: 6),
                        Text(
                          '₹${product.originalPrice.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: LDColors.textDisabled,
                                decoration: TextDecoration.lineThrough,
                              ),
                        ),
                      ],
                      const SizedBox(width: 8),
                      Text(
                        '${product.quantity} ${product.units}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: LDColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _StatusBadge(
                        label: product.inStock ? 'In Stock' : 'Out of Stock',
                        color: product.inStock ? LDColors.success : LDColors.error,
                      ),
                      const SizedBox(width: 6),
                      if (!product.isAvailable)
                        const _StatusBadge(
                          label: 'Hidden',
                          color: LDColors.textSecondary,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

enum _Action { edit, delete }
