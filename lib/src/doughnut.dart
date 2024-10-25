import 'dart:math';
import 'package:flutter/material.dart';

import 'doughnut_painter.dart';

class Doughnut extends StatelessWidget {
  final double size;
  final String selectedKey;
  final List<Sector> data;
  final double borderRadius;

  const Doughnut({
    Key? key,
    this.size = 300,
    required this.data,
    required this.selectedKey,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: PieChartPainter(
                sectors: data,
                borderRadius: borderRadius,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<Sector> sectors;
  final double borderRadius;

  PieChartPainter({required this.borderRadius, required this.sectors});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius =
        ((size.width > size.height ? size.height : size.width) / 2);
    final center = Point(size.width / 2, size.height / 2);

    final roundedArcRadius = radius;

    double startRadian = -pi / 2;

    final doughnutPainter = DoughnutPainter(
      center: center,
      radius: radius,
      width: roundedArcRadius / 1.8,
      borderRadius: borderRadius,
    );

    for (int index = 0; index < sectors.length; index++) {
      final innerPath = Path();
      double sectorPercent = sectors[index].value / 100;

      double sectorRadian = sectorPercent * 2 * pi;

      doughnutPainter.drawRoundedArc(
        innerPath,
        settings: SectorSettings(
          sweepRadian: sectorRadian,
          startRadian: startRadian,
        ),
      );

      final paint = Paint()..color = sectors[index].color;
      innerPath.close();
      final updatedPath = doughnutPainter.combineWithCenterCircle(innerPath)
        ..close();
      canvas.drawPath(updatedPath, paint);

      startRadian += sectorRadian;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Sector {
  final Key? key;
  final double value;
  final Color color;

  Sector({this.key, required this.value, required this.color});
}
