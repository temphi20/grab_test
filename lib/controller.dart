import 'dart:typed_data';

import 'package:get/get.dart';

class Controller extends GetxController {
  static Controller get to => Get.find<Controller>();
  final Rx<Uint8List> bytes = Rx(Uint8List(0));

  void imageUpdate(Uint8List _bytes) {
    bytes(_bytes);
    bytes.refresh();
  }
}
