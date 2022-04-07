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

final void Function() grabCall =
    func.lookup<NativeFunction<Void Function()>>('grab_call').asFunction();
// final void Function(int) testFunc =
//     func.lookup<NativeFunction<Void Function(Int32)>>('test').asFunction();
final void Function(Pointer<NativeFunction<IntPtr Function(Pointer<Uint8>)>>)
    setCallback = func
        .lookup<
                NativeFunction<
                    Void Function(
                        Pointer<
                            NativeFunction<IntPtr Function(Pointer<Uint8>)>>)>>(
            'SetCallbackFunction')
        .asFunction();
