import 'package:equatable/equatable.dart';

enum LlmFailureKind {
  unavailable,
  modelNotDownloaded,
  deviceNotSupported,
  networkError,
  generationError,
  unknown,
}

class LlmFailure extends Equatable {
  final String message;
  final LlmFailureKind kind;

  const LlmFailure({required this.message, required this.kind});

  @override
  List<Object?> get props => [message, kind];
}
