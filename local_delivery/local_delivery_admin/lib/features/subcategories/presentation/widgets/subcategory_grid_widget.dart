import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../../categories/domain/models/category_model.dart';
import '../../domain/models/subcategory_model.dart';
import 'subcategory_card_widget.dart';

class SubcategoryGridWidget extends StatelessWidget {
  const SubcategoryGridWidget({
    super.key,
    required this.subcategories,
    required this.categories,
    required this.isMutating,
    required this.onEdit,
    required this.onDelete,
  });

  final List<SubcategoryModel> subcategories;
  final List<CategoryModel> categories;
  final bool isMutating;
  final ValueChanged<SubcategoryModel> onEdit;
  final ValueChanged<SubcategoryModel> onDelete;

  /// Returns the original-cased title for display, falling back to the stored value.
  String _categoryName(String category) {
    return categories
        .firstWhere(
          (c) => c.title.toLowerCase() == category,
          orElse: () => CategoryModel(id: '', title: category, image: ''),
        )
        .title;
  }

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
            childAspectRatio: 0.78,
          ),
          itemCount: subcategories.length,
          itemBuilder: (context, i) {
            final sub = subcategories[i];
            return SubcategoryCardWidget(
              subcategory: sub,
              categoryName: _categoryName(sub.category),
              onEdit: () => onEdit(sub),
              onDelete: () => onDelete(sub),
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
