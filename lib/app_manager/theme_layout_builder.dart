import 'dart:ui';
import 'package:flutter/material.dart';

@immutable
class ThemeLayoutBuilder extends ThemeExtension<ThemeLayoutBuilder> {
  final double radius;
  final double spacing;
  final double buttonHeight;
  final double iconSize;
  final double borderWidth;
  final double cardElevation;
  final double dialogRadius;
  final double tilePaddingV;
  final double tilePaddingH;
  final double tooltipRadius;
  final double dividerThickness;
  final double snackBarBorderWidth;

  // Typography sizes
  final double fontSizeDisplayLarge;
  final double fontSizeDisplayMedium;
  final double fontSizeDisplaySmall;
  final double fontSizeHeadlineLarge;
  final double fontSizeHeadlineMedium;
  final double fontSizeHeadlineSmall;
  final double fontSizeTitleLarge;
  final double fontSizeTitleMedium;
  final double fontSizeTitleSmall;
  final double fontSizeBodyLarge;
  final double fontSizeBodyMedium;
  final double fontSizeBodySmall;
  final double fontSizeLabelLarge;
  final double fontSizeLabelMedium;
  final double fontSizeLabelSmall;

  const ThemeLayoutBuilder({
    required this.radius,
    required this.spacing,
    required this.buttonHeight,
    required this.iconSize,
    required this.borderWidth,
    required this.cardElevation,
    required this.dialogRadius,
    required this.tilePaddingV,
    required this.tilePaddingH,
    required this.tooltipRadius,
    required this.dividerThickness,
    required this.snackBarBorderWidth,
    required this.fontSizeDisplayLarge,
    required this.fontSizeDisplayMedium,
    required this.fontSizeDisplaySmall,
    required this.fontSizeHeadlineLarge,
    required this.fontSizeHeadlineMedium,
    required this.fontSizeHeadlineSmall,
    required this.fontSizeTitleLarge,
    required this.fontSizeTitleMedium,
    required this.fontSizeTitleSmall,
    required this.fontSizeBodyLarge,
    required this.fontSizeBodyMedium,
    required this.fontSizeBodySmall,
    required this.fontSizeLabelLarge,
    required this.fontSizeLabelMedium,
    required this.fontSizeLabelSmall,
  });

  @override
  ThemeLayoutBuilder copyWith({
    double? radius,
    double? spacing,
    double? buttonHeight,
    double? iconSize,
    double? borderWidth,
    double? cardElevation,
    double? dialogRadius,
    double? tilePaddingV,
    double? tilePaddingH,
    double? tooltipRadius,
    double? dividerThickness,
    double? snackBarBorderWidth,
    double? fontSizeDisplayLarge,
    double? fontSizeDisplayMedium,
    double? fontSizeDisplaySmall,
    double? fontSizeHeadlineLarge,
    double? fontSizeHeadlineMedium,
    double? fontSizeHeadlineSmall,
    double? fontSizeTitleLarge,
    double? fontSizeTitleMedium,
    double? fontSizeTitleSmall,
    double? fontSizeBodyLarge,
    double? fontSizeBodyMedium,
    double? fontSizeBodySmall,
    double? fontSizeLabelLarge,
    double? fontSizeLabelMedium,
    double? fontSizeLabelSmall,
  }) {
    return ThemeLayoutBuilder(
      radius: radius ?? this.radius,
      spacing: spacing ?? this.spacing,
      buttonHeight: buttonHeight ?? this.buttonHeight,
      iconSize: iconSize ?? this.iconSize,
      borderWidth: borderWidth ?? this.borderWidth,
      cardElevation: cardElevation ?? this.cardElevation,
      dialogRadius: dialogRadius ?? this.dialogRadius,
      tilePaddingV: tilePaddingV ?? this.tilePaddingV,
      tilePaddingH: tilePaddingH ?? this.tilePaddingH,
      tooltipRadius: tooltipRadius ?? this.tooltipRadius,
      dividerThickness: dividerThickness ?? this.dividerThickness,
      snackBarBorderWidth: snackBarBorderWidth ?? this.snackBarBorderWidth,
      fontSizeDisplayLarge: fontSizeDisplayLarge ?? this.fontSizeDisplayLarge,
      fontSizeDisplayMedium:
          fontSizeDisplayMedium ?? this.fontSizeDisplayMedium,
      fontSizeDisplaySmall: fontSizeDisplaySmall ?? this.fontSizeDisplaySmall,
      fontSizeHeadlineLarge:
          fontSizeHeadlineLarge ?? this.fontSizeHeadlineLarge,
      fontSizeHeadlineMedium:
          fontSizeHeadlineMedium ?? this.fontSizeHeadlineMedium,
      fontSizeHeadlineSmall:
          fontSizeHeadlineSmall ?? this.fontSizeHeadlineSmall,
      fontSizeTitleLarge: fontSizeTitleLarge ?? this.fontSizeTitleLarge,
      fontSizeTitleMedium: fontSizeTitleMedium ?? this.fontSizeTitleMedium,
      fontSizeTitleSmall: fontSizeTitleSmall ?? this.fontSizeTitleSmall,
      fontSizeBodyLarge: fontSizeBodyLarge ?? this.fontSizeBodyLarge,
      fontSizeBodyMedium: fontSizeBodyMedium ?? this.fontSizeBodyMedium,
      fontSizeBodySmall: fontSizeBodySmall ?? this.fontSizeBodySmall,
      fontSizeLabelLarge: fontSizeLabelLarge ?? this.fontSizeLabelLarge,
      fontSizeLabelMedium: fontSizeLabelMedium ?? this.fontSizeLabelMedium,
      fontSizeLabelSmall: fontSizeLabelSmall ?? this.fontSizeLabelSmall,
    );
  }

  @override
  ThemeLayoutBuilder lerp(ThemeExtension<ThemeLayoutBuilder>? other, double t) {
    if (other is! ThemeLayoutBuilder) return this;
    return ThemeLayoutBuilder(
      radius: lerpDouble(radius, other.radius, t)!,
      spacing: lerpDouble(spacing, other.spacing, t)!,
      buttonHeight: lerpDouble(buttonHeight, other.buttonHeight, t)!,
      iconSize: lerpDouble(iconSize, other.iconSize, t)!,
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t)!,
      cardElevation: lerpDouble(cardElevation, other.cardElevation, t)!,
      dialogRadius: lerpDouble(dialogRadius, other.dialogRadius, t)!,
      tilePaddingV: lerpDouble(tilePaddingV, other.tilePaddingV, t)!,
      tilePaddingH: lerpDouble(tilePaddingH, other.tilePaddingH, t)!,
      tooltipRadius: lerpDouble(tooltipRadius, other.tooltipRadius, t)!,
      dividerThickness: lerpDouble(
        dividerThickness,
        other.dividerThickness,
        t,
      )!,
      snackBarBorderWidth: lerpDouble(
        snackBarBorderWidth,
        other.snackBarBorderWidth,
        t,
      )!,
      fontSizeDisplayLarge: lerpDouble(
        fontSizeDisplayLarge,
        other.fontSizeDisplayLarge,
        t,
      )!,
      fontSizeDisplayMedium: lerpDouble(
        fontSizeDisplayMedium,
        other.fontSizeDisplayMedium,
        t,
      )!,
      fontSizeDisplaySmall: lerpDouble(
        fontSizeDisplaySmall,
        other.fontSizeDisplaySmall,
        t,
      )!,
      fontSizeHeadlineLarge: lerpDouble(
        fontSizeHeadlineLarge,
        other.fontSizeHeadlineLarge,
        t,
      )!,
      fontSizeHeadlineMedium: lerpDouble(
        fontSizeHeadlineMedium,
        other.fontSizeHeadlineMedium,
        t,
      )!,
      fontSizeHeadlineSmall: lerpDouble(
        fontSizeHeadlineSmall,
        other.fontSizeHeadlineSmall,
        t,
      )!,
      fontSizeTitleLarge: lerpDouble(
        fontSizeTitleLarge,
        other.fontSizeTitleLarge,
        t,
      )!,
      fontSizeTitleMedium: lerpDouble(
        fontSizeTitleMedium,
        other.fontSizeTitleMedium,
        t,
      )!,
      fontSizeTitleSmall: lerpDouble(
        fontSizeTitleSmall,
        other.fontSizeTitleSmall,
        t,
      )!,
      fontSizeBodyLarge: lerpDouble(
        fontSizeBodyLarge,
        other.fontSizeBodyLarge,
        t,
      )!,
      fontSizeBodyMedium: lerpDouble(
        fontSizeBodyMedium,
        other.fontSizeBodyMedium,
        t,
      )!,
      fontSizeBodySmall: lerpDouble(
        fontSizeBodySmall,
        other.fontSizeBodySmall,
        t,
      )!,
      fontSizeLabelLarge: lerpDouble(
        fontSizeLabelLarge,
        other.fontSizeLabelLarge,
        t,
      )!,
      fontSizeLabelMedium: lerpDouble(
        fontSizeLabelMedium,
        other.fontSizeLabelMedium,
        t,
      )!,
      fontSizeLabelSmall: lerpDouble(
        fontSizeLabelSmall,
        other.fontSizeLabelSmall,
        t,
      )!,
    );
  }
}
