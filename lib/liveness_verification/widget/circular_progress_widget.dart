import 'dart:math' as math;

import 'package:flutter/material.dart';

class CircularProgressWidget extends StatefulWidget {
  const CircularProgressWidget({
    super.key,
    required this.value,
    required this.color,
  });

  final double value;
  final Color color;

  @override
  State<CircularProgressWidget> createState() => _CircularProgressWidgetState();
}

class _CircularProgressWidgetState extends State<CircularProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  double _oldValue = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animation = Tween(
      begin: 0.0,
      end: widget.value,
    ).animate(_animationController);

    _animationController.forward();
  }

  @override
  void didUpdateWidget(covariant CircularProgressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _oldValue = oldWidget.value;

      _animation = Tween(begin: _oldValue, end: widget.value).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );

      _animationController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return CustomPaint(
            painter: CircularProgressPainter(
              value: _animation.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double value;
  final Color color;

  CircularProgressPainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.stroke;

    final rect = Rect.fromPoints(
      Offset(size.width * 0.1, size.height * 0.2),
      Offset(size.width * 0.9, size.height * 0.7),
    );

    _drawStepArc(canvas, paint, rect, size);
  }

  void _drawStepArc(Canvas canvas, Paint paint, Rect rect, Size size) {
    const heightLine = 24;
    const widthLine = 4.0;

    final cx = rect.center.dx;
    final cy = rect.center.dy;

    // ellipse radius
    final rx = rect.width / 2;
    final ry = rect.height / 2;

    final draw = 360 * value;
    final step = 360 / 100;

    for (double i = 0; i < 360; i += step) {
      // final rad = i * math.pi / 180;
      final rad = (i - 90) * math.pi / 180;

      final isActive = i < draw;

      // outer & inner ellipse (so lines have thickness outward)
      final innerRx = rx + 8;
      final innerRy = ry + 8;

      final outerRx = rx + (isActive ? heightLine : heightLine / 2);
      final outerRy = ry + (isActive ? heightLine : heightLine / 2);

      //  point on inner ellipse
      final x1 = cx + innerRx * math.cos(rad);
      final y1 = cy + innerRy * math.sin(rad);

      //  point on outer ellipse
      final x2 = cx + outerRx * math.cos(rad);
      final y2 = cy + outerRy * math.sin(rad);

      canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        paint
          ..color = isActive ? color : Colors.grey
          ..strokeWidth = widthLine
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CircularProgressPainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
