import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../domain/models/category_model.dart';
import 'category_card_widget.dart';

class CategoryGridWidget extends StatelessWidget {
  const CategoryGridWidget({
    super.key,
    required this.categories,
    required this.isMutating,
    required this.onEdit,
    required this.onDelete,
  });

  final List<CategoryModel> categories;
  final bool isMutating;
  final ValueChanged<CategoryModel> onEdit;
  final ValueChanged<CategoryModel> onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: categories.length,
          itemBuilder: (context, i) {
            final cat = categories[i];
            return CategoryCardWidget(
              category: cat,
              onEdit: () => onEdit(cat),
              onDelete: () => onDelete(cat),
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
