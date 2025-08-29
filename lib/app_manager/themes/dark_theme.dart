// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme_layout_builder.dart';

class DarkTheme {
  // Dark theme colors
  final Color primaryColor = Color(0xFFFF8A50);
  final Color onPrimaryColor = Color(0xFF000000);
  final Color primaryContainerColor = Color(0xFFC1693C);
  final Color onPrimaryContainerColor = Color(0xFFFFDAD1);
  final Color primaryFixedColor = Color(0xFFFFCCBC);
  final Color primaryFixedDimColor = Color(0xFFC1693C);
  final Color onPrimaryFixedColor = Color(0xFF000000);
  final Color onPrimaryFixedVariantColor = Color(0xFFFFE0B2);

  final Color secondaryColor = Color(0xFFBDBDBD);
  final Color onSecondaryColor = Color(0xFF000000);
  final Color secondaryContainerColor = Color(0xFF424242);
  final Color onSecondaryContainerColor = Color(0xFFF5F5F5);
  final Color secondaryFixedColor = Color(0xFF9E9E9E);
  final Color secondaryFixedDimColor = Color(0xFF616161);
  final Color onSecondaryFixedColor = Color(0xFFFFFFFF);
  final Color onSecondaryFixedVariantColor = Color(0xFFBDBDBD);

  final Color tertiaryColor = Color(0xFF4DB6AC);
  final Color onTertiaryColor = Color(0xFF000000);
  final Color tertiaryContainerColor = Color(0xFF004D40);
  final Color onTertiaryContainerColor = Color(0xFFA7FFEB);
  final Color tertiaryFixedColor = Color(0xFF80CBC4);
  final Color tertiaryFixedDimColor = Color(0xFF004D40);
  final Color onTertiaryFixedColor = Color(0xFFFFFFFF);
  final Color onTertiaryFixedVariantColor = Color(0xFFB2DFDB);

  final Color errorColor = Color(0xFFF2B8B5);
  final Color onErrorColor = Color(0xFF601410);
  final Color errorContainerColor = Color(0xFF8C1D18);
  final Color onErrorContainerColor = Color(0xFFF9DEDC);

  final Color surfaceColor = Color(0xFF121212);
  final Color onSurfaceColor = Color(0xFFE0E0E0);
  final Color surfaceDimColor = Color(0xFF1E1E1E);
  final Color surfaceBrightColor = Color(0xFF2C2C2C);
  final Color surfaceContainerLowestColor = Color(0xFF1A1A1A);
  final Color surfaceContainerLowColor = Color(0xFF2A2A2A);
  final Color surfaceContainerColor = Color(0xFF2E2E2E);
  final Color surfaceContainerHighColor = Color(0xFF373737);
  final Color surfaceContainerHighestColor = Color(0xFF424242);
  final Color onSurfaceVariantColor = Color(0xFF9E9E9E);

  final Color outlineColor = Color(0xFF757575);
  final Color outlineVariantColor = Color(0xFF616161);
  final Color shadowColor = Color(0xFF000000);
  final Color scrimColor = Color(0xFF000000);
  final Color inverseSurfaceColor = Color(0xFFE0E0E0);
  final Color onInverseSurfaceColor = Color(0xFF121212);
  final Color inversePrimaryColor = Color(0xFFFFAB91);
  final Color surfaceTintColor = Color(0xFFFF8A50);

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
