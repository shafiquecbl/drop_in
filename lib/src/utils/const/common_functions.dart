import 'dart:ui';

import '../../../src_exports.dart';

Future<Uint8List> getMarker(String path, [int targetHeight = 80]) async {
  ByteData data = await rootBundle.load(path);
  final codec = await instantiateImageCodec(
    data.buffer.asUint8List(),
    targetHeight: targetHeight,
  );
  FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ImageByteFormat.png))!
      .buffer
      .asUint8List();
}
