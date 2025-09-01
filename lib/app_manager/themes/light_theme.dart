// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme_layout_builder.dart';

/// Quaestor — Light Theme
/// - Brand gold: #D6B25E  (primary)
/// - Brand navy: #0B0F13  (text/secondary)
/// - Soft light canvas for elegance & readability.

class LightTheme {
  // === Brand Core ===
  final Color primaryColor = const Color(0xFFD6B25E); // Gold
  final Color onPrimaryColor = const Color(0xFF0B0F13); // Dark navy text on gold

  // Pale gold container with readable on-color
  final Color primaryContainerColor = const Color(0xFFF5E7C2);
  final Color onPrimaryContainerColor = const Color(0xFF3E3214);

  // Fixed tones (Material 3)
  final Color primaryFixedColor = const Color(0xFFF0E3BE);
  final Color primaryFixedDimColor = const Color(0xFFC4A964);
  final Color onPrimaryFixedColor = const Color(0xFF0B0F13);
  final Color onPrimaryFixedVariantColor = const Color(0xFF162028);

  // === Secondary (brand navy for subtle emphasis) ===
  final Color secondaryColor = const Color(0xFF0B0F13);
  final Color onSecondaryColor = const Color(0xFFF0F3F6);
  final Color secondaryContainerColor = const Color(0xFFE6EAEE);
  final Color onSecondaryContainerColor = const Color(0xFF13202A);
  final Color secondaryFixedColor = const Color(0xFFE6EAEE);
  final Color secondaryFixedDimColor = const Color(0xFFC4CCD6);
  final Color onSecondaryFixedColor = const Color(0xFF13202A);
  final Color onSecondaryFixedVariantColor = const Color(0xFF2B3540);

  // === Tertiary (teal for analytics/positive accents) ===
  final Color tertiaryColor = const Color(0xFF2F9C8E);
  final Color onTertiaryColor = const Color(0xFFFFFFFF);
  final Color tertiaryContainerColor = const Color(0xFFD6F2EB);
  final Color onTertiaryContainerColor = const Color(0xFF0B2F2A);
  final Color tertiaryFixedColor = const Color(0xFFD6F2EB);
  final Color tertiaryFixedDimColor = const Color(0xFFBFE3DB);
  final Color onTertiaryFixedColor = const Color(0xFF0B2F2A);
  final Color onTertiaryFixedVariantColor = const Color(0xFF16534C);

  // === Error (Material light defaults) ===
  final Color errorColor = const Color(0xFFB00020);
  final Color onErrorColor = const Color(0xFFFFFFFF);
  final Color errorContainerColor = const Color(0xFFF9DEDC);
  final Color onErrorContainerColor = const Color(0xFF410E0B);

  // === Surfaces (soft light canvas) ===
  final Color surfaceColor = const Color(0xFFF7F8FA); // app background
  final Color onSurfaceColor = const Color(0xFF0B0F13); // primary text/icons
  final Color surfaceDimColor = const Color(0xFFF1F3F5);
  final Color surfaceBrightColor = const Color(0xFFFFFFFF);

  final Color surfaceContainerLowestColor = const Color(0xFFF2F4F6);
  final Color surfaceContainerLowColor = const Color(0xFFF7F8FA);
  final Color surfaceContainerColor = const Color(0xFFFFFFFF);      // cards
  final Color surfaceContainerHighColor = const Color(0xFFFFFFFF);
  final Color surfaceContainerHighestColor = const Color(0xFFFFFFFF);

  // Muted labels / subtitles
  final Color onSurfaceVariantColor = const Color(0xFF6B7580);

  // === Strokes & effects ===
  final Color outlineColor = const Color(0xFFCDD3D9);
  final Color outlineVariantColor = const Color(0xFFE2E7EB);
  final Color shadowColor = const Color(0xFF000000);
  final Color scrimColor = const Color(0xFF000000);

  // Inverse surfaces (for chips/tooltips on light)
  final Color inverseSurfaceColor = const Color(0xFF1A2128);
  final Color onInverseSurfaceColor = const Color(0xFFE6E9ED);
  final Color inversePrimaryColor = const Color(0xFFB99439); // deeper gold for inverse
  final Color surfaceTintColor = const Color(0xFFD6B25E);

  ColorScheme colorScheme() => ColorScheme(
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        primaryContainer: primaryContainerColor,
        onPrimaryContainer: onPrimaryContainerColor,
        primaryFixed: primaryFixedColor,
        primaryFixedDim: primaryFixedDimColor,
        onPrimaryFixed: onPrimaryFixedColor,
        onPrimaryFixedVariant: onPrimaryFixedVariantColor,
        secondary: secondaryColor,
        onSecondary: onSecondaryColor,
        secondaryContainer: secondaryContainerColor,
        onSecondaryContainer: onSecondaryContainerColor,
        secondaryFixed: secondaryFixedColor,
        secondaryFixedDim: secondaryFixedDimColor,
        onSecondaryFixed: onSecondaryFixedColor,
        onSecondaryFixedVariant: onSecondaryFixedVariantColor,
        tertiary: tertiaryColor,
        onTertiary: onTertiaryColor,
        tertiaryContainer: tertiaryContainerColor,
        onTertiaryContainer: onTertiaryContainerColor,
        tertiaryFixed: tertiaryFixedColor,
        tertiaryFixedDim: tertiaryFixedDimColor,
        onTertiaryFixed: onTertiaryFixedColor,
        onTertiaryFixedVariant: onTertiaryFixedVariantColor,
        error: errorColor,
        onError: onErrorColor,
        errorContainer: errorContainerColor,
        onErrorContainer: onErrorContainerColor,
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        surfaceDim: surfaceDimColor,
        surfaceBright: surfaceBrightColor,
        surfaceContainerLowest: surfaceContainerLowestColor,
        surfaceContainerLow: surfaceContainerLowColor,
        surfaceContainer: surfaceContainerColor,
        surfaceContainerHigh: surfaceContainerHighColor,
        surfaceContainerHighest: surfaceContainerHighestColor,
        onSurfaceVariant: onSurfaceVariantColor,
        outline: outlineColor,
        outlineVariant: outlineVariantColor,
        shadow: shadowColor,
        scrim: scrimColor,
        inverseSurface: inverseSurfaceColor,
        onInverseSurface: onInverseSurfaceColor,
        inversePrimary: inversePrimaryColor,
        surfaceTint: surfaceTintColor,
      );

  // Layout tokens unchanged (already minimal & balanced)
  final layout = ThemeLayoutBuilder(
    radius: 12.0.r,
    spacing: 16.0.w,
    buttonHeight: 48.0.h,
    iconSize: 24.0.r,
    borderWidth: 2.0.w,
    cardElevation: 2.0,
    dialogRadius: 12.0.r,
    tilePaddingH: 16.0.w,
    tilePaddingV: 8.0.h,
    tooltipRadius: 8.0.r,
    dividerThickness: 1.0.h,
    snackBarBorderWidth: 1.5.w,
    fontSizeDisplayLarge: 57.sp,
    fontSizeDisplayMedium: 45.sp,
    fontSizeDisplaySmall: 36.sp,
    fontSizeHeadlineLarge: 32.sp,
    fontSizeHeadlineMedium: 28.sp,
    fontSizeHeadlineSmall: 24.sp,
    fontSizeTitleLarge: 22.sp,
    fontSizeTitleMedium: 16.sp,
    fontSizeTitleSmall: 14.sp,
    fontSizeBodyLarge: 16.sp,
    fontSizeBodyMedium: 14.sp,
    fontSizeBodySmall: 12.sp,
    fontSizeLabelLarge: 14.sp,
    fontSizeLabelMedium: 12.sp,
    fontSizeLabelSmall: 11.sp,
  );
}
