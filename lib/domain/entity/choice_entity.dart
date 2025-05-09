import 'package:luckify/domain/entity/message_entity.dart';

class ChoiceEntity {
  final int index;
  final MessageEntity message;
  final String finishReason;

  const ChoiceEntity({
    required this.index,
    required this.message,
    this.finishReason = '',
  });
}