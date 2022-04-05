import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:test/function.dart';

import 'func.dart';

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
  // final List<CameraDescription> cameras = [];
  // CameraDescription? camera;
  // final int cIdx = 0;
  // int cameraId = -1;
  // Size? preview;

  // func(int i) {
  //   kPrint('register callback');
  //   kPrint(i);
  // }

  // void dll() async {
  //   // kPrint(func);
  //   // callFunc(func);
  //   // startFunc(13);
  //   // final int intRet = intFunc(10);
  //   // kPrint('$intRet');
  //   // final double doubleRet = doubleFunc(4);
  //   // kPrint('$doubleRet');
  //   // final double floatRet = floatFunc(10);
  //   // kPrint('$floatRet');
  //   // // String str = 'hello world';
  //   // // Pointer<Utf8>()
  //   // // Allocator();
  //   // Pointer<Utf8>(); == char*
  //   // Pointer<Utf16>
  //   // // Pointer<Utf8> char = calloc.allocate(32);
  //   // final char = 'wgs'.toNativeUtf8();

  //   // final Pointer<Utf8> charRet = charFunc(char);
  //   // kPrint(charRet.toDartString());

  //   final Pointer<Utf8> cptr = 'hello'.toNativeUtf8();
  //   final Pointer<Utf8> cRet = charFunc(cptr);
  //   kPrint(cRet.toDartString());

  //   // Pointer<Utf16> str = calloc.allocate(32);
  //   // str = 'WGS'.toNativeUtf16();
  //   // // final Pointer<Utf16> strRet = stringFunc(str);
  //   // // kPrint('$charRet');
  //   // // kPrint(charRet.toDartString());
  //   // // kPrint('$strRet');
  //   // // kPrint(strRet.toDartString());
  //   // [0, 0, 0 , 0]
  //   // [234432, -234324 ,435432534 , 2343254]
  //   // final Pointer<Int32> ptr = calloc.allocate(4);
  //   // malloc.allocate(4);

  //   // // // final Pointer<Bool> ptr2 = calloc.allocate(4);

  //   // ptr.asTypedList(8).fillRange(0, 2, 10);
  //   // // kPrint(ptr.value);
  //   // // kPrint(ptr.address);
  //   // kPrint('${ptr.asTypedList(8)}');
  //   // kPrint(ptr.elementAt(1).value);
  //   // kPrint(ptr.elementAt(2).value);
  //   // // ptr.elementAt(2) = 3;
  //   // ptrFunc(ptr);
  //   // kPrint('$ptr');
  //   // Int32List list = ptr.asTypedList(8);
  //   // kPrint(list);
  // }

  // void dll2() async {
  //   Pointer<Utf8> char = calloc.allocate(32);
  //   char = 'wgs'.toNativeUtf8();
  //   final Pointer<Utf8> cRet = charFunc(char);
  //   kPrint(cRet.toDartString());
  // }

  // void plugin() async {
  //   try {
  //     const String method0 = 'plugins.flutter.io/camera';
  //     const String method1 = 'flutter.io/cameraPlugin/device';
  //     const MethodChannel channel = MethodChannel(method0);
  //     kPrint('suc channel');
  //     channel.setMethodCallHandler((MethodCall call) async {
  //       kPrint(call);
  //       return await handleDeviceMethodCall(call);
  //     });
  //     final ret = await channel
  //         .invokeListMethod<Map<dynamic, dynamic>>('availableCameras');
  //     kPrint(ret);
  //   } catch (e) {
  //     kPrint(e);
  //   }
  // }

  // Future<dynamic> handleDeviceMethodCall(MethodCall call) async {
  //   kPrint('in handle: $call');
  //   switch (call.method) {
  //     case 'orientation_changed':
  //       //   deviceEventStreamController.add(DeviceOrientationChangedEvent(
  //       //       deserializeDeviceOrientation(
  //       //           call.arguments['orientation']! as String)));
  //       break;
  //     default:
  //       throw MissingPluginException();
  //   }
  // }

  // void fetch() async {
  //   try {
  //     cameras.clear();
  //     cameras.addAll(await CameraPlatform.instance.availableCameras());
  //     kPrint('${cameras.length}: $cameras');
  //   } catch (e) {
  //     kPrint(e);
  //   }
  // }

  // void load() async {
  //   try {
  //     cameras.clear();
  //     const r = '\u005c';
  //     const String devicePath =
  //         'usb#vid_13d3&pid_5405&mi_00#6&140c2090&1&0000#';
  //     const String un = '{e5323777-f976-4f5b-9b55-b94699c46e44}';
  //     final description = CameraDescription(
  //       name:
  //           'Integrated Camera2 <$r$r?$r$devicePath${un.toLowerCase()}${r}global>',
  //       // name:
  //       //     'Integrated Camera2 <$r$r?$r$devicePath${un.toLowerCase()}${r}global>',
  //       lensDirection: CameraLensDirection.front,
  //       sensorOrientation: 0,
  //     );

  //     // {e5323777-f976-4f5b-9b55-b94699c46e44}\global <-이게 뭘 뜻하는??

  //     // const String devicePath = 'usb#vid_0bda&pid_8153#001000001#';
  //     // const String un = '{e5323777-f976-4f5b-9b55-b94699c46e44}';
  //     // final description = CameraDescription(
  //     //   name:
  //     //       'Realtek USB GbE Family Controller <$r$r?$r$devicePath${un.toLowerCase()}${r}global>',
  //     //   lensDirection: CameraLensDirection.external,
  //     //   sensorOrientation: 0,
  //     // );
  //     cameras.insert(0, description);
  //     kPrint('${cameras.length}: $cameras');
  //   } catch (e) {
  //     kPrint(e);
  //   }
  // }

  // void init() async {
  //   try {
  //     if (cameras.isEmpty) {
  //       kPrint('fetch 먼저');
  //       return;
  //     }

  //     camera = cameras[cIdx];
  //     cameraId = await CameraPlatform.instance
  //         .createCamera(camera!, ResolutionPreset.max);
  //     kPrint('id: $cameraId');

  //     CameraPlatform.instance.onCameraError(cameraId).listen((event) {
  //       kPrint(event.description);
  //     });
  //     CameraPlatform.instance.onCameraClosing(cameraId).listen((event) {
  //       kPrint(event.cameraId);
  //     });

  //     final Future<CameraInitializedEvent> initialized =
  //         CameraPlatform.instance.onCameraInitialized(cameraId).first;

  //     await CameraPlatform.instance.initializeCamera(cameraId);
  //     final CameraInitializedEvent event = await initialized;

  //     setState(() {
  //       preview = Size(event.previewWidth, event.previewHeight);
  //     });
  //   } on CameraException catch (e) {
  //     kPrint(e);
  //     kPrint(e.description);
  //   }
  // }

  // void disposed() async {
  //   try {
  //     setState(() {
  //       preview = null;
  //       camera == null;
  //     });
  //     await CameraPlatform.instance.dispose(cameraId);
  //     cameraId = -1;
  //   } catch (e) {
  //     kPrint(e);
  //   }
  // }

  void grap() async {
    Uint8List.bytesPerElement;
    final Pointer<Uint8> result = grapTest();
    if (result != null) {
      // kPrint(result.files);
      setState(() {
        // for (var file in result.files) {
        ulists.addAll(result.files.map((e) => e.bytes!));
        // }
        // ulist = result.files[0].bytes;
      });

      kPrint('success');
      // kPrint(ulists);

      Timer.periodic(Duration(milliseconds: 10), (timer) {
        setState(() {
          ulist = ulists[i];
          kPrint((i + 1) % ulists.length);
          i = (i + 1) % ulists.length;

          kPrint('${timer.tick} / $i');
        });
      });
    }
  }

  void picker() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      // withReadStream: true,
      allowedExtensions: ['jpg', 'png', 'bmp'],
    );
    // File file = result.files[0].readStream;
    if (result != null) {
      // kPrint(result.files);
      setState(() {
        // for (var file in result.files) {
        ulists.addAll(result.files.map((e) => e.bytes!));
        // }
        // ulist = result.files[0].bytes;
      });

      kPrint('success');
      // kPrint(ulists);

      Timer.periodic(Duration(milliseconds: 10), (timer) {
        setState(() {
          ulist = ulists[i];
          kPrint((i + 1) % ulists.length);
          i = (i + 1) % ulists.length;

          kPrint('${timer.tick} / $i');
        });
      });
    }
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
            // TextButton(onPressed: dll, child: const Text('dll')),
            // TextButton(onPressed: dll2, child: const Text('dll2')),
            TextButton(onPressed: grap, child: const Text('GRAP TEST')),
            TextButton(onPressed: picker, child: const Text('가져오기')),
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
