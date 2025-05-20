import 'package:luckify/domain/entity/fortune_history_entity.dart';
import 'package:luckify/domain/enum/fortune_type.dart';

abstract class FortuneHistoryRepository {
  Future<List<FortuneHistoryEntity>> getFortuneHistories();
  Future<List<FortuneHistoryEntity>> getFortuneHistoriesByType(FortuneType type);
  Future<void> saveFortuneHistory(FortuneHistoryEntity history);
  Future<void> deleteFortuneHistory(String id);
  Future<FortuneHistoryEntity?> getFortuneHistoryById(String id);
}