import 'package:luckify/domain/entity/fortune_message_entity.dart';
import 'package:luckify/domain/entity/request_entity.dart';

abstract class FortuneRepository {
  Future<FortuneMessageEntity> getFortuneReading(RequestEntity request);
}