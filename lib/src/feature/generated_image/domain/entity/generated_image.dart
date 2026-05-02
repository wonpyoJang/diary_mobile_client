import 'dart:io';

import 'package:diary_mobile_client/src/core/media/domain/entity/media_info.dart';
import 'package:equatable/equatable.dart';

class GeneratedImage extends Equatable {
  final String id;
  final String momentId;
  final String path;
  final MimeType mimeType;
  final DateTime createdAt;
  final File file;

  const GeneratedImage({
    required this.id,
    required this.momentId,
    required this.path,
    required this.mimeType,
    required this.createdAt,
    required this.file,
  });

  @override
  List<Object?> get props => [id, momentId, path, mimeType, createdAt, file];
}
