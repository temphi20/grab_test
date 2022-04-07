import 'dart:async';
import 'dart:ffi';
import 'dart:io' as IO;
import 'dart:ui' as UI;
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bmp_header.dart';
import 'func.dart';
import 'function.dart';
import 'pylon.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
}

BuildContext? pContext;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Pylon>(create: (context) {
          pContext = context;
          return Pylon();
        })
      ],
      child: MaterialApp(
        title: 'Pylon Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  void grap() async {
    try {
      // kPrint(const Color(0xffad2300).value);
      final Pointer<Uint8> result = calloc.allocate(2592 * 2048);
      final int size = grabOne(result);
      kPrint(size);
      kPrint(result);
      final MemoryImage memoryImage = MemoryImage(
          BMPHeader(2592, 2048).appendBitmap(result.asTypedList(2592 * 2048)));
      kPrint('memory image succeed');
    } catch (e) {
      kPrint(e);
    }
  }

  static int callback(Pointer<Uint8> result) {
    kPrint('success callback');
    // kPrint(uintPtr);
    final MemoryImage memoryImage = MemoryImage(
        BMPHeader(2592, 2048).appendBitmap(result.asTypedList(2592 * 2048)));

    kPrint('memory image succeed');
    // String? output = await FilePicker.platform.saveFile();
    // if (output != null) {
    //   IO.File('$output-row').writeAsBytes(result.asTypedList(2592 * 2048));
    //   IO.File(output).writeAsBytes(memoryImage.bytes);
    // }
    Pylon.of(pContext!).imageUpdate(memoryImage.bytes);
    return 0;
  }

  static void _grabCall(_) {
    setCallback(
        Pointer.fromFunction<IntPtr Function(Pointer<Uint8>)>(callback, 0));
    kPrint('set callback end');
    grabCall();
  }

  void call() async {
    try {
      await compute(_grabCall, null);
      kPrint('callback end');
    } catch (e) {
      kPrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    pContext = context;
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   title: Text(widget.title),
      // ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          controller: ScrollController(),
          physics: const ScrollPhysics(),
          children: <Widget>[
            TextButton(onPressed: initialize, child: const Text('INITIALIZE')),
            TextButton(onPressed: terminate, child: const Text('TERMINATE')),
            TextButton(onPressed: stop, child: const Text('STOP')),
            TextButton(onPressed: close, child: const Text('CLOSE')),
            TextButton(onPressed: call, child: const Text('CALLBACK TEST')),
            TextButton(onPressed: grap, child: const Text('GRAB TEST')),
            if (Pylon.on(context).imageUList != null)
              SizedBox(
                height: 720,
                width: 1280,
                child: Image.memory(Pylon.on(context).imageUList!),
              ),
            // if (Pylon.on(context).imageUList != null)
            //   RawImage(image: Pylon.on(context).imageUList!),
          ],
        ),
      ),
    );
  }
}
