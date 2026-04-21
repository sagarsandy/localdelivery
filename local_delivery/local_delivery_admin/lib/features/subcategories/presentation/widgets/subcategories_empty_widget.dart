import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

class SubcategoriesEmptyWidget extends StatelessWidget {
  const SubcategoriesEmptyWidget({super.key});

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
            'No subcategories yet',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: LDColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first subcategory to get started.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: LDColors.textDisabled),
          ),
        ],
      ),
    );
  }
}
