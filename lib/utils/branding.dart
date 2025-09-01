import 'package:flutter/material.dart';

/// Branding utility class for Quaestor app
/// Provides easy access to app logo and icon assets
class Branding {
  // Asset paths
  static const String logoLightPath = 'assets/logo_light.png';
  static const String logoDarkPath = 'assets/logo_dark.png';
  static const String appIconPath = 'assets/app_icon.png';

  // Logo widget with consistent sizing - automatically uses theme-appropriate logo
  static Widget logo({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    required BuildContext context,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final logoPath = isDarkMode ? logoDarkPath : logoLightPath;

    return Image.asset(
      logoPath,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }

  // App icon widget with consistent sizing
  static Widget appIcon({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
  }) {
    return Image.asset(
      appIconPath,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }

  // Standard logo sizes
  static const double logoSmall = 32.0;
  static const double logoMedium = 48.0;
  static const double logoLarge = 64.0;
  static const double logoXLarge = 96.0;

  // Standard app icon sizes
  static const double iconSmall = 24.0;
  static const double iconMedium = 32.0;
  static const double iconLarge = 48.0;

  // Predefined logo widgets - these now require context to be passed
  static Widget logoSmallWidget(BuildContext context) =>
      logo(width: logoSmall, height: logoSmall, context: context);
  static Widget logoMediumWidget(BuildContext context) =>
      logo(width: logoMedium, height: logoMedium, context: context);
  static Widget logoLargeWidget(BuildContext context) =>
      logo(width: logoLarge, height: logoLarge, context: context);
  static Widget logoXLargeWidget(BuildContext context) =>
      logo(width: logoXLarge, height: logoXLarge, context: context);

  // Predefined app icon widgets
  static Widget get iconSmallWidget =>
      appIcon(width: iconSmall, height: iconSmall);
  static Widget get iconMediumWidget =>
      appIcon(width: iconMedium, height: iconMedium);
  static Widget get iconLargeWidget =>
      appIcon(width: iconLarge, height: iconLarge);
}
