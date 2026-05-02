import 'package:equatable/equatable.dart';

class LlmRequest extends Equatable {
  final String prompt;
  final String? systemInstruction;
  final int? maxTokens;
  final double? temperature;

  const LlmRequest({
    required this.prompt,
    this.systemInstruction,
    this.maxTokens,
    this.temperature,
  });

  @override
  List<Object?> get props => [prompt, systemInstruction, maxTokens, temperature];
}
