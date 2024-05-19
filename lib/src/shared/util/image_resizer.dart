import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageResizer {
  ImageResizer._();
  static Uint8List resize(Uint8List imageBytes) {
    img.Image? originalImage = img.decodeImage(imageBytes);

    if (originalImage != null) {
      img.Image resizedImage = img.copyResize(originalImage, width: 960, height: 540);
      return img.encodeJpg(resizedImage);
    }

    return Uint8List.fromList([]);
  }
}
