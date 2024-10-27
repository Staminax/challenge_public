import 'dart:ui';

import 'package:flutter/material.dart';

class HeartBeatAnimation extends StatefulWidget {
  const HeartBeatAnimation({super.key});

  @override
  HeartBeatAnimationState createState() => HeartBeatAnimationState();
}

class HeartBeatAnimationState extends State<HeartBeatAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _HeartbeatPainter(progress: controller.value),
          size: Size(MediaQuery.of(context).size.width, 150),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }
}

class _HeartbeatPainter extends CustomPainter {
  final double progress;

  _HeartbeatPainter({required this.progress});

  @override
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final gradient = const LinearGradient(
      colors: [Colors.red, Colors.pinkAccent, Colors.redAccent],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(Rect.fromLTWH(0, 0, width, height));

    final linePaint = Paint()
      ..shader = gradient
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final shadowPaint = Paint()
      ..color = Colors.redAccent.withOpacity(0.5)
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final path = Path();
    path.moveTo(0, height / 2);
    path.lineTo(width * 0.1, height / 2);
    path.lineTo(width * 0.15, height / 4);
    path.lineTo(width * 0.2, height / 2);
    path.lineTo(width * 0.3, height / 2);
    path.lineTo(width * 0.35, height * 0.6);
    path.lineTo(width * 0.4, height / 2);
    path.lineTo(width * 0.5, height / 2);
    path.lineTo(width * 0.55, height / 3);
    path.lineTo(width * 0.6, height / 2);
    path.lineTo(width * 0.7, height / 2);
    path.lineTo(width * 0.75, height * 0.4);
    path.lineTo(width * 0.8, height / 2);
    path.lineTo(width * 0.9, height / 2);
    path.lineTo(width, height / 2);

    canvas.drawPath(path, shadowPaint);

    canvas.drawPath(path, linePaint);

    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.first;
    final pathLength = pathMetric.length;
    final double dotPosition = pathLength * progress;

    Tangent? tangent = pathMetric.getTangentForOffset(dotPosition);
    if (tangent != null) {
      final position = tangent.position;

      final dotShadowPaint = Paint()..color = Colors.redAccent.withOpacity(0.5);
      final dotPaint = Paint()..shader = gradient;

      canvas.drawCircle(position, 8, dotShadowPaint);
      canvas.drawCircle(position, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
