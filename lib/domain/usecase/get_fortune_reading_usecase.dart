import 'package:luckify/core/constants/api_constants.dart';
import 'package:luckify/core/exceptions/fortune_exception.dart';
import 'package:luckify/core/utils/uuid_generator.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/entity/fortune_message_entity.dart';
import 'package:luckify/domain/entity/message_entity.dart';
import 'package:luckify/domain/entity/request_entity.dart';
import 'package:luckify/domain/enum/message_sender.dart';
import 'package:luckify/domain/repository/fortune_repository.dart';
import 'package:luckify/presentation/formatters/fortune_content_formatter.dart';
import 'package:luckify/presentation/prompt/resolvers/prompt_resolver.dart';

class GetFortuneReadingUseCase {
  final FortuneRepository _repository;
  final UuidGenerator _uuidGenerator;
  final PromptResolver _promptResolver;
  final FortuneContentFormatter _contentFormatter;

  GetFortuneReadingUseCase({
    required FortuneRepository repository,
    required UuidGenerator uuidGenerator,
    required PromptResolver promptResolver,
    required FortuneContentFormatter contentFormatter,
  })  : _repository = repository,
        _uuidGenerator = uuidGenerator,
        _promptResolver = promptResolver,
        _contentFormatter = contentFormatter;

  Future<FortuneMessageEntity> execute({
    required FortuneEntity fortune,
    required List<MessageEntity> messages,
    String? userInput,
    String model = ApiConstants.gpt4oMini,
  }) async {
    try {
      final originalRequest = RequestEntity(
        model: model,
        messages: messages,
        fortune: fortune,
        userInput: userInput,
      );

      final prompt = _promptResolver.resolvePrompt(originalRequest);

      final promptMessage = MessageEntity(
        id: _uuidGenerator.generate(),
        content: prompt,
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
      );

      final updatedRequest = RequestEntity(
        model: model,
        messages: [...messages, promptMessage],
        fortune: fortune,
        userInput: userInput,
      );

      final responseEntity = await _repository.fetchFortuneFromAPI(updatedRequest);

      if (responseEntity.choices.isEmpty) {
        throw FortuneException(FortuneError.emptyChoices);
      }

      final messageContent = responseEntity.choices.first.message.content;
      final formattedContent = _contentFormatter.format(messageContent, originalRequest);

      return FortuneMessageEntity(
        id: _uuidGenerator.generate(),
        content: formattedContent,
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
        fortune: fortune,
        userInput: userInput,
      );
    } catch (e) {
      if (e is FortuneException) {
        throw e;
      }
      throw FortuneException(FortuneError.unknown, e is Exception ? e : null);
    }
  }
}