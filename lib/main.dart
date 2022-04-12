import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'func.dart';
import 'page.dart';

void main() async {
  runApp(const MyApp());
  Get.put(Controller());
  WidgetsFlutterBinding.ensureInitialized();
  initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pylon Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GrabPage(),
    );
  }
}
