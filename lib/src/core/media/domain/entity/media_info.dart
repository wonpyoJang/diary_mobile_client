import 'dart:io';

import 'package:equatable/equatable.dart';

enum MimeType {
  imageJpeg(
    mimeTypeString: 'image/jpeg',
    fileExtension: '.jpg',
    isImage: true,
    isVideo: false,
    isAudio: false,
  ),
  imagePng(
    mimeTypeString: 'image/png',
    fileExtension: '.png',
    isImage: true,
    isVideo: false,
    isAudio: false,
  ),
  imageGif(
    mimeTypeString: 'image/gif',
    fileExtension: '.gif',
    isImage: true,
    isVideo: false,
    isAudio: false,
  ),
  imageWebp(
    mimeTypeString: 'image/webp',
    fileExtension: '.webp',
    isImage: true,
    isVideo: false,
    isAudio: false,
  ),
  videoMp4(
    mimeTypeString: 'video/mp4',
    fileExtension: '.mp4',
    isImage: false,
    isVideo: true,
    isAudio: false,
  ),
  videoMp3(
    mimeTypeString: 'audio/mpeg',
    fileExtension: '.mp3',
    isImage: false,
    isVideo: false,
    isAudio: true,
  );

  const MimeType({
    required this.mimeTypeString,
    required this.fileExtension,
    required this.isImage,
    required this.isVideo,
    required this.isAudio,
  });

  final String mimeTypeString;
  final String fileExtension;
  final bool isImage;
  final bool isVideo;
  final bool isAudio;

  /// MIME 타입 문자열을 MimeType enum으로 변환
  static MimeType fromMimeTypeString(String mimeTypeString) {
    final lowerMimeType = mimeTypeString.toLowerCase();

    for (final mimeType in MimeType.values) {
      if (mimeType.mimeTypeString == lowerMimeType) {
        return mimeType;
      }
    }

    // jpg/jpeg 별칭 처리
    if (lowerMimeType == 'image/jpg') {
      return MimeType.imageJpeg;
    }

    // mp3 별칭 처리
    if (lowerMimeType == 'audio/mp3') {
      return MimeType.videoMp3;
    }

    return MimeType.imageJpeg; // 기본값
  }

  /// MimeType enum을 MIME 타입 문자열로 변환
  String toMimeTypeString() => mimeTypeString;

  /// MimeType enum을 파일 확장자로 변환
  String toFileExtension() => fileExtension;

  /// MIME 타입 문자열을 파일 확장자로 변환
  static String getFileExtensionFromMimeType(String mimeType) {
    return fromMimeTypeString(mimeType).fileExtension;
  }

  /// 파일 확장자로부터 MIME 타입 문자열을 추출
  static String getMimeTypeFromExtension(String extension) {
    final ext = extension.toLowerCase();

    for (final mimeType in MimeType.values) {
      if (mimeType.fileExtension.substring(1) == ext) {
        return mimeType.mimeTypeString;
      }
    }

    // jpg/jpeg 별칭 처리
    if (ext == 'jpg' || ext == 'jpeg') {
      return MimeType.imageJpeg.mimeTypeString;
    }

    return 'application/octet-stream';
  }

  /// 파일 경로로부터 MIME 타입 문자열을 추출
  static String getMimeTypeFromPath(String path) {
    final extension = path.split('.').last;
    return getMimeTypeFromExtension(extension);
  }

  /// 이미지 타입인지 확인
  bool get isImageType => isImage;

  /// 비디오 타입인지 확인
  bool get isVideoType => isVideo;

  /// 오디오 타입인지 확인
  bool get isAudioType => isAudio;

  /// 미디어 타입별 그룹화
  static List<MimeType> get imageTypes =>
      MimeType.values.where((type) => type.isImage).toList();

  static List<MimeType> get videoTypes =>
      MimeType.values.where((type) => type.isVideo).toList();

  static List<MimeType> get audioTypes =>
      MimeType.values.where((type) => type.isAudio).toList();
}

class MediaInfo extends Equatable {
  final String id;
  final String momentId;
  final File? file;
  final MimeType mimeType;
  final DateTime createdAt;

  const MediaInfo({
    required this.id,
    required this.momentId,
    required this.file,
    required this.mimeType,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, momentId, file, mimeType, createdAt];
}
