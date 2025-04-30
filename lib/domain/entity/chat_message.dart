import 'package:luckify/domain/entity/message_sender.dart';

class ChatMessage {
  final String content;
  final MessageSender sender;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.sender,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}