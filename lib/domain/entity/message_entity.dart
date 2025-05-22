import 'package:luckify/domain/enum/message_sender.dart';

class MessageEntity {
  final String id;
  final String content;
  final MessageSender sender;
  final DateTime timestamp;

  const MessageEntity({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
  });
}