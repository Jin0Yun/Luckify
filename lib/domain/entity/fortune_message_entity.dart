import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/entity/message_entity.dart';
import 'package:luckify/domain/enum/fortune_type.dart';

class FortuneMessageEntity extends MessageEntity {
  final FortuneEntity? fortune;
  final String? userInput;

  const FortuneMessageEntity({
    required super.id,
    required super.content,
    required super.sender,
    required super.timestamp,
    this.fortune,
    this.userInput,
  });

  bool get isFortuneReading => fortune != null;
  bool get isZodiacFortune => fortune?.type == FortuneType.zodiacFortune;
}