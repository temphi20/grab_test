import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../api/pylon.dart';
import '../function.dart';
import '../notifier/ui_notifier.dart';

BuildContext? buildContext;

class GrabPage extends StatelessWidget {
  const GrabPage({Key? key}) : super(key: key);

  void grabOne(UINotifier uiNotifier) async {
    try {
      final Pointer<Uint8> result = calloc.allocate(2592 * 2048);
      Pylon.instance.grabOne(result);
      uiNotifier.imageUpdate(result);
    } catch (e) {
      kPrint('grab: $e');
    }
  }

  void grabRetrieve() {
    kPrint('in call');
    Pylon.instance.grabRetrieve();
    // Pylon.instance.setCallback();

    // Timer.periodic(
    //   const Duration(milliseconds: 10),
    //   (timer) {
    //     uiNotifier.imageUpdate(Pylon.instance.getResultGlobal());
    //   },
    // );
    // kPrint('set timer');
  }

  // void grabRetrieve(UINotifier uiNotifier) async {
  //   kPrint('in call');
  //   Pylon.instance.grabRetrieve();
  //   // Pylon.instance.setCallback();

  //   // Timer.periodic(
  //   //   const Duration(milliseconds: 10),
  //   //   (timer) {
  //   //     uiNotifier.imageUpdate(Pylon.instance.getResultGlobal());
  //   //   },
  //   // );
  //   // kPrint('set timer');
  // }

  void read(UINotifier uiNotifier) {
    Timer.periodic(
      const Duration(milliseconds: 10),
      (timer) {
        uiNotifier.imageUpdate(Pylon.instance.getResultGlobal());
      },
    );
    kPrint('set timer');
  }

  void grabCallback(BuildContext context) async {
    buildContext = context;
    Pylon.instance.setCallback(
        Pointer.fromFunction<IntPtr Function(Pointer<Uint8>)>(callback, 0));
    kPrint('set callback');
    Pylon.instance.grabCallback();
  }

  static int callback(Pointer<Uint8> ptr) {
    kPrint('callback [${ptr.asTypedList(10).elementAt(0)}]');
    if (buildContext != null) {
      UINotifier.of(buildContext!).imageUpdate(ptr);
    }
    return 0;
  }

  void stop() {
    kPrint('stop btn click');

    Pylon.instance.stop();
    Pylon.instance.close();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Pylon.instance.terminate();
        return true;
      },
      child: NavigationView(
        appBar: const NavigationAppBar(),
        pane: NavigationPane(
          scrollController: ScrollController(),
          items: [
            PaneItemAction(
              icon: const Icon(FluentIcons.camera),
              title: const Text('한 장 찍기'),
              onTap: () => grabOne(UINotifier.of(context)),
            ),
            PaneItemAction(
              icon: const Icon(FluentIcons.timer),
              title: const Text('타이머 테스트 시작'),
              onTap: grabRetrieve,
              // onTap: () => grabRetrieve(UINotifier.of(context)),
            ),
            PaneItemAction(
              icon: const Icon(FluentIcons.read),
              title: const Text('타이머 읽기 시작'),
              onTap: () => read(UINotifier.of(context)),
            ),
            PaneItemAction(
              icon: const Icon(FluentIcons.video),
              title: const Text('콜백 테스트 시작'),
              onTap: () => grabCallback(context),
            ),
            PaneItemAction(
              icon: const Icon(FluentIcons.stop),
              title: const Text('정지'),
              onTap: stop,
            ),
          ],
        ),
        content: NavigationBody(
          index: 0,
          children: [
            SizedBox(
              width: Pylon.width,
              height: Pylon.height,
              child: CustomPaint(
                painter: UINotifier.on(context).painter,
                size: const Size(2592, 2048),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
