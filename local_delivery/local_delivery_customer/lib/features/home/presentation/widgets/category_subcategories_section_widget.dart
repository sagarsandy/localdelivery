import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import '../../domain/models/subcategory_model.dart';

const _kAccent =
    Color(0xFF4CAF50); // green — used only for border & header accent

enum _SectionStyle { horizontalScroll, circularChips }

class CategorySubcategoriesSectionWidget extends StatelessWidget {
  const CategorySubcategoriesSectionWidget({
    super.key,
    required this.categoryName,
    required this.subcategories,
    required this.onViewAll,
    required this.index,
  });

  final String categoryName;
  final List<SubcategoryModel> subcategories;
  final VoidCallback onViewAll;

  /// Alternates layout style: even → horizontal cards, odd → circular chips.
  final int index;

  @override
  Widget build(BuildContext context) {
    if (subcategories.isEmpty) return const SizedBox.shrink();

    final style = index.isEven
        ? _SectionStyle.horizontalScroll
        : _SectionStyle.circularChips;
    final displayItems =
        subcategories.length > 8 ? subcategories.sublist(0, 8) : subcategories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header with green left-bar accent
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 8, 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 22,
                decoration: BoxDecoration(
                  color: _kAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  categoryName,
                  style:
                      context.titleLarge.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  foregroundColor: LDColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                child: Text(
                  'View All',
                  style: context.labelMedium.copyWith(
                    color: LDColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Content — alternates by section index
        switch (style) {
          _SectionStyle.horizontalScroll =>
            _HorizontalScrollSectionWidget(items: displayItems),
          _SectionStyle.circularChips =>
            _CircularChipsSectionWidget(items: displayItems),
        },

        const SizedBox(height: 4),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Even sections — tall rounded cards, horizontal scroll
// Clean white card with 1px green border, black title text
// ─────────────────────────────────────────────────────────────
class _HorizontalScrollSectionWidget extends StatelessWidget {
  const _HorizontalScrollSectionWidget({required this.items});
  final List<SubcategoryModel> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final sub = items[index];
          return Container(
            width: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _kAccent, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(13)),
                    child: LDNetworkImage(
                      url: sub.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                  child: Text(
                    sub.name,
                    style: context.labelSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Odd sections — circular avatar chips, horizontal scroll
// 82px circle (+20%), 1px green border, black title text
// ─────────────────────────────────────────────────────────────
class _CircularChipsSectionWidget extends StatelessWidget {
  const _CircularChipsSectionWidget({required this.items});
  final List<SubcategoryModel> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final sub = items[index];
          return SizedBox(
            width: 90,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _kAccent, width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: LDNetworkImage(
                      url: sub.imageUrl,
                      width: 82,
                      height: 82,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  sub.name,
                  style: context.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
