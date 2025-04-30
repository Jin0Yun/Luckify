import 'package:luckify/domain/entity/fortune_type.dart';

class FortuneEntity {
  final int id;
  final String name;
  final FortuneType imageType;

  const FortuneEntity({
    required this.id,
    required this.name,
    required this.imageType,
  });
}