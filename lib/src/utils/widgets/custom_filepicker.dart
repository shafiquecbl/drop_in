import 'package:image_cropper/image_cropper.dart';

import '../../../src_exports.dart';

class PickImages {
  static Future<File> pickImages() async {
    File imagePath = File('');
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      final rawImage = File(result.files.single.path!);
      final foo = await _cropImage(rawImage.path);
      if (foo.path.isNotEmpty) {
        imagePath = foo;
      }
    }
    return imagePath;
  }

  static Future<File> _cropImage(String img) async {
    CroppedFile? croppedfile = await ImageCropper().cropImage(
      sourcePath: img,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop your image',
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          toolbarColor: AppColors.appButtonColor,
        ),
        IOSUiSettings(
          title: 'Crop your image',
        )
      ],
    );

    if (croppedfile != null) {
      return File(croppedfile.path);
    } else {
      return File('');
    }
  }

  static Future<Uint8List?> pickImagesWeb() async {
    Uint8List? imagePath;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg'],
    );
    if (result != null) {
      imagePath = result.files.single.bytes!;
    }
    return imagePath;
  }
}
