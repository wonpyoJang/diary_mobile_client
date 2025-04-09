import 'package:flutter/material.dart';

class ScreenUtil {
  static double tabletWidthTreshold = 600;
  static double desktopWidthTreshold = 840;

  static double? getAdaptiveSize(BuildContext context,
      {double? phone, double? tablet, double? desktop}) {
    final deviceOrientation = MediaQuery.of(context).orientation;
    final isLandscape = deviceOrientation == Orientation.landscape;

    final deviceWidthWhenPortrait = isLandscape
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;

    if (deviceWidthWhenPortrait > desktopWidthTreshold) {
      return desktop;
    }

    if (deviceWidthWhenPortrait > tabletWidthTreshold) {
      return tablet;
    }

    return phone;
  }

  static bool isLandscape(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final isWidthGreaterThanHeight = deviceWidth > deviceHeight;
    final deviceOrientation = MediaQuery.of(context).orientation;

    if (deviceOrientation == Orientation.landscape) {
      return true;
    }

    return isWidthGreaterThanHeight;
  }
}
