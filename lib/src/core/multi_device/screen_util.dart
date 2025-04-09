import 'package:flutter/material.dart';

class ScreenUtil {
  static double tabletWidthTreshold = 600;
  static double desktopWidthTreshold = 840;

  static double getWidth(BuildContext context,
      {required double phone, double? tablet, double? desktop}) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final isLandscape = deviceWidth > deviceHeight;

    if (deviceWidth > desktopWidthTreshold) {
      return desktop ?? tablet ?? phone;
    }

    if (deviceWidth > tabletWidthTreshold) {
      return tablet ?? phone;
    }

    return phone;
  }

  static double getHeight(BuildContext context,
      {required double phone, double? tablet, double? desktop}) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final isLandscape = deviceWidth > deviceHeight;

    if (deviceWidth > desktopWidthTreshold) {
      return desktop ?? tablet ?? phone;
    }

    if (deviceHeight > tabletWidthTreshold) {
      return tablet ?? phone;
    }

    return phone;
  }
}
