import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fluent_ui/fluent_ui.dart';
import 'package:gige_view/api/pylon.dart';
import 'package:provider/provider.dart';

import '../model/bmp_header.dart';
import '../model/grab_painter.dart';

class UINotifier extends ChangeNotifier {
  static UINotifier on(BuildContext context) =>
      Provider.of<UINotifier>(context, listen: true);
  static UINotifier of(BuildContext context) =>
      Provider.of<UINotifier>(context, listen: false);
  final BMPHeader header = BMPHeader(2592, 2048);
  GrabPainter? painter;

  void imageUpdate(Pointer<Uint8> ptr) async {
    final Uint8List bytes = header.appendBitmap(ptr.asTypedList(2592 * 2048));
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);

    painter = GrabPainter(image: (await codec.getNextFrame()).image);

    notifyListeners();
  }
}
