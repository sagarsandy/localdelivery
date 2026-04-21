import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

import 'admin_drawer_widget.dart';

class SectionPlaceholderWidget extends StatelessWidget {
  const SectionPlaceholderWidget({super.key, required this.section});

  final AdminSection section;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(section.icon, size: 56, color: LDColors.textSecondary),
          const SizedBox(height: 16),
          Text(section.label, style: context.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Coming soon.',
            style: context.bodyMedium.copyWith(color: LDColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
