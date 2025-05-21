import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luckify/core/exceptions/fortune_exception.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/entity/fortune_history_entity.dart';
import 'package:luckify/domain/enum/fortune_type.dart';
import 'package:luckify/domain/repository/fortune_history_repository.dart';

class FortuneHistoryRepositoryImpl implements FortuneHistoryRepository {
  final FirebaseFirestore _firestore;
  final String? _userId;

  static const String _collectionName = 'fortune_histories';

  FortuneHistoryRepositoryImpl({
    required FirebaseFirestore firestore,
    String? userId,
  }) : _firestore = firestore,
       _userId = userId;

  CollectionReference<Map<String, dynamic>> get _collection {
    if (_userId != null) {
      return _firestore
          .collection('users')
          .doc(_userId)
          .collection(_collectionName);
    }
    return _firestore.collection(_collectionName);
  }

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
      final snapshot = await _collection.get();
      return snapshot.docs
          .map((doc) => _mapToEntity(doc.id, doc.data()))
          .toList();
    });
  }

  @override
  Future<List<FortuneHistoryEntity>> getFortuneHistoriesByType(
    FortuneType type,
  ) async {
    return _wrapException(() async {
      final snapshot =
          await _collection
              .where('fortune.type', isEqualTo: type.toString())
              .get();

      return snapshot.docs
          .map((doc) => _mapToEntity(doc.id, doc.data()))
          .toList();
    });
  }

  @override
  Future<FortuneHistoryEntity?> getFortuneHistoryById(String id) async {
    return _wrapException(() async {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return _mapToEntity(doc.id, doc.data()!);
    });
  }

  @override
  Future<void> saveFortuneHistory(FortuneHistoryEntity history) async {
    return _wrapException(() async {
      await _collection.doc(history.id).set(_mapToJson(history));
    });
  }

  @override
  Future<void> deleteFortuneHistory(String id) async {
    return _wrapException(() async {
      await _collection.doc(id).delete();
    });
  }

  FortuneHistoryEntity _mapToEntity(String docId, Map<String, dynamic> map) {
    return FortuneHistoryEntity(
      id: docId,
      fortune: FortuneEntity(
        id: map['fortune']['id'],
        name: map['fortune']['name'],
        type: FortuneType.values.firstWhere(
          (e) => e.toString() == map['fortune']['type'],
        ),
        iconPath: map['fortune']['iconPath'] ?? '',
      ),
      content: map['content'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      userInput: map['userInput'],
    );
  }

  Map<String, dynamic> _mapToJson(FortuneHistoryEntity entity) {
    return {
      'fortune': {
        'id': entity.fortune.id,
        'name': entity.fortune.name,
        'type': entity.fortune.type.toString(),
        'iconPath': entity.fortune.iconPath,
      },
      'content': entity.content,
      'timestamp': Timestamp.fromDate(entity.timestamp),
      'userInput': entity.userInput,
    };
  }
}