class LLMResponse {
  final String prompt;
  final Map<String, dynamic> response;
  final String? error;

  LLMResponse({
    required this.prompt,
    required this.response,
    this.error,
  });
}
