import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../api/pylon.dart';
import '../function.dart';
import '../notifier/ui_notifier.dart';

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

  void grabRe(UINotifier uiNotifier) async {
    kPrint('in call');
    Pylon.instance.grabSync();
    Timer.periodic(
      const Duration(milliseconds: 10),
      (timer) {
        uiNotifier.imageUpdate(Pylon.instance.getResultGlobal());
      },
    );
    kPrint('set timer');
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
              title: 'sdf',
              onTap: () => grabOne(UINotifier.of(context)),
            ),
            PaneItemAction(
              icon: const Icon(FluentIcons.video),
              title: 'sdf',
              onTap: () => grabRe(UINotifier.of(context)),
            ),
            PaneItemAction(
              icon: const Icon(FluentIcons.stop),
              title: '정지',
              onTap: stop,
            ),
          ],
        ),
        content: ListView(
          shrinkWrap: true,
          controller: ScrollController(),
          physics: const ScrollPhysics(),
          children: <Widget>[
            if (UINotifier.on(context).painter != null)
              SizedBox(
                width: 2592 * 0.4,
                height: 2048 * 0.4,
                child: CustomPaint(painter: UINotifier.on(context).painter),
              ),
          ],
        ),
      ),
    );
  }
}
