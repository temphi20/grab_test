import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ffi/ffi.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';

import 'bmp_header.dart';
import 'func.dart';
import 'function.dart';

late Isolate isolate;
late SendPort sendPort;

class GrabPage extends StatefulWidget {
  const GrabPage({Key? key}) : super(key: key);

  @override
  State<GrabPage> createState() => _GrabPageState();
}

class _GrabPageState extends State<GrabPage> {
  static BMPHeader header = BMPHeader(2592, 2048);
  Uint8List? bytes;
  Uint8List preBytes = BMPHeader(2592, 2048)
      .appendBitmap(Uint8List.fromList(List.filled(2592 * 2048, 0)));
  bool _isRead = false, _isStop = false;
  // final Uint8List bytes = Uint8List(1078 + 2592 * 2048);

  // void imageUpdate(Uint8List bytes) {
  //   setState(() {
  //     bytes = bytes;
  //   });
  // }

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

      // memoryImage.load();
      setState(() {
        // bytes.setAll(0, memoryImage.bytes);
        bytes = memoryImage.bytes;
      });
      // imageUpdate(memoryImage.bytes);
    } catch (e) {
      kPrint('grab: $e');
    }
  }

  void test() async {
    kPrint('in call');
    grabSync();
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      kPrint([timer.tick]);
      if (_isStop) {
        timer.cancel();
      }
      if (_isRead) {
        setState(() {
          bytes =
              header.appendBitmap(getResultGlobal().asTypedList(2592 * 2048));
        });
      }
    });
    kPrint('set timer');
  }

  void background() async {
    try {
      kPrint('in call');
      final ReceivePort receivePort = ReceivePort();
      isolate = await Isolate.spawn(run, receivePort.sendPort);
      kPrint('isolate set');

      // final FilePickerResult? result = await FilePicker.platform
      //     .pickFiles(allowMultiple: true, withData: true);

      receivePort.listen((val) {
        if (val is SendPort) {
          sendPort = val;
          kPrint('port open');
        } else if (val is Uint8List) {
          setState(() {
            bytes = val;
          });
        }
        //   else if (val is int) {
        //     kPrint('<< $val');
        //     final Uint8List tmp =
        //         Uint8List.fromList(result!.files[val].bytes!.toList());
        //     setState(() {
        //       // if (bytes == null) {
        //       //   bytes = result!.files[val].bytes;
        //       // } else {
        //       // bytes!.clear();

        //       bytes = tmp;
        //       // bytes!.addAll(result!.files[val].bytes!.toList());
        //       // }
        //       // if (result != null) bytes.addAll(iterable) = .;
        //     });
        //   }
      });
      kPrint('end');
    } catch (e) {
      kPrint('background: $e');
    }
  }

  static void run(SendPort sPort) async {
    final ReceivePort rPort = ReceivePort();
    sPort.send(rPort.sendPort);

    // final Pointer<Uint8> ptr = calloc(2592 * 2048);
    bool isRead = false, isStop = false;
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, withData: true);

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      kPrint([timer.tick]);
      if (isStop) {
        timer.cancel();
        rPort.close();
      }
      if (isRead) {
        // final start = DateTime.now();
        // kPrint('test - ${DateTime.now().difference(start)}');
        // sPort.send(timer.tick % 9);
        sPort.send(
            header.appendBitmap(getResultGlobal().asTypedList(2592 * 2048)));
        // kPrint('in timer - ${DateTime.now().difference(start)}');
        // getResult(ptr);
        // sPort.send(
        //     MemoryImage(header.appendBitmap(ptr.asTypedList(2592 * 2048))));
      }
      if (result != null) {
        sPort.send(result.files[timer.tick % 9].bytes);
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

  void testRead() {
    kPrint('read btn click');
    _isRead = true;
    kPrint('success send');
  }

  void testStop() {
    kPrint('stop btn click');
    _isRead = false;
    _isStop = true;
    stop();
    close();
  }

  void startRead() {
    kPrint('read btn click');
    kPrint('start send');
    // setState(() {
    _isRead = true;
    // });
    sendPort.send({"isRead": true});
    kPrint('success send');
  }

  void isolateStop() {
    kPrint('stop btn click');
    _isStop = false;
    sendPort.send({"isRead": false, "isStop": true});
    stop();
    close();
    isolate.kill(priority: Isolate.immediate);
  }

  void filePicker() async {
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, withData: true);

    Timer.periodic(const Duration(milliseconds: 20), (timer) {
      kPrint([timer.tick]);

      final Uint8List tmp =
          Uint8List.fromList(result!.files[timer.tick % 9].bytes!.toList());
      setState(() {
        // if (bytes == null) {
        //   bytes = result!.files[val].bytes;
        // } else {
        // bytes!.clear();

        bytes = tmp;
        // bytes!.addAll(result!.files[val].bytes!.toList());
        // }
        // if (result != null) bytes.addAll(iterable) = .;
      });

      // if (result != null) {
      //   setState(() {
      //     bytes = result.files[timer.tick % 9].bytes;
      //   });
      // }
    });
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
                  onPressed: background, child: const Text('GRAB START')),
              TextButton(
                  onPressed: test, child: const Text('GRAB START (TEST)')),
              TextButton(
                  onPressed: testRead, child: const Text('START READ (TEST)')),
              TextButton(onPressed: testStop, child: const Text('STOP (TEST)')),
              TextButton(onPressed: startRead, child: const Text('START READ')),
              TextButton(onPressed: isolateStop, child: const Text('STOP')),
              TextButton(
                  onPressed: filePicker, child: const Text('Picker Test')),
              TextButton(onPressed: grab, child: const Text('GRAB ONE')),
              if (bytes != null)
                SizedBox(
                  width: 2592 * 0.4,
                  height: 2048 * 0.4,
                  child: Image.memory(bytes!),
                ),
              // RawImage(
              //   image: ,
              // )
              // if (Pylon.on(context).imagebytes != null)
              //   RawImage(image: Pylon.on(context).imagebytes!),
            ],
          ),
        ),
      ),
    );
  }
}
