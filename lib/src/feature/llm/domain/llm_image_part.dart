import 'dart:typed_data';
import 'package:equatable/equatable.dart';

class LlmImagePart extends Equatable {
  final Uint8List bytes;
  final String mimeType; // 'image/jpeg', 'image/png', etc.

  const LlmImagePart({required this.bytes, required this.mimeType});

  @override
  List<Object?> get props => [bytes, mimeType];
}
