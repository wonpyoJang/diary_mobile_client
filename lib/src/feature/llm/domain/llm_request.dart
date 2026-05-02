import 'package:equatable/equatable.dart';

import 'llm_image_part.dart';

class LlmRequest extends Equatable {
  final String prompt;
  final String? systemInstruction;
  final int? maxTokens;
  final double? temperature;
  final List<LlmImagePart>? images;

  const LlmRequest({
    required this.prompt,
    this.systemInstruction,
    this.maxTokens,
    this.temperature,
    this.images,
  });

  @override
  List<Object?> get props =>
      [prompt, systemInstruction, maxTokens, temperature, images];
}
