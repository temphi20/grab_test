import 'dart:ffi';

class PylonMethod {
  PylonMethod();

  static final DynamicLibrary _dll = DynamicLibrary.open('func.dll');

  final int Function(Pointer<Uint8>) grabOne = _dll
      .lookup<NativeFunction<Uint32 Function(Pointer<Uint8>)>>('grab_one')
      .asFunction();

  final void Function() initialize =
      _dll.lookup<NativeFunction<Void Function()>>('initialize').asFunction();
  final void Function() terminate =
      _dll.lookup<NativeFunction<Void Function()>>('terminate').asFunction();
  final void Function() close =
      _dll.lookup<NativeFunction<Void Function()>>('close').asFunction();
  final void Function() stop =
      _dll.lookup<NativeFunction<Void Function()>>('stop').asFunction();

  final void Function() grabSync =
      _dll.lookup<NativeFunction<Void Function()>>('grab_sync').asFunction();
  final void Function(Pointer<Uint8>) getResult = _dll
      .lookup<NativeFunction<Void Function(Pointer<Uint8>)>>('get_result')
      .asFunction();
  final Pointer<Uint8> Function() getResultGlobal = _dll
      .lookup<NativeFunction<Pointer<Uint8> Function()>>('get_result_global')
      .asFunction();
}

class Pylon {
  Pylon();
  static PylonMethod instance = PylonMethod();
}
