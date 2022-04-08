import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

final DynamicLibrary func = DynamicLibrary.open('func.dll');

// Uint8ClampedList
final int Function(Pointer<Uint8>) grabOne = func
    .lookup<NativeFunction<Uint32 Function(Pointer<Uint8>)>>('grab_one')
    .asFunction();

final void Function() initialize =
    func.lookup<NativeFunction<Void Function()>>('initialize').asFunction();
final void Function() terminate =
    func.lookup<NativeFunction<Void Function()>>('terminate').asFunction();
final void Function() close =
    func.lookup<NativeFunction<Void Function()>>('close').asFunction();
final void Function() stop =
    func.lookup<NativeFunction<Void Function()>>('stop').asFunction();

final void Function() grabSync =
    func.lookup<NativeFunction<Void Function()>>('grab_sync').asFunction();
final void Function(Pointer<Uint8>) getResult = func
    .lookup<NativeFunction<Void Function(Pointer<Uint8>)>>('get_result')
    .asFunction();
final Pointer<Uint8> Function() getResultGlobal = func
    .lookup<NativeFunction<Pointer<Uint8> Function()>>('get_result_global')
    .asFunction();
