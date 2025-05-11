import 'package:luckify/domain/enum/fortune_type.dart';

class FortuneEntity {
  final int id;
  final String name;
  final FortuneType type;

  const FortuneEntity({
    required this.id,
    required this.name,
    required this.type,
  });

  bool get requiresUserInput => type == FortuneType.zodiacFortune;
}