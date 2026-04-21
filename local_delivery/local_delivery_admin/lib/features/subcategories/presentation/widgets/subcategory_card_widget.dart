import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../domain/models/subcategory_model.dart';

class SubcategoryCardWidget extends StatelessWidget {
  const SubcategoryCardWidget({
    super.key,
    required this.subcategory,
    required this.categoryName,
    required this.onEdit,
    required this.onDelete,
  });

  final SubcategoryModel subcategory;
  final String categoryName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: LDNetworkImage(
              url: subcategory.image,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 4, 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subcategory.title,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: LDColors.textPrimary,
                                ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        categoryName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: LDColors.textSecondary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

enum _Action { edit, delete }
