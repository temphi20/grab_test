import 'package:fluent_ui/fluent_ui.dart';

import 'dart:ui' as ui;

class GrabPainter extends CustomPainter {
  GrabPainter({required this.image}) : super();
  ui.Image image;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawImage(image, Offset.zero, ui.Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
