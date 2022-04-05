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
  // 2592 * 2048
  // 5308416 bit
  // 663552 byte
  // 00 51 00 00
  // 00 0a 20 00
  // file size와 image size가 1078만큼 차이남(file size가 더 큼)
  final List<int> bmpHeader = [
    0x42, // 0
    0x4D, // 1
    , // 2 file size (byte)
    ,
    ,
    ,
    0x00, // 6
    0x00,
    0x00, // 8
    0x00,
    0, // 10 start offset (byte)
    0,
    0,
    0, /// 여기까지 BMP 헤더
    0, // 14 header size (40byte)
    0,
    0,
    0,
 0x20   , // 18 width (픽셀, signed integer) -> 속성 - 이미지 너비와 동일
    0x0a,
    0x00,
    0x00,
    0x00    , // 22 height (픽셀, signed integer) -> 속성 - 이미지 높이와 동일
    0x08,
    0x00,
    0x00,
    0x01, // 26 사용하는 색 판의 수 - 1로 고정
    0x00,
    0x08, // 28 비트 수준
    0x00,
     0x00, // 30 압축 방식
    0x00 ,
   0x00  ,
   0x00  ,
    0x00,// 34 그림 크기(압축되지 않은 비트맵 데이터의 크기), 파일 크기와 다른 개념? -> 너비x높이 값과 같음
    0x20,
    0x0a,
    0x00,
         0x00 , // 38 가로 해상도
     0x00 ,
     0x00 ,
    0x00  ,
     0x00     , // 42 세로 해상도
    0x00  ,
     0x00 ,
    0x00  ,
         0x00 , // 46 색 팔레트의 색 수
      0x00,
     0x00 ,
      0x00,
        0x00  , // 50 중요한 색의 수
    0x00  ,
     0x00 ,
     0x00 , /// 여기까지 DIB 헤더

  ];

  List<Uint8List> ulists = [];
  Uint8List? ulist;
  int i = 0;

  void grap() async {
    final Pointer<Uint8> result = calloc.allocate(5308416);
    grabTest(result);
    kPrint(result);
      final Uint8List bmp256 = Uint8List.fromList(bmpHeader);
      bmp256.addAll(result.asTypedList(663552)) ;
    // kPrint();
    setState(() {
      ulist = bmp256;
    });
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
            TextButton(onPressed: grap, child: const Text('GRAB TEST')),
            if (ulist != null)
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
