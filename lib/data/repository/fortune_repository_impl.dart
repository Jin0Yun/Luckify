import 'package:luckify/data/network/network_client_interface.dart';
import 'package:luckify/presentation/formatters/fortune_content_formatter.dart';
import 'package:luckify/presentation/prompt/resolvers/prompt_resolver.dart';
import 'package:luckify/data/api/open_ai_chat_api.dart';
import 'package:luckify/data/dto/response_dto.dart';
import 'package:luckify/data/mapper/request_mapper.dart';
import 'package:luckify/data/mapper/response_mapper.dart';
import 'package:luckify/core/exceptions/fortune_exception.dart';
import 'package:luckify/core/utils/uuid_generator.dart';
import 'package:luckify/domain/entity/fortune_message_entity.dart';
import 'package:luckify/domain/entity/message_entity.dart';
import 'package:luckify/domain/entity/request_entity.dart';
import 'package:luckify/domain/enum/message_sender.dart';
import 'package:luckify/domain/repository/fortune_repository.dart';

class FortuneRepositoryImpl implements FortuneRepository {
  final NetworkClientInterface networkClient;
  final RequestMapper requestMapper;
  final ResponseMapper responseMapper;
  final UuidGenerator uuidGenerator;
  final String apiKey;
  final PromptResolver promptResolver;
  final FortuneContentFormatter contentFormatter;

  const FortuneRepositoryImpl({
    required this.networkClient,
    required this.requestMapper,
    required this.responseMapper,
    required this.uuidGenerator,
    required this.apiKey,
    required this.promptResolver,
    required this.contentFormatter,
  });

  @override
  Future<FortuneMessageEntity> getFortuneReading(RequestEntity request) async {
    try {
      final prompt = promptResolver.resolvePrompt(request);
      final promptMessage = MessageEntity(
        id: uuidGenerator.generate(),
        content: prompt,
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
      );

      final updatedRequest = RequestEntity(
        model: request.model,
        messages: [...request.messages, promptMessage],
        fortune: request.fortune,
        userInput: request.userInput,
      );

      final api = OpenAIChatApi(
        request: requestMapper.toDTO(updatedRequest),
        apiKey: apiKey,
      );

      final responseDTO = await networkClient.send<ResponseDTO>(
        api: api,
        fromJson: ResponseDTO.fromJson,
      );

      final responseEntity = responseMapper.toEntity(responseDTO);

      if (responseEntity.choices.isEmpty) {
        throw const FortuneException('운세 응답에 선택지가 없습니다.');
      }

      final messageContent = responseEntity.choices.first.message.content;
      final formattedContent = contentFormatter.format(messageContent, request);

      return FortuneMessageEntity(
        id: uuidGenerator.generate(),
        content: formattedContent,
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
        fortune: request.fortune,
        userInput: request.userInput,
      );
    } catch (e) {
      throw FortuneException('운세 조회 중 오류가 발생했습니다: $e');
    }
  }
}