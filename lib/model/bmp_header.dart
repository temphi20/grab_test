import 'dart:typed_data';

class BMPHeader {
  final int _width;
  final int _height;

  static const int baseHeaderSize = 54;
  static const int totalHeaderSize = baseHeaderSize + 1024;

  late Uint8List _bmp;
  late int imageSize;
  late int fileSize;

  BMPHeader(this._width, this._height) : assert(_width & 3 == 0) {
    imageSize = _width * _height;
    fileSize = totalHeaderSize + imageSize;
    _bmp = Uint8List(fileSize);

    final ByteData bData = _bmp.buffer.asByteData();

    bData.setUint8(0, 0x42);
    bData.setUint8(1, 0x4D);

    bData.setUint32(2, fileSize, Endian.little);
    bData.setUint32(10, totalHeaderSize, Endian.little);
    bData.setUint32(14, 40, Endian.little);

    bData.setUint32(18, _width, Endian.little);
    bData.setUint32(22, _height, Endian.little);
    bData.setUint16(26, 1, Endian.little);
    bData.setUint32(28, 8, Endian.little);
    bData.setUint32(30, 0, Endian.little);
    bData.setUint32(34, imageSize, Endian.little);

    for (int rgb = 0; rgb < 256; rgb++) {
      final int offset = baseHeaderSize + rgb * 4;

      bData.setUint8(offset + 3, 255); // A
      bData.setUint8(offset + 2, rgb); // R
      bData.setUint8(offset + 1, rgb); // G
      bData.setUint8(offset, rgb); // B
    }
  }

  Uint8List appendBitmap(Uint8List bitmap) {
    assert(bitmap.length == imageSize);
    _bmp.setRange(totalHeaderSize, fileSize, bitmap);
    return _bmp;
  }
}
