import 'package:luckify/domain/entity/message_entity.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/entity/request_entity.dart';
import 'package:luckify/domain/enum/message_sender.dart';
import 'package:luckify/domain/enum/fortune_type.dart';
import 'test_constants.dart';

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
}