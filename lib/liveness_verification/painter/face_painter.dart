import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_liveness_verification/liveness_verification/utils/utils.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;
  final CameraLensDirection lensDirection;
  final bool isCentered;

  FacePainter({
    super.repaint,
    required this.faces,
    required this.imageSize,
    required this.lensDirection,
    required this.isCentered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isCentered ? Colors.green : Colors.red
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final boxPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (final face in faces) {
      final rect = Utils.normalizeRect(
        rect: face.boundingBox,
        lensDirection: lensDirection,
        imageSize: imageSize,
        widgetSize: size,
      );

      // face position
      canvas.drawRect(rect, paint);

      // center face position
      canvas.drawCircle(rect.center, 1, paint);

      // center screen
      canvas.drawRect(
        Rect.fromLTRB(
          size.width * 0.2,
          size.height * 0.2,
          size.width * 0.8,
          size.height * 0.8,
        ),
        boxPaint,
      );

      textPainter.text = TextSpan(text: "id: ${face.trackingId}");
      textPainter.layout();
      textPainter.paint(canvas, Offset(rect.left, rect.top - 18));
    }
  }

  @override
  bool shouldRepaint(covariant FacePainter oldDelegate) {
    return oldDelegate.faces != faces ||
        oldDelegate.imageSize != imageSize ||
        oldDelegate.lensDirection != lensDirection;
  }
}
