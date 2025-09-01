// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme_layout_builder.dart';

/// Quaestor — Dark Theme
/// - Brand gold: #D6B25E
/// - Brand navy (background): #0B0F13
/// Notes:
/// • Gold is used as PRIMARY; text/icons on gold are dark for contrast.
/// • Surfaces are navy-tinted charcoals to preserve a premium, minimal feel.
/// • Neutrals favor cool blue-grays for subtle separation on dark.

class DarkTheme {
  // === Brand Core ===
  final Color primaryColor = const Color(0xFFD6B25E); // Gold
  final Color onPrimaryColor = const Color(
    0xFF0B0F13,
  ); // Dark (navy/near-black)

  // Slightly darker, desaturated gold for containers/tonal fills
  final Color primaryContainerColor = const Color(0xFF3E3214);
  final Color onPrimaryContainerColor = const Color(0xFFF5E7C2);

  // Fixed tones (Material 3): light/pale golds for tonal surfaces
  final Color primaryFixedColor = const Color(0xFFF0E3BE);
  final Color primaryFixedDimColor = const Color(0xFFC4A964);
  final Color onPrimaryFixedColor = const Color(0xFF0B0F13);
  final Color onPrimaryFixedVariantColor = const Color(0xFF162028);

  // === Secondary (cool slate to complement gold & navy) ===
  final Color secondaryColor = const Color(0xFF8A96A5);
  final Color onSecondaryColor = const Color(0xFF0B0F13);
  final Color secondaryContainerColor = const Color(0xFF2B3540);
  final Color onSecondaryContainerColor = const Color(0xFFD7DEE6);
  final Color secondaryFixedColor = const Color(0xFFC4CCD6);
  final Color secondaryFixedDimColor = const Color(0xFF8A96A5);
  final Color onSecondaryFixedColor = const Color(0xFF0B0F13);
  final Color onSecondaryFixedVariantColor = const Color(0xFF162028);

  // === Tertiary (teal for positive/analytics accents; used sparingly) ===
  final Color tertiaryColor = const Color(0xFF66B2A3);
  final Color onTertiaryColor = const Color(0xFF0B0F13);
  final Color tertiaryContainerColor = const Color(0xFF143B36);
  final Color onTertiaryContainerColor = const Color(0xFFD6F2EB);
  final Color tertiaryFixedColor = const Color(0xFFBFE3DB);
  final Color tertiaryFixedDimColor = const Color(0xFF66B2A3);
  final Color onTertiaryFixedColor = const Color(0xFF0B0F13);
  final Color onTertiaryFixedVariantColor = const Color(0xFF162028);

  // === Error (Material dark defaults; readable on dark) ===
  final Color errorColor = const Color(0xFFF2B8B5);
  final Color onErrorColor = const Color(0xFF601410);
  final Color errorContainerColor = const Color(0xFF8C1D18);
  final Color onErrorContainerColor = const Color(0xFFF9DEDC);

  // === Surfaces (navy-tinted charcoals) ===
  // Base background matches app icon backdrop
  final Color surfaceColor = const Color(0xFF0B0F13);
  final Color onSurfaceColor = const Color(
    0xFFE6E9ED,
  ); // Primary text/icons on dark
  final Color surfaceDimColor = const Color(0xFF090D11);
  final Color surfaceBrightColor = const Color(0xFF12181D);

  // Tonal containers for elevation steps - Enhanced contrast for better card visibility
  final Color surfaceContainerLowestColor = const Color(
    0xFF0B0F13,
  ); // same as bg
  final Color surfaceContainerLowColor = const Color(0xFF10151B);
  final Color surfaceContainerColor = const Color(
    0xFF1A2128,
  ); // Increased contrast for cards
  final Color surfaceContainerHighColor = const Color(
    0xFF1E2730,
  ); // Enhanced contrast
  final Color surfaceContainerHighestColor = const Color(
    0xFF232C38,
  ); // Maximum contrast

  // Muted label/secondary content on dark
  final Color onSurfaceVariantColor = const Color(0xFFA7B0BA);

  // === System strokes & effects ===
  final Color outlineColor = const Color(
    0xFF4A5568,
  ); // Enhanced outline for better card boundaries
  final Color outlineVariantColor = const Color(
    0xFF374151,
  ); // Enhanced variant outline
  final Color shadowColor = const Color(0xFF000000);
  final Color scrimColor = const Color(0xFF000000);

  // Inverse surfaces (used in chips/tooltips etc.)
  final Color inverseSurfaceColor = const Color(0xFFE6E9ED);
  final Color onInverseSurfaceColor = const Color(0xFF0B0F13);
  final Color inversePrimaryColor = const Color(
    0xFFB99439,
  ); // deeper gold for inverse
  final Color surfaceTintColor = const Color(0xFFD6B25E); // tint = primary

  ColorScheme colorScheme() => ColorScheme(
    brightness: Brightness.dark,
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

  // Keep layout scales; these already work nicely with a minimalist look
  final layout = ThemeLayoutBuilder(
    radius: 12.0.r,
    spacing: 16.0.w,
    buttonHeight: 48.0.h,
    iconSize: 24.0.r,
    borderWidth: 2.0.w,
    cardElevation:
        4.0, // Increased elevation for better card visibility in dark mode
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
