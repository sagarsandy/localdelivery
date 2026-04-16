import 'package:flutter/material.dart';
import 'ld_colors.dart';
import 'ld_typography.dart';

/// App-wide ThemeData for Local Delivery.
class LDTheme {
  LDTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: LDColors.primary,
          onPrimary: LDColors.textOnPrimary,
          primaryContainer: LDColors.primaryLight,
          secondary: LDColors.accent,
          onSecondary: LDColors.textOnPrimary,
          secondaryContainer: LDColors.accentLight,
          surface: LDColors.surface,
          onSurface: LDColors.textPrimary,
          error: LDColors.error,
          onError: LDColors.textOnPrimary,
        ),
        scaffoldBackgroundColor: LDColors.background,
        textTheme: LDTypography.textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: LDColors.surface,
          foregroundColor: LDColors.textPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: LDTypography.textTheme.headlineSmall,
        ),
        cardTheme: CardThemeData(
          color: LDColors.cardBackground,
          elevation: 2,
          shadowColor: LDColors.textDisabled.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: LDColors.primary,
            foregroundColor: LDColors.textOnPrimary,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: LDTypography.textTheme.labelLarge,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: LDColors.primary,
            minimumSize: const Size(double.infinity, 52),
            side: const BorderSide(color: LDColors.primary, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: LDTypography.textTheme.labelLarge,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: LDColors.inputFill,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: LDColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: LDColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: LDColors.error),
          ),
          hintStyle: LDTypography.textTheme.bodyMedium?.copyWith(
            color: LDColors.textDisabled,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: LDColors.divider,
          thickness: 1,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: LDColors.surface,
          selectedItemColor: LDColors.primary,
          unselectedItemColor: LDColors.textSecondary,
          selectedLabelStyle: LDTypography.textTheme.labelSmall,
          unselectedLabelStyle: LDTypography.textTheme.labelSmall,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: LDColors.surfaceVariant,
          labelStyle: LDTypography.textTheme.labelMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
}
