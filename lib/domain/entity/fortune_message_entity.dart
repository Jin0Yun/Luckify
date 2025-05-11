import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/entity/message_entity.dart';
import 'package:luckify/domain/enum/fortune_type.dart';
import 'package:luckify/domain/enum/message_sender.dart';

class FortuneMessageEntity extends MessageEntity {
  final FortuneEntity? fortune;
  final String? userInput;

  const FortuneMessageEntity({
    required String id,
    required String content,
    required MessageSender sender,
    required DateTime timestamp,
    this.fortune,
    this.userInput,
  }) : super(
    id: id,
    content: content,
    sender: sender,
    timestamp: timestamp,
  );

  bool get isFortuneReading => fortune != null;
  bool get isZodiacFortune => fortune?.type == FortuneType.zodiacFortune;
}