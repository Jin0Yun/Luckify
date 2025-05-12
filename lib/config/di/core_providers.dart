import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/core/logger/console_logger.dart';
import 'package:luckify/core/logger/logger.dart';
import 'package:luckify/core/utils/date_formatter.dart';
import 'package:luckify/core/utils/uuid_generator.dart';

final loggerProvider = Provider<AppLogger>((ref) => ConsoleLogger());

final apiKeyProvider = Provider<String>((ref) {
  final apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    throw StateError('OpenAI API 키가 설정되지 않았습니다. .env 파일을 확인하세요.');
  }
  return apiKey;
});

final uuidGeneratorProvider = Provider<UuidGenerator>(
  (ref) => UuidV4Generator(),
);

final dateFormatterProvider = Provider<DateFormatter>(
  (ref) => KoreanDateFormatter(),
);