import 'package:luckify/domain/entity/request_entity.dart';

abstract class FortuneContentFormatter {
  String format(String content, RequestEntity request);
}