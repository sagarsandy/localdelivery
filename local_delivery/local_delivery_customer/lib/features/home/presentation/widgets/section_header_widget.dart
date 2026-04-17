import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

class SectionHeaderWidget extends StatelessWidget {
  const SectionHeaderWidget({
    super.key,
    required this.title,
    required this.onViewAll,
  });

  final String title;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 8, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.titleLarge.copyWith(fontWeight: FontWeight.w800),
          ),
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              foregroundColor: LDColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: Text('View All', style: context.bodyMedium.copyWith(color: LDColors.primary)),
          ),
        ],
      ),
    );
  }
}
