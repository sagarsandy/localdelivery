import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.eco_rounded, color: LDColors.primary, size: 22),
            const SizedBox(width: 6),
            Text(
              'Local Market',
              style: context.titleLarge.copyWith(color: LDColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 48),
        Text('Welcome', style: context.displayLarge),
        const SizedBox(height: 8),
        Text(
          'Log in to experience effortless freshness.',
          style: context.bodyLarge.copyWith(color: LDColors.textSecondary),
        ),
      ],
    );
  }
}
