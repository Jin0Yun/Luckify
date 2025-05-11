import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/entity/message_entity.dart';

class RequestEntity {
  final String model;
  final List<MessageEntity> messages;
  final FortuneEntity? fortune;
  final String? userInput;

  const RequestEntity({
    required this.model,
    required this.messages,
    this.fortune,
    this.userInput,
  });
}