import 'package:luckify/domain/entity/request_entity.dart';
import 'package:luckify/domain/entity/response_entity.dart';

abstract class FortuneRepository {
  Future<ResponseEntity> fetchFortuneFromAPI(RequestEntity request);
}