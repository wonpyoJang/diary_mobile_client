import 'dart:io';

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
}
