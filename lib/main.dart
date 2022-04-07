import 'dart:async';
import 'dart:ffi';
import 'dart:io' as IO;
import 'dart:isolate';
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

late Isolate isolate;
late SendPort sendPort;
late Timer timer;
bool isStop = false;

// int callback(Pointer<Uint8> result) {
//   kPrint('success callback');
//   // kPrint(uintPtr);
//   final MemoryImage memoryImage = MemoryImage(
//       BMPHeader(2592, 2048).appendBitmap(result.asTypedList(2592 * 2048)));

//   kPrint('memory image succeed');
//   return 0;
// }

class MyHomePage extends StatelessWidget {
  void grab() async {
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

  // static void _grabCall() {
  //   setCallback(
  //       Pointer.fromFunction<IntPtr Function(Pointer<Uint8>)>(callback, 0));
  //   kPrint('set callback end');
  //   grabCall();
  // }

  void call(Pylon of) async {
    try {
      kPrint('in call');
      final ReceivePort receivePort = ReceivePort();
      kPrint(receivePort.hashCode);
      isolate = await Isolate.spawn(run, receivePort.sendPort);
      kPrint('isolate set');

      receivePort.listen((val) {
        kPrint(val);
        if (val is SendPort) {
          sendPort = val;
        } else {
          of.imageUpdate(val);
        }
      });
      kPrint('callback end');
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
    // kPrint(receivePort.hashCode);
    // receivePort.sendPort.send(memoryImage.bytes);

    return 0;
  }

  static void run(SendPort sPort) {
    final ReceivePort rPort = ReceivePort();
    sPort.send(rPort.sendPort);

    setCallback(
        Pointer.fromFunction<IntPtr Function(Pointer<Uint8>)>(callback, 0));

    // setCallback(Pointer.fromFunction<IntPtr Function(Pointer<Uint8>)>(
    //     (Pointer<Uint8> result) {
    //   kPrint('success callback');
    //   // kPrint(uintPtr);
    //   final MemoryImage memoryImage = MemoryImage(
    //       BMPHeader(2592, 2048).appendBitmap(result.asTypedList(2592 * 2048)));

    //   kPrint('memory image succeed');
    //   sPort.send(memoryImage.bytes);
    //   return 0;
    // }, 0));
    kPrint('set callback end');
    grabCall();
    timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      sPort.send(message);
    });

    rPort.listen((val) {
      kPrint(val);
    });
  }

  static void isolateStop() {
    // timer.cancel();
    stop();
    isolate.kill(priority: Isolate.immediate);
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
            TextButton(onPressed: isolateStop, child: const Text('STOP')),
            TextButton(onPressed: close, child: const Text('CLOSE')),
            TextButton(
                onPressed: () => call(Pylon.of(context)),
                child: const Text('CALLBACK')),
            TextButton(onPressed: grab, child: const Text('GRAB ONE')),
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
