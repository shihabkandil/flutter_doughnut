import 'dart:math';

import 'package:flutter/material.dart';

import 'chart_util.dart';

class Doughnut extends StatelessWidget {
  final double size;
  final String selectedKey;
  final List<Sector> data;
  final bool lowHardwareMode;

  const Doughnut({
    Key? key,
    this.size = 300,
    required this.data,
    this.lowHardwareMode = false,
    required this.selectedKey,
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
              painter: PieChartPainter(sectors: data),
            ),
          ),
        ],
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final List<Sector> sectors;

  PieChartPainter({
    required this.sectors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius =
        ((size.width > size.height ? size.height : size.width) / 2);
    final center = Point(size.width / 2, size.height / 2);

    final roundedArcRadius = radius;

    ChartUtil.init(
      center: center,
      radius: roundedArcRadius,
      width: roundedArcRadius / 1.8,
    );

    double startRadian = -pi / 2;
    for (int index = 0; index < sectors.length; index++) {
      final innerPath = Path();
      double value = sectors[index].value;

      double sectorRadian = (sectors[index].value / 100) * 2 * pi;

      ChartUtil(
        startRadian: startRadian,
        sweepRadian: sectorRadian,
      ).drawRoundedArc(innerPath, value);

      final paint = Paint()..color = sectors[index].color;
      innerPath.close();
      final updatedPath = ChartUtil.combineWithCenterCircle(innerPath)..close();
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
