import 'package:flutter/material.dart';

enum ScreenType { mobile, tablet, desktop }

/// Responsive helpers built on MediaQuery.
class Responsive {
  Responsive._();

  static const double tabletBreakpoint = 700;
  static const double desktopBreakpoint = 1100;
  static const double maxContentWidth = 1200;

  static ScreenType of(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= desktopBreakpoint) return ScreenType.desktop;
    if (width >= tabletBreakpoint) return ScreenType.tablet;
    return ScreenType.mobile;
  }

  static bool isMobile(BuildContext c) => of(c) == ScreenType.mobile;
  static bool isDesktop(BuildContext c) => of(c) == ScreenType.desktop;

  /// Horizontal padding that keeps content centred on very wide screens.
  static double horizontalPadding(double availableWidth) {
    final extra = (availableWidth - maxContentWidth) / 2;
    return (extra > 0 ? extra : 0) + 16;
  }

  /// Number of grid columns for a given available width.
  static int gridColumns(double availableWidth) {
    final cols = (availableWidth / 320).floor();
    if (cols < 1) return 1;
    if (cols > 4) return 4;
    return cols;
  }
}
