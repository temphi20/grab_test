import 'package:flutter/material.dart';

import 'api/pylon.dart';
import 'pages/grab_page.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Pylon.instance.initialize();
  runApp(const App());
}
