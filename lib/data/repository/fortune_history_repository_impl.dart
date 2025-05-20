import 'package:luckify/core/exceptions/fortune_exception.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/entity/fortune_history_entity.dart';
import 'package:luckify/domain/enum/fortune_type.dart';
import 'package:luckify/domain/repository/fortune_history_repository.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FortuneHistoryRepositoryImpl implements FortuneHistoryRepository {
  final SharedPreferences _prefs;

  static const String _historyKey = 'fortune_histories';

  FortuneHistoryRepositoryImpl({required SharedPreferences prefs})
    : _prefs = prefs;

  Future<T> _wrapException<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (e) {
      throw FortuneException(FortuneError.unknown, e is Exception ? e : null);
    }
  }

  @override
  Future<List<FortuneHistoryEntity>> getFortuneHistories() async {
    return _wrapException(() async {
      final String? historyJson = _prefs.getString(_historyKey);
      if (historyJson == null) return [];

      final List<dynamic> decoded = jsonDecode(historyJson);
      return decoded.map((item) => _mapToEntity(item)).toList();
    });
  }

  @override
  Future<List<FortuneHistoryEntity>> getFortuneHistoriesByType(
    FortuneType type,
  ) async {
    return _wrapException(() async {
      final histories = await getFortuneHistories();
      return histories.where((h) => h.fortune.type == type).toList();
    });
  }

  @override
  Future<FortuneHistoryEntity?> getFortuneHistoryById(String id) async {
    return _wrapException(() async {
      final histories = await getFortuneHistories();
      return histories.firstWhere((h) => h.id == id);
    });
  }

  @override
  Future<void> saveFortuneHistory(FortuneHistoryEntity history) async {
    return _wrapException(() async {
      final String? historyJson = _prefs.getString(_historyKey);
      final List<dynamic> histories =
          historyJson != null ? jsonDecode(historyJson) : [];
      histories.add(_mapToJson(history));
      await _prefs.setString(_historyKey, jsonEncode(histories));
    });
  }

  @override
  Future<void> deleteFortuneHistory(String id) async {
    return _wrapException(() async {
      final historyJson = _prefs.getString(_historyKey);
      if (historyJson == null) return;

      final List<dynamic> decoded = jsonDecode(historyJson);
      final filtered = decoded.where((item) => item['id'] != id).toList();

      await _prefs.setString(_historyKey, jsonEncode(filtered));
    });
  }

  FortuneHistoryEntity _mapToEntity(Map<String, dynamic> map) {
    return FortuneHistoryEntity(
      id: map['id'],
      fortune: FortuneEntity(
        id: map['fortune']['id'],
        name: map['fortune']['name'],
        type: FortuneType.values.firstWhere(
          (e) => e.toString() == map['fortune']['type'],
        ),
        iconPath: map['fortune']['iconPath'] ?? '',
      ),
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
      userInput: map['userInput'],
    );
  }

  Map<String, dynamic> _mapToJson(FortuneHistoryEntity entity) {
    return {
      'id': entity.id,
      'fortune': {
        'id': entity.fortune.id,
        'name': entity.fortune.name,
        'type': entity.fortune.type.toString(),
        'iconPath': entity.fortune.iconPath,
      },
      'content': entity.content,
      'timestamp': entity.timestamp.toIso8601String(),
      'userInput': entity.userInput,
    };
  }
}