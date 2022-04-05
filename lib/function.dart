import 'package:flutter/foundation.dart';

void kPrint(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}
