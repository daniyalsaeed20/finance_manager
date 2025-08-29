// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme_layout_builder.dart';

class LightTheme {
  final Color primaryColor = Color(0xFFFF5724);
  final Color onPrimaryColor = Color(0xFFFFFFFF);
  final Color primaryContainerColor = Color(0xFFFBE9E7);
  final Color onPrimaryContainerColor = Color(0xFFBF360C);
  final Color primaryFixedColor = Color(0xFFFBE9E7);
  final Color primaryFixedDimColor = Color(0xFFFFCCBC);
  final Color onPrimaryFixedColor = Color(0xFFBF360C);
  final Color onPrimaryFixedVariantColor = Color(0xFFD84315);

  final Color secondaryColor = Color(0xFF757575);
  final Color onSecondaryColor = Color(0xFFFFFFFF);
  final Color secondaryContainerColor = Color(0xFFEEEEEE);
  final Color onSecondaryContainerColor = Color(0xFF000000);
  final Color secondaryFixedColor = Color(0xFFEEEEEE);
  final Color secondaryFixedDimColor = Color(0xFFBDBDBD);
  final Color onSecondaryFixedColor = Color(0xFF000000);
  final Color onSecondaryFixedVariantColor = Color(0xFF616161);

  final Color tertiaryColor = Color(0xFF00796B);
  final Color onTertiaryColor = Color(0xFFFFFFFF);
  final Color tertiaryContainerColor = Color(0xFFE0F2F1);
  final Color onTertiaryContainerColor = Color(0xFF004D40);
  final Color tertiaryFixedColor = Color(0xFFE0F2F1);
  final Color tertiaryFixedDimColor = Color(0xFFB2DFDB);
  final Color onTertiaryFixedColor = Color(0xFF004D40);
  final Color onTertiaryFixedVariantColor = Color(0xFF00695C);

  final Color errorColor = Color(0xFFB00020);
  final Color onErrorColor = Color(0xFFFFFFFF);
  final Color errorContainerColor = Color(0xFFF9DEDC);
  final Color onErrorContainerColor = Color(0xFF410E0B);

  final Color surfaceColor = Color(0xFFFFFFFF);
  final Color onSurfaceColor = Color(0xFF000000);
  final Color surfaceDimColor = Color(0xFFF5F5F5);
  final Color surfaceBrightColor = Color(0xFFFFFFFF);
  final Color surfaceContainerLowestColor = Color(0xFFF5F5F5);
  final Color surfaceContainerLowColor = Color(0xFFFAFAFA);
  final Color surfaceContainerColor = Color(0xFFFFFFFF);
  final Color surfaceContainerHighColor = Color(0xFFFFFFFF);
  final Color surfaceContainerHighestColor = Color(0xFFFFFFFF);
  final Color onSurfaceVariantColor = Color(0x8A000000);

  final Color outlineColor = Color(0xFF757575);
  final Color outlineVariantColor = Color(0xFF9E9E9E);
  final Color shadowColor = Color(0xFF000000);
  final Color scrimColor = Color(0xFF000000);
  final Color inverseSurfaceColor = Color(0xFF313033);
  final Color onInverseSurfaceColor = Color(0xFFFBEEE9);
  final Color inversePrimaryColor = Color(0xFFFFB68F);
  final Color surfaceTintColor = Color(0xFFFF5724);

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
