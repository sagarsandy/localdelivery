import 'package:flutter/material.dart';
import 'package:local_delivery_ui/local_delivery_ui.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LDColors.background,
      appBar: AppBar(
        backgroundColor: LDColors.surface,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.eco_rounded, color: LDColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Admin Panel',
              style: context.titleLarge.copyWith(color: LDColors.primary),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.dashboard_outlined,
                size: 64, color: LDColors.textSecondary),
            const SizedBox(height: 16),
            Text('Dashboard', style: context.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Admin features coming soon.',
              style: context.bodyMedium.copyWith(color: LDColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
