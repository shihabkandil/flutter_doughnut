import 'dart:math';

import 'package:flutter/foundation.dart';
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
    final clipper = _PieChartClipper(data: data);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: _PieShadowPainter(clipper: clipper, shadows: [
              BoxShadow(
                  offset: const Offset(-3, -3),
                  blurRadius: 10,
                  color: Colors.white.withOpacity(.3)),
              const BoxShadow(
                  offset: Offset(3, 3), blurRadius: 10, color: Colors.black87),
            ]),
            child: SizedBox(
                width: size,
                height: size,
                child: ClipPath(
                  clipper: clipper,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF303336),
                          Color(0xFF222427),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
          SizedBox(
            width: size,
            height: size,
            child: ClipPath(
              clipper: _PieChartClipper(
                data: data,
              ),
              child: Container(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}

class _PieChartClipper extends CustomClipper<Path> {
  final List<Sector> data;

  final double innerPadding = .1;
  final double outerPadding = 20;

  _PieChartClipper({
    required this.data,
  });

  @override
  Path getClip(Size size) {
    final double radius =
        ((size.width > size.height ? size.height : size.width) / 2);
    final center = Point(size.width / 2, size.height / 2);

    final roundedArcRadius = radius - outerPadding;

    final outerPath = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(center.x, center.y), radius: radius),
      )
      ..close();

    ChartUtil.init(
      center: center,
      radius: roundedArcRadius,
      width: roundedArcRadius / 1.8,
    );

    final innerPath = Path();

    double start = 0;

    double value = data.first.value;

    double radian = (value / 100) * 2 * pi;
    double startRadian = start + innerPadding;
    double sweepRadian = radian;

    ChartUtil(
      startRadian: startRadian,
      sweepRadian: sweepRadian,
    ).drawRoundedArc(innerPath, value);
    innerPath.close();
    return ChartUtil.combineWithCenterCircle(innerPath)..close();
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class _PieShadowPainter extends CustomPainter {
  final List<Shadow> shadows;
  final CustomClipper<Path> clipper;

  _PieShadowPainter({
    required this.shadows,
    required this.clipper,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var shadow in shadows) {
      var paint = shadow.toPaint();
      var clipPath = clipper.getClip(size).shift(shadow.offset);
      canvas.drawPath(clipPath, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => kDebugMode;
}

class Sector {
  final Key? key;
  final double value;

  Sector({this.key, required this.value});
}
