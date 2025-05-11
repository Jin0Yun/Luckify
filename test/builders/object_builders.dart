import 'package:luckify/domain/entity/message_entity.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/entity/request_entity.dart';
import 'package:luckify/domain/entity/response_entity.dart';
import 'package:luckify/domain/entity/choice_entity.dart';
import 'package:luckify/domain/enum/message_sender.dart';
import 'package:luckify/domain/enum/fortune_type.dart';
import 'package:luckify/data/dto/request_dto.dart';
import 'package:luckify/data/dto/response_dto.dart';
import 'package:luckify/data/dto/message_dto.dart';
import 'package:luckify/data/dto/choice_dto.dart';
import '../unit/core/constants/test_constants.dart';

abstract final class ObjectBuilders {
  static MessageEntity message({
    String? id,
    String? content,
    MessageSender? sender,
    DateTime? timestamp,
  }) {
    return MessageEntity(
      id: id ?? TestConstants.testId,
      content: content ?? TestConstants.fortuneContent,
      sender: sender ?? MessageSender.assistant,
      timestamp: timestamp ?? TestConstants.testDate,
    );
  }

  static FortuneEntity fortune({
    int? id,
    String? name,
    FortuneType? type,
  }) {
    return FortuneEntity(
      id: id ?? TestConstants.fortuneId,
      name: name ?? (type == FortuneType.fortuneToday ? '오늘의 운세' : '별자리 운세'),
      type: type ?? FortuneType.zodiacFortune,
    );
  }

  static RequestEntity request({
    String? model,
    List<MessageEntity>? messages,
    FortuneEntity? fortune,
    String? userInput,
  }) {
    return RequestEntity(
      model: model ?? TestConstants.gptModel,
      messages: messages ?? [],
      fortune: fortune,
      userInput: userInput,
    );
  }

  static ResponseEntity responseEntity({
    String? id,
    String? object,
    DateTime? created,
    String? model,
    List<ChoiceEntity>? choices,
    String? content,
  }) {
    final message = content != null
        ? ObjectBuilders.message(content: content)
        : ObjectBuilders.message();

    final defaultChoices = [ChoiceEntity(index: 0, message: message)];

    return ResponseEntity(
      id: id ?? TestConstants.testId,
      object: object ?? 'chat.completion',
      created: created ?? TestConstants.testDate,
      model: model ?? TestConstants.gptModel,
      choices: choices ?? defaultChoices,
    );
  }

  static ResponseEntity emptyResponseEntity({
    String? id,
    String? object,
    DateTime? created,
    String? model,
  }) {
    return ResponseEntity(
      id: id ?? TestConstants.testId,
      object: object ?? 'chat.completion',
      created: created ?? TestConstants.testDate,
      model: model ?? TestConstants.gptModel,
      choices: [],
    );
  }

  static ChoiceEntity choice({
    int? index,
    MessageEntity? message,
  }) {
    return ChoiceEntity(
      index: index ?? 0,
      message: message ?? ObjectBuilders.message(),
    );
  }

  static RequestDTO requestDTO({
    String? model,
    List<MessageDTO>? messages,
  }) {
    return RequestDTO(
      model: model ?? TestConstants.gptModel,
      messages: messages ?? [messageDTO()],
    );
  }

  static ResponseDTO responseDTO({
    String? id,
    String? object,
    int? created,
    String? model,
    List<ChoiceDTO>? choices,
    String? content,
  }) {
    final defaultChoice = ChoiceDTO(
      index: 0,
      message: messageDTO(content: content),
    );

    return ResponseDTO(
      id: id ?? TestConstants.testId,
      object: object ?? 'chat.completion',
      created: created ?? TestConstants.testTimestamp,
      model: model ?? TestConstants.gptModel,
      choices: choices ?? [defaultChoice],
    );
  }

  static MessageDTO messageDTO({
    String? role,
    String? content,
  }) {
    return MessageDTO(
      role: role ?? 'assistant',
      content: content ?? TestConstants.fortuneContent,
    );
  }

  static ChoiceDTO choiceDTO({
    int? index,
    MessageDTO? message,
  }) {
    return ChoiceDTO(
      index: index ?? 0,
      message: message ?? messageDTO(),
    );
  }
}