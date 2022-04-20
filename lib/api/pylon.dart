import 'dart:ffi';

class PylonMethod {
  PylonMethod();

  static final DynamicLibrary _dll = DynamicLibrary.open('func.dll');

  final int Function(Pointer<Uint8>) grabOne = _dll
      .lookup<NativeFunction<Uint32 Function(Pointer<Uint8>)>>('grab_one')
      .asFunction();
  final void Function() grabRetrieve = _dll
      .lookup<NativeFunction<Void Function()>>('grab_retrieve')
      .asFunction();

  final void Function(Pointer<NativeFunction<IntPtr Function(Pointer<Uint8>)>>)
      setCallback = _dll
          .lookup<
              NativeFunction<
                  Void Function(
                      Pointer<
                          NativeFunction<
                              IntPtr Function(
                                  Pointer<Uint8>)>>)>>('set_callback')
          .asFunction();
  final void Function() grabCallback = _dll
      .lookup<NativeFunction<Void Function()>>('grab_callback')
      .asFunction();

  final void Function() initialize =
      _dll.lookup<NativeFunction<Void Function()>>('initialize').asFunction();
  final void Function() terminate =
      _dll.lookup<NativeFunction<Void Function()>>('terminate').asFunction();
  final void Function() close =
      _dll.lookup<NativeFunction<Void Function()>>('close').asFunction();
  final void Function() stop =
      _dll.lookup<NativeFunction<Void Function()>>('stop').asFunction();

  // final void Function(Pointer<Uint8>) getResult = _dll
  //     .lookup<NativeFunction<Void Function(Pointer<Uint8>)>>('get_result')
  //     .asFunction();
  final Pointer<Uint8> Function() getResultGlobal = _dll
      .lookup<NativeFunction<Pointer<Uint8> Function()>>('get_result_global')
      .asFunction();
}

class Pylon {
  Pylon();
  static PylonMethod instance = PylonMethod();
  static double width = 2592;
  static double height = 2048;
}
