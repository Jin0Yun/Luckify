import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luckify/core/exceptions/fortune_exception.dart';
import 'package:luckify/data/repository/base_repository.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/entity/fortune_history_entity.dart';
import 'package:luckify/domain/enum/fortune_type.dart';
import 'package:luckify/domain/repository/fortune_history_repository.dart';

class FortuneHistoryRepositoryImpl extends BaseRepository
    implements FortuneHistoryRepository {
  final FirebaseFirestore _firestore;
  final String? _userId;

  static const String _collectionName = 'fortune_histories';

  FortuneHistoryRepositoryImpl({
    required FirebaseFirestore firestore,
    String? userId,
    super.logger,
  }) : _firestore = firestore,
       _userId = userId,
       super(tag: 'FortuneHistory');

  CollectionReference<Map<String, dynamic>> get _collection {
    if (_userId != null) {
      return _firestore
          .collection('users')
          .doc(_userId)
          .collection(_collectionName);
    }
    return _firestore.collection(_collectionName);
  }

  FortuneException _mapFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return FortuneException(FortuneError.permissionDenied, e);
      case 'unavailable':
        return FortuneException(FortuneError.networkError, e);
      case 'not-found':
        return FortuneException(FortuneError.documentNotFound, e);
      default:
        return FortuneException(FortuneError.unknown, e);
    }
  }

  @override
  Future<List<FortuneHistoryEntity>> getFortuneHistories() {
    return executeWithLogging(() async {
      try {
        final snapshot =
            await _collection.orderBy('timestamp', descending: true).get();

        return snapshot.docs
            .map((doc) => _mapToEntity(doc.id, doc.data()))
            .toList();
      } on FirebaseException catch (e) {
        throw _mapFirebaseException(e);
      } catch (e) {
        throw FortuneException(FortuneError.unknown, e is Exception ? e : null);
      }
    }, '운세 기록 조회');
  }

  @override
  Future<List<FortuneHistoryEntity>> getFortuneHistoriesByType(
    FortuneType type,
  ) {
    return executeWithLogging(
      () async {
        try {
          final snapshot =
              await _collection
                  .where('fortune.type', isEqualTo: type.toString())
                  .orderBy('timestamp', descending: true)
                  .get();

          return snapshot.docs
              .map((doc) => _mapToEntity(doc.id, doc.data()))
              .toList();
        } on FirebaseException catch (e) {
          throw _mapFirebaseException(e);
        } catch (e) {
          throw FortuneException(
            FortuneError.unknown,
            e is Exception ? e : null,
          );
        }
      },
      '타입별 운세 기록 조회',
      additionalInfo: type.toString(),
    );
  }

  @override
  Future<FortuneHistoryEntity?> getFortuneHistoryById(String id) {
    return executeWithLogging(
      () async {
        try {
          final doc = await _collection.doc(id).get();
          if (!doc.exists) {
            logger.w('운세 기록 없음: $id', tag: tag);
            return null;
          }

          return _mapToEntity(doc.id, doc.data()!);
        } on FirebaseException catch (e) {
          throw _mapFirebaseException(e);
        } catch (e) {
          throw FortuneException(
            FortuneError.unknown,
            e is Exception ? e : null,
          );
        }
      },
      '단일 운세 기록 조회',
      additionalInfo: id,
    );
  }

  @override
  Future<void> saveFortuneHistory(FortuneHistoryEntity history) {
    return executeWithLogging(
      () async {
        try {
          await _collection.doc(history.id).set(_mapToJson(history));
        } on FirebaseException catch (e) {
          throw _mapFirebaseException(e);
        } catch (e) {
          throw FortuneException(
            FortuneError.unknown,
            e is Exception ? e : null,
          );
        }
      },
      '운세 기록 저장',
      additionalInfo: history.id,
    );
  }

  @override
  Future<void> deleteFortuneHistory(String id) {
    return executeWithLogging(
      () async {
        try {
          await _collection.doc(id).delete();
        } on FirebaseException catch (e) {
          throw _mapFirebaseException(e);
        } catch (e) {
          throw FortuneException(
            FortuneError.unknown,
            e is Exception ? e : null,
          );
        }
      },
      '운세 기록 삭제',
      additionalInfo: id,
    );
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