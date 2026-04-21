import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../domain/models/product_model.dart';
import 'product_card_widget.dart';

class ProductsListWidget extends StatelessWidget {
  const ProductsListWidget({
    super.key,
    required this.products,
    required this.isMutating,
    required this.onEdit,
    required this.onDelete,
  });

  final List<ProductModel> products;
  final bool isMutating;
  final ValueChanged<ProductModel> onEdit;
  final ValueChanged<ProductModel> onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 88),
          itemCount: products.length,
          itemBuilder: (context, i) {
            final product = products[i];
            return ProductCardWidget(
              product: product,
              onEdit: () => onEdit(product),
              onDelete: () => onDelete(product),
            );
          },
        ),
        if (isMutating)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x33000000),
              child: Center(
                child: CircularProgressIndicator(color: LDColors.primary),
              ),
            ),
          ),
      ],
    );
  }
}
