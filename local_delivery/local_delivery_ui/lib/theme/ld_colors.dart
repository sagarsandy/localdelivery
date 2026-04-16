import 'package:flutter/material.dart';

/// Brand color palette for Local Delivery apps.
class LDColors {
  LDColors._();

  // --- Primary Brand (Forest Green) ---
  static const Color primary = Color(0xFF1D5C38);
  static const Color primaryLight = Color(0xFF2D7A4F);
  static const Color primaryDark = Color(0xFF0F3D24);

  // --- Accent (Teal) ---
  static const Color accent = Color(0xFF00B5A0);
  static const Color accentLight = Color(0xFFE0F7F5);

  // --- Surfaces ---
  static const Color background = Color(0xFFEBEDE4);   // Warm sage — app background
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF2F2EF);
  static const Color inputFill = Color(0xFFEEEEEB);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // --- Text ---
  static const Color textPrimary = Color(0xFF1A2B1A);
  static const Color textSecondary = Color(0xFF6B7A6B);
  static const Color textDisabled = Color(0xFFB0BAB0);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // --- Semantic ---
  static const Color success = Color(0xFF2D7A4F);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1976D2);

  // --- UI Elements ---
  static const Color divider = Color(0xFFDEE0D8);
  static const Color border = Color(0xFFD4D6CE);
  static const Color shimmer = Color(0xFFDEE0D8);
  static const Color shimmerHighlight = Color(0xFFEEEFEB);
  static const Color overlay = Color(0x80000000);

  // --- Status ---
  static const Color statusPending = Color(0xFFFFF8E1);
  static const Color statusPendingText = Color(0xFFF9A825);
  static const Color statusConfirmed = Color(0xFFE3F2FD);
  static const Color statusConfirmedText = Color(0xFF1565C0);
  static const Color statusDelivered = Color(0xFFE8F5E9);
  static const Color statusDeliveredText = Color(0xFF1D5C38);
  static const Color statusCancelled = Color(0xFFFFEBEE);
  static const Color statusCancelledText = Color(0xFFC62828);
}
