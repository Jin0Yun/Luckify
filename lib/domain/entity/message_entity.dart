import 'package:luckify/domain/enum/message_role.dart';

class MessageEntity {
  final String id;
  final String content;
  final MessageRole sender;
  final DateTime timestamp;

  const MessageEntity({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
  });
}