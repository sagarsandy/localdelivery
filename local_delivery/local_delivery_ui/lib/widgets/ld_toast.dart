import 'package:flutter/material.dart';
import '../theme/ld_colors.dart';

enum LDToastType { success, error, warning, info }

/// Shows a styled snackbar toast.
class LDToast {
  static void show(
    BuildContext context, {
    required String message,
    LDToastType type = LDToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final colors = {
      LDToastType.success: LDColors.success,
      LDToastType.error: LDColors.error,
      LDToastType.warning: LDColors.warning,
      LDToastType.info: LDColors.info,
    };
    final icons = {
      LDToastType.success: Icons.check_circle_outline,
      LDToastType.error: Icons.error_outline,
      LDToastType.warning: Icons.warning_amber_outlined,
      LDToastType.info: Icons.info_outline,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: colors[type],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Icon(icons[type], color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
