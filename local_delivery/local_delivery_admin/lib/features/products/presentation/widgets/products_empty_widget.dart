import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

class ProductsEmptyWidget extends StatelessWidget {
  const ProductsEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory_2_outlined,
              size: 72, color: LDColors.textDisabled),
          const SizedBox(height: 16),
          Text(
            'No products yet',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: LDColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first product to get started.',
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
