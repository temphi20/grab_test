import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class Pylon with ChangeNotifier {
  static Pylon on(BuildContext context) => Provider.of<Pylon>(context);
  static Pylon of(BuildContext context) =>
      Provider.of<Pylon>(context, listen: false);
  Uint8List? imageUList;

  void imageUpdate(Uint8List bData) {
    imageUList = bData;
    notifyListeners();
  }

  void imageTerminate() {
    imageUList = null;
    notifyListeners(); //must be inserted
  }
}
