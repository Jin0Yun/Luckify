import 'package:luckify/presentation/prompt/generators/fortune_prompt_generator.dart';
import 'package:luckify/domain/entity/request_entity.dart';
import 'package:luckify/domain/enum/fortune_type.dart';

abstract class PromptResolver {
  String resolvePrompt(RequestEntity request);
}

class FortunePromptResolver implements PromptResolver {
  final Map<FortuneType, FortunePromptGenerator> _generators;

  FortunePromptResolver(this._generators);

  @override
  String resolvePrompt(RequestEntity request) {
    if (request.fortune == null) {
      throw ArgumentError('Fortune type is required');
    }

    final generator = _generators[request.fortune!.type];
    if (generator == null) {
      throw ArgumentError('Unsupported fortune type: ${request.fortune!.type}');
    }

    return generator.generatePrompt(userInput: request.userInput);
  }
}