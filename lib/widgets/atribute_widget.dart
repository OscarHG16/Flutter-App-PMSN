import 'package:flutter/material.dart';
import 'dart:math' as math;

// CustomPainter para dibujar el círculo de atributos
class AttributePainter extends CustomPainter {
  final double progressPercent;
  final double strokeWidth;
  final double filledStrokeWidth;

  late final Paint bgPaint;
  late final Paint strokeBgPaint;
  late final Paint strokeFilledPaint;

  AttributePainter({
    required this.progressPercent,
    this.strokeWidth = 5.5,
    this.filledStrokeWidth = 5.5,
  }) {
    // Inicialización de los pinceles para dibujar
    bgPaint = Paint()..color = Colors.white.withOpacity(0.25);
    strokeBgPaint = Paint()..color = const Color.fromARGB(255, 16, 82, 136);
    strokeFilledPaint = Paint()
      ..color = const Color.fromARGB(255, 190, 67, 67)
      ..style = PaintingStyle.stroke
      ..strokeWidth = filledStrokeWidth
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Dibujamos los círculos y el arco de progreso
    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawCircle(center, radius - strokeWidth, strokeBgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2)),
      -math.pi / 2,
      (progressPercent / 100) * math.pi * 2,
      false,
      strokeFilledPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Widget que usa el CustomPainter
class AttributeWidget extends StatelessWidget {
  final double size;
  final double progress;
  final Widget child;

  const AttributeWidget({
    super.key,
    required this.progress,
    this.size = 82,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AttributePainter(progressPercent: progress),
      size: Size(size, size),
      child: Container(
        padding: EdgeInsets.all(size / 3.8),
        width: size,
        height: size,
        child: child,
      ),
    );
  }
}
