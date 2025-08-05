import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:image/image.dart' as img;

class LLMQuery {
  final String direction;
  final String context;
  final String data;
  final String outputDirection;
  final String outputExample;
  final List<File> medias;

  LLMQuery({
    required this.direction,
    required this.context,
    required this.data,
    required this.outputDirection,
    required this.outputExample,
    required this.medias,
  });

  String toPrompt() {
    return """
    [지시문]
    $direction
    $outputDirection

    [컨텍스트]
    $context

    [입력 데이터]
    $data

    [출력 예시]
    $outputExample""";
  }

  Future<List<InlineDataPart>> getImageParts() async {
    return await Future.wait(medias.map((e) async {
      final image = await File(e.path).readAsBytes();
      // 파일의 매직넘버(헤더)를 읽어서 이미지 타입을 추론하는 함수

      final resizedImage = await _resizeImage(image);

      final mimeType = _detectMimeType(resizedImage);
      final imagePart = InlineDataPart(mimeType, resizedImage);
      return imagePart;
    }));
  }

  Future<Uint8List> _resizeImage(Uint8List image) async {
    // 이미지 디코딩
    final decoded = img.decodeImage(image);
    if (decoded == null) {
      // 디코딩 실패 시 원본 반환
      return image;
    }
    // 리사이즈
    final resized = img.copyResize(decoded, width: 512, height: 512);
    // 포맷에 따라 인코딩 (여기서는 JPEG로 인코딩)
    final encoded = img.encodeJpg(resized);
    return encoded;
  }

  static String _detectMimeType(List<int> bytes) {
    if (bytes.length >= 4) {
      // JPEG: FF D8 FF
      if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
        return 'image/jpeg';
      }
      // PNG: 89 50 4E 47
      if (bytes[0] == 0x89 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x4E &&
          bytes[3] == 0x47) {
        return 'image/png';
      }
      // GIF: 47 49 46 38
      if (bytes[0] == 0x47 &&
          bytes[1] == 0x49 &&
          bytes[2] == 0x46 &&
          bytes[3] == 0x38) {
        return 'image/gif';
      }
      // WEBP: 52 49 46 46 ("RIFF") + "WEBP" at offset 8
      if (bytes.length >= 12 &&
          bytes[0] == 0x52 &&
          bytes[1] == 0x49 &&
          bytes[2] == 0x46 &&
          bytes[3] == 0x46 &&
          bytes[8] == 0x57 &&
          bytes[9] == 0x45 &&
          bytes[10] == 0x42 &&
          bytes[11] == 0x50) {
        return 'image/webp';
      }
      // BMP: 42 4D
      if (bytes[0] == 0x42 && bytes[1] == 0x4D) {
        return 'image/bmp';
      }
    }
    // 기본값
    return 'image/jpeg';
  }
}
