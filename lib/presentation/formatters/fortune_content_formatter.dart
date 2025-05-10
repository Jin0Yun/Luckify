import 'package:luckify/domain/entity/request_entity.dart';

abstract class FortuneContentFormatter {
  String format(String content, RequestEntity request);
}

class FortuneContentFormatterImpl implements FortuneContentFormatter {
  @override
  String format(String content, RequestEntity request) {
    if (request.fortune == null) return content;

    if (request.fortune!.requiresUserInput && request.userInput != null) {
      return "🌟 ${request.userInput}의 운세 🌟\n\n$content";
    } else {
      return "✨ 오늘의 운세 ✨\n\n$content";
    }
  }
}
