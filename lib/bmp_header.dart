import 'dart:typed_data';

class BMPHeader {
  int _width; // NOTE: width must be multiple of 4 as no account is made for bitmap padding
  int _height;

  late Uint8List _bmp;
  late int _totalHeaderSize;

  BMPHeader(this._width, this._height) : assert(_width & 3 == 0) {
    int baseHeaderSize = 54;
    _totalHeaderSize = baseHeaderSize + 1024;

    int fileLength = _totalHeaderSize + _width * _height;
    _bmp = Uint8List(fileLength);
    ByteData bd = _bmp.buffer.asByteData();
    bd.setUint8(0, 0x42);
    bd.setUint8(1, 0x4d);
    bd.setUint32(2, fileLength, Endian.little); // file length
    bd.setUint32(10, _totalHeaderSize, Endian.little); // start of the bitmap
    bd.setUint32(14, 40, Endian.little); // info header size
    bd.setUint32(18, _width, Endian.little);
    bd.setUint32(22, _height, Endian.little);
    bd.setUint16(26, 1, Endian.little); // planes
    bd.setUint32(28, 8, Endian.little); // bpp
    bd.setUint32(30, 0, Endian.little); // compression
    bd.setUint32(34, _width * _height, Endian.little); // bitmap size
    // leave everything else as zero

    // there are 256 possible variations of pixel
    // build the indexed color map that maps from packed byte to RGBA32
    // better still, create a lookup table see: http://unwind.se/bgr233/
    for (int rgb = 0; rgb < 256; rgb++) {
      int offset = baseHeaderSize + rgb * 4;

      int red = rgb & 0xe0;
      int green = rgb << 3 & 0xe0;
      int blue = rgb & 6 & 0xc0;

      bd.setUint8(offset + 3, 255); // A
      bd.setUint8(offset + 2, red); // R
      bd.setUint8(offset + 1, green); // G
      bd.setUint8(offset, blue); // B
    }
  }

  /// Insert the provided bitmap after the header and return the whole BMP
  Uint8List appendBitmap(Uint8List bitmap) {
    int size = _width * _height;
    assert(bitmap.length == size);
    _bmp.setRange(_totalHeaderSize, _totalHeaderSize + size, bitmap);
    return _bmp;
  }
}