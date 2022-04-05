import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

import 'func.dart';
import 'function.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Uint8List> ulists = [];
  Uint8List? ulist;
  int i = 0;

  void grap() async {
    Uint8List.bytesPerElement;
    final Pointer<Uint8> result = calloc.allocate(5308416);
    grabTest(result);
    kPrint(result);
    kPrint(result.asTypedList(663552));
    // width 2592
    // height 2048

    // setState(() {
    //   ulists.addAll(result.files.map((e) => e.bytes!));
    // });

    kPrint('success');

    // Timer.periodic(Duration(milliseconds: 10), (timer) {
    //   setState(() {
    //     ulist = ulists[i];
    //     kPrint((i + 1) % ulists.length);
    //     i = (i + 1) % ulists.length;

    //     kPrint('${timer.tick} / $i');
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          controller: ScrollController(),
          physics: const ScrollPhysics(),
          children: <Widget>[
            TextButton(onPressed: grap, child: const Text('GRAP TEST')),
            if (ulists.isNotEmpty && ulist != null)
              SizedBox(
                height: 720,
                width: 1280,
                child: Image.memory(ulist!),
              ),
          ],
        ),
      ),
    );
  }
}
