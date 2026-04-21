import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

class CategoriesEmptyWidget extends StatelessWidget {
  const CategoriesEmptyWidget({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.category_outlined,
              size: 72, color: LDColors.textDisabled),
          const SizedBox(height: 16),
          Text(
            'No categories yet',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: LDColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first category to get started.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: LDColors.textDisabled),
          ),
          const SizedBox(height: 24),
          LDButton(
            label: 'Add Category',
            onPressed: onAdd,
            width: 180,
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
