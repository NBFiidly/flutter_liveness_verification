import 'dart:ui';

import 'package:flutter/material.dart';

class FaceAreaWidget extends StatelessWidget {
  const FaceAreaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: FaceAreaClipper(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          color: Colors.black.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}

class FaceAreaClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final rectPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final holePath = Path()
      ..addOval(
        Rect.fromPoints(
          Offset(size.width * 0.1, size.height * 0.2),
          Offset(size.width * 0.9, size.height * 0.7),
        ),
      );

    return Path.combine(PathOperation.difference, rectPath, holePath);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
