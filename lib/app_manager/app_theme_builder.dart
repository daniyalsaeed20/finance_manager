// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme_layout_builder.dart';

class AppThemeBuilder {
  final ColorScheme colorScheme;
  final ThemeLayoutBuilder layout;

  AppThemeBuilder({required this.colorScheme, required this.layout});

  AppThemeBuilder copyWith({
    ColorScheme? colorScheme,
    ThemeLayoutBuilder? layout,
  }) => AppThemeBuilder(
    colorScheme: colorScheme ?? this.colorScheme,
    layout: layout ?? this.layout,
  );

  TextTheme _textTheme() => TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: layout.fontSizeDisplayLarge,
      fontWeight: FontWeight.w400,
      color: colorScheme.onSurface,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: layout.fontSizeDisplayMedium,
      fontWeight: FontWeight.w400,
      color: colorScheme.onSurface,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: layout.fontSizeDisplaySmall,
      fontWeight: FontWeight.w400,
      color: colorScheme.onSurface,
    ),
    headlineLarge: GoogleFonts.poppins(
      fontSize: layout.fontSizeHeadlineLarge,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: layout.fontSizeHeadlineMedium,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurface,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: layout.fontSizeHeadlineSmall,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurface,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: layout.fontSizeTitleLarge,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: layout.fontSizeTitleMedium,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurface,
    ),
    titleSmall: GoogleFonts.poppins(
      fontSize: layout.fontSizeTitleSmall,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurface,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: layout.fontSizeBodyLarge,
      fontWeight: FontWeight.w400,
      color: colorScheme.onSurface,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: layout.fontSizeBodyMedium,
      fontWeight: FontWeight.w400,
      color: colorScheme.onSurface,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: layout.fontSizeBodySmall,
      fontWeight: FontWeight.w400,
      color: colorScheme.onSurfaceVariant,
    ),
    labelLarge: GoogleFonts.poppins(
      fontSize: layout.fontSizeLabelLarge,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurface,
    ),
    labelMedium: GoogleFonts.poppins(
      fontSize: layout.fontSizeLabelMedium,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurface,
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: layout.fontSizeLabelSmall,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurfaceVariant,
    ),
  );

  IconButtonThemeData _iconButtonTheme() => IconButtonThemeData(
    style: ButtonStyle(
      minimumSize: WidgetStateProperty.all(Size.square(layout.iconSize + 16.r)),
      padding: WidgetStateProperty.all(EdgeInsets.all(layout.spacing / 2)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(layout.radius),
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurfaceVariant;
        }
        return colorScheme.primary;
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return colorScheme.primary.withOpacity(0.1);
        }
        return null;
      }),
      overlayColor: WidgetStateProperty.all(
        colorScheme.primary.withOpacity(0.08),
      ),
      shadowColor: WidgetStateProperty.all(colorScheme.shadow),
      elevation: WidgetStateProperty.all(0),
    ),
  );

  TooltipThemeData _tooltipTheme() => TooltipThemeData(
    waitDuration: const Duration(milliseconds: 400),
    showDuration: const Duration(seconds: 3),
    padding: EdgeInsets.symmetric(
      horizontal: layout.spacing * 0.75,
      vertical: layout.spacing * 0.5,
    ),
    textStyle: GoogleFonts.poppins(
      fontSize: layout.fontSizeLabelMedium,
      fontWeight: FontWeight.w500,
      color: colorScheme.onInverseSurface,
    ),
    decoration: BoxDecoration(
      color: colorScheme.inverseSurface,
      borderRadius: BorderRadius.circular(layout.tooltipRadius),
      border: Border.all(
        color: colorScheme.primary,
        width: layout.borderWidth / 2,
      ),
    ),
  );

  IconThemeData _iconThemeSized() =>
      IconThemeData(size: layout.iconSize, color: colorScheme.primary);

  ElevatedButtonThemeData _elevatedButtonTheme() => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: Size.fromHeight(layout.buttonHeight),
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      textStyle: GoogleFonts.poppins(
        fontSize: layout.fontSizeBodyLarge,
        fontWeight: FontWeight.w600,
        color: colorScheme.onPrimary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(layout.radius),
      ),
      overlayColor: colorScheme.primary.withOpacity(0.08),
      shadowColor: colorScheme.shadow,
      elevation: layout.cardElevation,
    ),
  );

  OutlinedButtonThemeData _outlinedButtonTheme() => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: Size.fromHeight(layout.buttonHeight),
      foregroundColor: colorScheme.primary,
      side: BorderSide(color: colorScheme.primary, width: layout.borderWidth),
      textStyle: GoogleFonts.poppins(
        fontSize: layout.fontSizeBodyLarge,
        fontWeight: FontWeight.w600,
        color: colorScheme.primary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(layout.radius),
      ),
      overlayColor: colorScheme.primary.withOpacity(0.08),
    ),
  );

  TextButtonThemeData _textButtonTheme() => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: colorScheme.primary,
      textStyle: GoogleFonts.poppins(
        fontSize: layout.fontSizeBodyLarge,
        fontWeight: FontWeight.w600,
        color: colorScheme.primary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(layout.radius),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: layout.spacing,
        vertical: layout.spacing / 2,
      ),
      overlayColor: colorScheme.primary.withOpacity(0.08),
    ),
  );

  InputDecorationTheme _inputDecorationTheme() => InputDecorationTheme(
    filled: true,
    fillColor: colorScheme.surfaceContainerLowest,
    contentPadding: EdgeInsets.all(layout.spacing),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(layout.radius),
      borderSide: BorderSide(color: colorScheme.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(layout.radius),
      borderSide: BorderSide(color: colorScheme.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(layout.radius),
      borderSide: BorderSide(
        color: colorScheme.primary,
        width: layout.borderWidth,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(layout.radius),
      borderSide: BorderSide(
        color: colorScheme.error,
        width: layout.snackBarBorderWidth,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(layout.radius),
      borderSide: BorderSide(
        color: colorScheme.error,
        width: layout.borderWidth,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(layout.radius),
      borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1.w),
    ),
    labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
    errorStyle: TextStyle(color: colorScheme.error),
    helperStyle: TextStyle(color: colorScheme.onSurfaceVariant),
  );

  CardThemeData _cardTheme() => CardThemeData(
    color: colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(layout.radius),
    ),
    elevation: layout.cardElevation,
    shadowColor: colorScheme.shadow,
    // surfaceTintColor: colorScheme.surfaceTint,
    margin: EdgeInsets.all(layout.spacing),
  );

  ListTileThemeData _listTileTheme() => ListTileThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(layout.radius),
    ),
    iconColor: colorScheme.onSurfaceVariant,
    textColor: colorScheme.onSurface,
    tileColor: Colors.transparent,
    selectedColor: colorScheme.onPrimary,
    selectedTileColor: colorScheme.primary.withOpacity(0.1),
    contentPadding: EdgeInsets.symmetric(
      horizontal: layout.tilePaddingH,
      vertical: layout.tilePaddingV,
    ),
  );

  SwitchThemeData _switchTheme() => SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return colorScheme.primary;
      }
      return colorScheme.surfaceContainerHighest;
    }),
    trackColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return colorScheme.primary.withOpacity(0.5);
      }
      return colorScheme.outlineVariant.withOpacity(0.5);
    }),
    trackOutlineColor: WidgetStateProperty.all(colorScheme.outline),
  );

  CheckboxThemeData _checkboxTheme() => CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(layout.radius / 3),
    ),
    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.disabled)) {
        return colorScheme.outlineVariant;
      }
      if (states.contains(WidgetState.selected)) {
        return colorScheme.primary;
      }
      return colorScheme.surfaceContainerHighest;
    }),
    checkColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return colorScheme.onPrimary;
      }
      return colorScheme.onSurfaceVariant;
    }),
    overlayColor: WidgetStateProperty.all(
      colorScheme.primary.withOpacity(0.08),
    ),
    side: BorderSide(color: colorScheme.outline, width: layout.borderWidth),
  );

  SliderThemeData _sliderTheme() => SliderThemeData(
    thumbColor: colorScheme.primary,
    activeTrackColor: colorScheme.primary,
    inactiveTrackColor: colorScheme.surfaceVariant,
    overlayColor: colorScheme.primary.withOpacity(0.1),
    trackHeight: layout.dividerThickness,
    valueIndicatorColor: colorScheme.primary,
    inactiveTickMarkColor: colorScheme.outlineVariant,
    activeTickMarkColor: colorScheme.onPrimary,
  );

  AppBarTheme _appBarTheme() => AppBarTheme(
    centerTitle: true,
    backgroundColor: colorScheme.surface,
    elevation: 0,
    iconTheme: IconThemeData(
      color: colorScheme.onSurface,
      size: layout.iconSize,
    ),
    titleTextStyle: GoogleFonts.poppins(
      fontSize: layout.fontSizeTitleLarge,
      fontWeight: FontWeight.w600,
      color: colorScheme.onSurface,
    ),
    surfaceTintColor: colorScheme.surfaceTint,
    shadowColor: colorScheme.shadow,
  );

  SnackBarThemeData _snackBarTheme() => SnackBarThemeData(
    backgroundColor: colorScheme.inverseSurface,
    contentTextStyle: GoogleFonts.poppins(
      color: colorScheme.onInverseSurface,
      fontSize: layout.fontSizeBodyMedium,
      fontWeight: FontWeight.w500,
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(layout.radius),
      side: BorderSide(
        color: colorScheme.primary,
        width: layout.snackBarBorderWidth,
      ),
    ),
    elevation: layout.cardElevation,
  );

  DividerThemeData _dividerTheme() => DividerThemeData(
    color: colorScheme.outlineVariant,
    thickness: layout.dividerThickness,
    space: layout.spacing * 1.5,
    indent: layout.spacing,
    endIndent: layout.spacing,
  );

  DialogThemeData _dialogTheme() => DialogThemeData(
    backgroundColor: colorScheme.surface,
    titleTextStyle: _textTheme().titleLarge,
    contentTextStyle: _textTheme().bodyMedium,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(layout.dialogRadius),
    ),
  );

  BottomSheetThemeData _bottomSheetTheme() => BottomSheetThemeData(
    backgroundColor: colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(layout.dialogRadius),
      ),
    ),
    modalBackgroundColor: colorScheme.surface,
    showDragHandle: true,
  );

  BottomNavigationBarThemeData _bottomNavigationBarTheme() =>
      BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedIconTheme: IconThemeData(
          size: layout.iconSize,
          color: colorScheme.primary,
        ),
        unselectedIconTheme: IconThemeData(
          size: layout.iconSize,
          color: colorScheme.onSurfaceVariant,
        ),
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: layout.fontSizeLabelMedium,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: layout.fontSizeLabelMedium,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurfaceVariant,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: layout.cardElevation,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      );

  ThemeData buildTheme() => ThemeData(
    useMaterial3: true,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surfaceContainerLowest,
    textTheme: _textTheme(),
    elevatedButtonTheme: _elevatedButtonTheme(),
    outlinedButtonTheme: _outlinedButtonTheme(),
    textButtonTheme: _textButtonTheme(),
    inputDecorationTheme: _inputDecorationTheme(),
    cardTheme: _cardTheme(),
    listTileTheme: _listTileTheme(),
    switchTheme: _switchTheme(),
    checkboxTheme: _checkboxTheme(),
    sliderTheme: _sliderTheme(),
    appBarTheme: _appBarTheme(),
    iconTheme: _iconThemeSized(),
    iconButtonTheme: _iconButtonTheme(),
    tooltipTheme: _tooltipTheme(),
    snackBarTheme: _snackBarTheme(),
    dividerTheme: _dividerTheme(),
    dialogTheme: _dialogTheme(),
    bottomSheetTheme: _bottomSheetTheme(),
    bottomNavigationBarTheme: _bottomNavigationBarTheme(),
    extensions: [layout],
  );
}
