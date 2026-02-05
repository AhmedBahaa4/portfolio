import 'package:flutter/widgets.dart';

class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double maxContentWidth = 1100;
}

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < Breakpoints.mobile;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= Breakpoints.mobile && width < Breakpoints.tablet;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= Breakpoints.tablet;

  static EdgeInsets pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width < Breakpoints.mobile ? 16.0 : 24.0;
    final vertical = width < Breakpoints.mobile ? 16.0 : 24.0;
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }
}
