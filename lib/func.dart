import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

final DynamicLibrary func = DynamicLibrary.open('func.dll');

// Uint8ClampedList
final void Function(Pointer<Uint8>) grabTest = func
    .lookup<NativeFunction<Void Function(Pointer<Uint8>)>>('grab_test')
    .asFunction();


// final int Function(int n) intFunc =
//     func.lookup<NativeFunction<Int32 Function(Int32)>>('int_func').asFunction();
// final double Function(double n) doubleFunc = func
//     .lookup<NativeFunction<Double Function(Double)>>('double_func')
//     .asFunction();
// final double Function(double n) floatFunc = func
//     .lookup<NativeFunction<Float Function(Float)>>('float_func')
//     .asFunction();
// final Pointer<Utf8> Function(Pointer<Utf8> n) charFunc = func
//     .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>)>>('char_func')
//     .asFunction();
// final Pointer<Utf16> Function(Pointer<Utf16> n) stringFunc = func
//     .lookup<NativeFunction<Pointer<Utf16> Function(Pointer<Utf16>)>>(
//         'string_func')
//     .asFunction();
// final void Function(Pointer<Int32> n) ptrFunc = func
//     .lookup<NativeFunction<Void Function(Pointer<Int32>)>>('ptr_func')
//     .asFunction();

// // typedef Callback = void Function(Pointer<NativeFunction>);
// // typedef NativeCallback = Void Function(Pointer<NativeFunction>);
// final void Function(Function(int)) callFunc = func
//     .lookup<NativeFunction<Void Function(Handle)>>('call_func')
//     .asFunction();

// // class HandleInt32 extends Handle on NativeType {

// // }

// final void Function(int) startFunc = func
//     .lookup<NativeFunction<Void Function(Int32)>>('start_func')
//     .asFunction();

// // final void Function(IntPtr n) ptr2Func = func
// //     .lookup<NativeFunction<Void Function(IntPtr)>>('ptr_func')
// //     .asFunction();
