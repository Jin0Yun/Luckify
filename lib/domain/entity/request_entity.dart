import 'package:luckify/domain/entity/message_entity.dart';

class RequestEntity {
  final String model;
  final List<MessageEntity> messages;

  const RequestEntity({required this.model, required this.messages});
}