import 'package:luckify/core/logger/console_logger.dart';
import 'package:luckify/core/logger/logger.dart';

abstract class BaseRepository {
  final AppLogger logger;
  final String tag;

  BaseRepository({AppLogger? logger, required this.tag})
    : logger = logger ?? ConsoleLogger();

  Future<T> executeWithLogging<T>(
    Future<T> Function() action,
    String operationName, {
    String? additionalInfo,
  }) async {
    final infoMessage =
        additionalInfo != null
            ? '$operationName 시작: $additionalInfo'
            : '$operationName 시작';

    try {
      logger.i(infoMessage, tag: tag);

      final result = await action();

      logger.i('$operationName 성공', tag: tag);
      return result;
    } catch (e, stackTrace) {
      logger.e('$operationName 실패', error: e, stackTrace: stackTrace, tag: tag);
      rethrow;
    }
  }
}