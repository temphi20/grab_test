import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Notifier extends ChangeNotifier {
  static Notifier on(BuildContext context) => Provider.of<Notifier>(context);
  static Notifier of(BuildContext context) =>
      Provider.of<Notifier>(context, listen: false);

  Uint8List bytes = Uint8List(1078 + 2592 * 2048);

  void imageUpdate(Uint8List _bytes) {
    bytes.setAll(0, _bytes);
    // = _bytes;
    notifyListeners();
  }
}
