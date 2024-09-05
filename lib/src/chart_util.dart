import 'dart:math';
import 'package:flutter/material.dart';

class ChartUtil {
  static Point<double>? center;
  static double? radius;
  static double? width;

  final double startRadian;
  final double sweepRadian;

  ChartUtil({required this.startRadian, required this.sweepRadian});

  static init({
    required Point<double> center,
    required double radius,
    required double width,
  }) {
    ChartUtil.center = center;
    ChartUtil.radius = radius;
    ChartUtil.width = width;
  }

  Point radianPoint({double? radius, required double radian}) {
    return Point(center!.x + (radius ?? ChartUtil.radius!) * cos(radian),
        center!.y + (radius ?? ChartUtil.radius!) * sin(radian));
  }

  Offset get centerOffset => Offset(center!.x, center!.y);

  double get outerArcLength => (radius! * (sweepRadian - startRadian));

  double get innerArcLength =>
      ((radius! - width!) * (sweepRadian - startRadian));

  double percentageToRadians(double percentage) {
    // Convert percentage to degrees
    double degrees = percentage * pi;

    return degrees;
  }
  double degreesToRadius(double degrees, double size) {
    // Assuming 360 degrees correspond to the maximum possible radius,
    // which is half of the smallest dimension of the shape.
    double maxRadius = size / 2;

    // Convert degrees to percentage, where 360 degrees is 100%
    double percent = degrees / 360 * 100;

    // Calculate final radius from the given percentage
    return percent / 100 * maxRadius;
  }

  drawRoundedArc(Path path, double percentage) {
    double borderRadius = 40;

    double maxRadius = degreesToRadius(percentage * pi,100);

    print(maxRadius);

    if (borderRadius > maxRadius) {
      borderRadius = maxRadius;
    }

    final double verticalBorderRadiusValue = borderRadius;
    final double horizontalBorderRadiusValue = borderRadius / 100;

    if (ChartUtil.center != null) {
      final cornerA = Corner(
        center: ChartUtil.center!,
        radius: ChartUtil.radius!,
        radian: startRadian,
      );
      final cornerB = Corner(
        center: ChartUtil.center!,
        radius: ChartUtil.radius!,
        radian: startRadian + sweepRadian,
      );
      final cornerC = Corner(
        center: ChartUtil.center!,
        radius: ChartUtil.radius! - ChartUtil.width!,
        radian: sweepRadian + startRadian,
      );
      final cornerD = Corner(
        center: ChartUtil.center!,
        radius: ChartUtil.radius! - ChartUtil.width!,
        radian: startRadian,
      );

      final cornerAPoint = cornerA.point;
      final cornerAPoint1 =
          cornerA.move(radius: -verticalBorderRadiusValue).point;
      final cornerAPoint2 =
          cornerA.move(radian: horizontalBorderRadiusValue).point;

      path.moveTo(cornerAPoint2.x.toDouble(), cornerAPoint2.y.toDouble());

      path.arcTo(
          Rect.fromCircle(center: centerOffset, radius: radius!),
          startRadian + horizontalBorderRadiusValue,
          sweepRadian - (horizontalBorderRadiusValue * 2),
          false);

      final cornerBPoint = cornerB.point;
      final cornerBPoint2 =
          cornerB.move(radius: -verticalBorderRadiusValue).point;

      path.quadraticBezierTo(
        cornerBPoint.x.toDouble(),
        cornerBPoint.y.toDouble(),
        cornerBPoint2.x.toDouble(),
        cornerBPoint2.y.toDouble(),
      );

      final cornerCPoint = cornerC.point;
      final cornerCPoint1 =
          cornerC.move(radius: verticalBorderRadiusValue).point;
      final cornerCPoint2 =
          cornerC.move(radian: -horizontalBorderRadiusValue).point;

      path.lineTo(cornerCPoint1.x.toDouble(), cornerCPoint1.y.toDouble());

      path.quadraticBezierTo(
        cornerCPoint.x.toDouble(),
        cornerCPoint.y.toDouble(),
        cornerCPoint2.x.toDouble(),
        cornerCPoint2.y.toDouble(),
      );

      final cornerDPoint = cornerD.point;
      final cornerDPoint1 =
          cornerD.move(radian: horizontalBorderRadiusValue).point;
      final cornerDPoint2 =
          cornerD.move(radius: verticalBorderRadiusValue).point;

      path.lineTo(cornerDPoint1.x.toDouble(), cornerDPoint1.y.toDouble());

      path.quadraticBezierTo(
        cornerDPoint.x.toDouble(),
        cornerDPoint.y.toDouble(),
        cornerDPoint2.x.toDouble(),
        cornerDPoint2.y.toDouble(),
      );

      path.lineTo(cornerAPoint1.x.toDouble(), cornerAPoint1.y.toDouble());

      path.quadraticBezierTo(
        cornerAPoint.x.toDouble(),
        cornerAPoint.y.toDouble(),
        cornerAPoint2.x.toDouble(),
        cornerAPoint2.y.toDouble(),
      );
    }
  }

  static Path combineWithCenterCircle(Path path) {
    final centerCirclePath = Path();
    centerCirclePath.addOval(
      Rect.fromCircle(
        center: Offset(center!.x.toDouble(), center!.y.toDouble()),
        radius: radius! - width!,
      ),
    );
    centerCirclePath.close();
    return Path.combine(
      PathOperation.difference,
      path,
      centerCirclePath,
    );
  }
}

class Corner {
  final Point<double> center;
  final double radian;
  final double radius;

  Corner({required this.center, required this.radian, required this.radius});

  Point get point =>
      Point(center.x + radius * cos(radian), center.y + radius * sin(radian));

  Corner move({Point<double>? center, double? radian, double? radius}) {
    return Corner(
      center: center ?? this.center,
      radius: radius != null ? (this.radius + radius) : this.radius,
      radian: radian != null ? (this.radian + radian) : this.radian,
    );
  }
}
