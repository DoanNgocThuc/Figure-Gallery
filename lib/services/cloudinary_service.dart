import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryService {
  static final String cloudName = dotenv.env['cloudName'] ?? " ";
  static final String uploadPreset = dotenv.env['uploadPreset'] ?? " ";

  static final String apiKey = dotenv.env['apiKey'] ?? " ";
  static final String apiSecret = dotenv.env['apiSecret'] ?? " ";

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
        debugPrint("Upload Error for ${image.name}: $e");
      }
    }
    return imageUrls;
  }

  Future<void> deleteImages(List<String> urls) async {
    for (String url in urls) {
      String? publicId = _getPublicIdFromUrl(url);
      if (publicId != null) {
        await _deleteSingleImage(publicId);
      }
    }
  }

  Future<void> _deleteSingleImage(String publicId) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    String paramsToSign = "public_id=$publicId&timestamp=$timestamp$apiSecret";

    var bytes = utf8.encode(paramsToSign);
    var digest = sha1.convert(bytes);
    String signature = digest.toString();

    final uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/destroy",
    );

    try {
      final response = await http.post(
        uri,
        body: {
          "public_id": publicId,
          "timestamp": timestamp.toString(),
          "api_key": apiKey,
          "signature": signature,
        },
      );

      if (response.statusCode == 200) {
        debugPrint("Deleted $publicId from Cloudinary");
      } else {
        debugPrint("Failed to delete Cloudinary image: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error deleting image: $e");
    }
  }

  String? _getPublicIdFromUrl(String url) {
    try {
      Uri uri = Uri.parse(url);
      List<String> segments = uri.pathSegments;

      int uploadIndex = segments.indexOf('upload');
      if (uploadIndex == -1 || uploadIndex + 2 >= segments.length) return null;

      List<String> idSegments = segments.sublist(uploadIndex + 2);
      String fullPath = idSegments.join('/');

      int dotIndex = fullPath.lastIndexOf('.');
      if (dotIndex != -1) {
        return fullPath.substring(0, dotIndex);
      }
      return fullPath;
    } catch (e) {
      debugPrint("Error parsing URL: $e");
      return null;
    }
  }
}
