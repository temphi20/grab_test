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
  initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider<Pylon>(create: (_) => Pylon())],
      child: MaterialApp(
        title: 'Pylon Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MyHomePage(),
      ),
    );
  }
}

late Isolate isolate;
late SendPort sendPort;

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
  static BMPHeader header = BMPHeader(2592, 2048);

  void grab(Pylon of) async {
    try {
      // kPrint(const Color(0xffad2300).value);
      final Pointer<Uint8> result = calloc.allocate(2592 * 2048);
      final int size = grabOne(result);
      kPrint(size);
      kPrint(result);
      final MemoryImage memoryImage = MemoryImage(
          BMPHeader(2592, 2048).appendBitmap(result.asTypedList(2592 * 2048)));
      kPrint('memory image succeed');
      of.imageUpdate(memoryImage.bytes);
    } catch (e) {
      kPrint(e);
    }
  }

  void background(Pylon of) async {
    try {
      kPrint('in call');
      final ReceivePort receivePort = ReceivePort();
      isolate = await Isolate.spawn(run, receivePort.sendPort);
      kPrint('isolate set');

      receivePort.listen((val) {
        if (val is SendPort) {
          sendPort = val;
          kPrint('port open');
        } else if (val is MemoryImage) {
          of.imageUpdate(val.bytes);
        }
      });
      kPrint('end');
    } catch (e) {
      kPrint(e);
    }
  }

  static void run(SendPort sPort) {
    final ReceivePort rPort = ReceivePort();
    sPort.send(rPort.sendPort);

    // final Pointer<Uint8> ptr = calloc(2592 * 2048);
    bool isRead = false, isStop = false;

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      kPrint(timer.tick);
      if (isStop) {
        timer.cancel();
        rPort.close();
      }
      if (isRead) {
        sPort.send(MemoryImage(
            header.appendBitmap(getResultGlobal().asTypedList(2592 * 2048))));
        // getResult(ptr);
        // sPort.send(
        //     MemoryImage(header.appendBitmap(ptr.asTypedList(2592 * 2048))));
      }
    });

    kPrint('set timer');
    rPort.listen((val) {
      kPrint("in listen");
      kPrint(val);
      if (val is Map) {
        final bool? _isStop = val["isStop"], _isRead = val["isRead"];
        if (_isStop != null) isStop = _isStop;
        if (_isRead != null) isRead = _isRead;
      }
    });

    grabSync();
    // kPrint('before grab');
    // _grabSync();
    // kPrint('start grab');
  }

  void startRead() {
    kPrint('read btn click');
    kPrint('start send');
    sendPort.send({"isRead": true});
    kPrint('success send');
  }

  void isolateStop() {
    kPrint('stop btn click');
    sendPort.send({"isRead": false, "isStop": true});
    stop();
    close();
    isolate.kill(priority: Isolate.immediate);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        terminate();
        return true;
      },
      child: Scaffold(
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
              // TextButton(onPressed: initialize, child: const Text('INITIALIZE')),
              // TextButton(onPressed: terminate, child: const Text('TERMINATE')),
              TextButton(
                onPressed: () => background(Pylon.of(context)),
                child: const Text('GRAB START'),
              ),
              TextButton(onPressed: startRead, child: const Text('START READ')),
              TextButton(onPressed: isolateStop, child: const Text('STOP')),
              TextButton(
                onPressed: () => grab(Pylon.of(context)),
                child: const Text('GRAB ONE'),
              ),
              // if (Pylon.on(context).imageUList != null)
              SizedBox(
                height: 720,
                width: 1280,
                child: Image.memory(Pylon.on(context).imageUList),
              ),
              // if (Pylon.on(context).imageUList != null)
              //   RawImage(image: Pylon.on(context).imageUList!),
            ],
          ),
        ),
      ),
    );
  }
}
