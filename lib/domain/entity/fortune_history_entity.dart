import 'package:luckify/domain/entity/fortune_entity.dart';

class FortuneHistoryEntity {
  final String id;
  final FortuneEntity fortune;
  final String content;
  final DateTime timestamp;
  final String? userInput;

  const FortuneHistoryEntity({
    required this.id,
    required this.fortune,
    required this.content,
    required this.timestamp,
    this.userInput,
  });
}