import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../domain/models/subcategory_model.dart';

class FreshSubcategoriesSection extends StatelessWidget {
  const FreshSubcategoriesSection({super.key, required this.subcategories});

  final List<SubcategoryModel> subcategories;

  @override
  Widget build(BuildContext context) {
    if (subcategories.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemCount: subcategories.length > 6 ? 6 : subcategories.length,
        itemBuilder: (context, index) {
          return _SubcategoryTile(subcategory: subcategories[index]);
        },
      ),
    );
  }
}

class _SubcategoryTile extends StatelessWidget {
  const _SubcategoryTile({required this.subcategory});
  final SubcategoryModel subcategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: LDNetworkImage(
                url: subcategory.imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Text(
              subcategory.name,
              style: context.labelSmall.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
