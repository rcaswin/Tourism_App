import 'package:flutter/material.dart';

class TextSizeScaler {
  static double scaleTextSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    double referenceScreenWidth = 375.0;
    double screenWidthRatio = screenWidth / referenceScreenWidth;
    return baseSize * screenWidthRatio;
  }
}

class ImageSizeScaler {
  static double scaleImageSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    double referenceScreenWidth = 375.0;
    double screenWidthRatio = screenWidth / referenceScreenWidth;
    return baseSize * screenWidthRatio;
  }
}

class IconSizeScaler {
  static double scaleIconSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    double referenceScreenWidth = 375.0;
    double screenWidthRatio = screenWidth / referenceScreenWidth;
    return baseSize * screenWidthRatio;
  }
}

class ResponsivePadding {
  static EdgeInsets fromLTRB(BuildContext context, double left, double top,
      double right, double bottom) {
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingFactor = screenWidth / 375.0;

    double scaledLeft = left * paddingFactor;
    double scaledTop = top * paddingFactor;
    double scaledRight = right * paddingFactor;
    double scaledBottom = bottom * paddingFactor;

    return EdgeInsets.fromLTRB(
        scaledLeft, scaledTop, scaledRight, scaledBottom);
  }
}

class ResponsiveMargin {
  static EdgeInsets fromLTRB(BuildContext context, double left, double top,
      double right, double bottom) {
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingFactor = screenWidth / 375.0;

    double scaledLeft = left * paddingFactor;
    double scaledTop = top * paddingFactor;
    double scaledRight = right * paddingFactor;
    double scaledBottom = bottom * paddingFactor;

    return EdgeInsets.fromLTRB(
        scaledLeft, scaledTop, scaledRight, scaledBottom);
  }
}

class SliderMediaQueryService {
  final BuildContext context;

  SliderMediaQueryService(this.context);

  double get screenHeight => MediaQuery.of(context).size.height;
  double get screenWidth => MediaQuery.of(context).size.width;
  double get textScaleFactor => MediaQuery.of(context).textScaleFactor;
  double get platformBrightness =>
      MediaQuery.platformBrightnessOf(context).index == 1 ? 1.0 : 0.0;
}

class ContainerScaler {
  static double getContainerWidth(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    double referenceScreenWidth = 375.0;
    double screenWidthRatio = screenWidth / referenceScreenWidth;
    return baseSize * screenWidthRatio;
  }

  static double getContainerHeight(BuildContext context, double baseSize) {
    double screenHeight = MediaQuery.of(context).size.height;
    double referenceScreenHeight = 375.0;
    double screenHeightRatio = screenHeight / referenceScreenHeight;
    return baseSize * screenHeightRatio;
  }
}
