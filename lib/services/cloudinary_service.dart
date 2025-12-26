import 'dart:typed_data';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  static const String cloudName = 'dq9kvvhtf';
  static const String uploadPreset = 'figure_gallery';

  final CloudinaryPublic cloudinary = CloudinaryPublic(
    cloudName,
    uploadPreset,
    cache: false,
  );

  Future<List<String>> uploadImages(List<XFile> images) async {
    List<String> imageUrls = [];

    for (var image in images) {
      try {
        Uint8List bytes = await image.readAsBytes();

        ByteData byteData = bytes.buffer.asByteData();

        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromByteData(
            byteData,
            identifier: image.name,
            folder: "action_figures",
            resourceType: CloudinaryResourceType.Image,
          ),
        );
        imageUrls.add(response.secureUrl);
      } catch (e) {
        print("Upload Error for ${image.name}: $e");
      }
    }
    return imageUrls;
  }
}
