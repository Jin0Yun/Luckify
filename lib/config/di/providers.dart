import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/core/logger/console_logger.dart';
import 'package:luckify/core/logger/logger.dart';
import 'package:luckify/core/utils/date_formatter.dart';
import 'package:luckify/data/network/custom_interceptor.dart';
import 'package:luckify/data/network/network_client.dart';
import 'package:luckify/data/network/network_client_interface.dart';
import 'package:luckify/presentation/formatters/fortune_content_formatter.dart';
import 'package:luckify/core/constants/api_constants.dart';
import 'package:luckify/data/mapper/choice_mapper.dart';
import 'package:luckify/data/mapper/message_mapper.dart';
import 'package:luckify/data/mapper/request_mapper.dart';
import 'package:luckify/data/mapper/response_mapper.dart';
import 'package:luckify/data/repository/fortune_repository_impl.dart';
import 'package:luckify/core/utils/uuid_generator.dart';
import 'package:luckify/domain/enum/fortune_type.dart';
import 'package:luckify/domain/repository/fortune_repository.dart';
import 'package:luckify/domain/usecase/get_fortune_reading_usecase.dart';
import 'package:luckify/presentation/prompt/generators/fortune_prompt_generator.dart';
import 'package:luckify/presentation/prompt/generators/today_fortune_prompt_generator.dart';
import 'package:luckify/presentation/prompt/generators/zodiac_fortune_prompt_generator.dart';
import 'package:luckify/presentation/prompt/resolvers/prompt_resolver.dart';

final loggerProvider = Provider<AppLogger>((ref) => ConsoleLogger());

final apiKeyProvider = Provider<String>((ref) {
  final apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    throw StateError('OpenAI API 키가 설정되지 않았습니다. .env 파일을 확인하세요.');
  }
  return apiKey;
});

final uuidGeneratorProvider = Provider<UuidGenerator>((ref) => UuidV4Generator());

final dioProvider = Provider<Dio>((ref) {
  final logger = ref.watch(loggerProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    LogInterceptor(requestBody: true, responseBody: true),
    CustomInterceptor(logger),
  ]);

  return dio;
});

final networkClientProvider = Provider<NetworkClientInterface>((ref) {
  return NetworkClient(
    ref.watch(dioProvider),
    ref.watch(loggerProvider),
  );
});

final messageMapperProvider = Provider<MessageMapper>((ref) => MessageMapper());

final choiceMapperProvider = Provider<ChoiceMapper>((ref) {
  return ChoiceMapper(ref.watch(messageMapperProvider));
});

final requestMapperProvider = Provider<RequestMapper>((ref) {
  return RequestMapper(ref.watch(messageMapperProvider));
});

final responseMapperProvider = Provider<ResponseMapper>((ref) {
  return ResponseMapper(ref.watch(choiceMapperProvider));
});

final dateFormatterProvider = Provider<DateFormatter>((ref) => KoreanDateFormatter());

final zodiacPromptGeneratorProvider = Provider<FortunePromptGenerator>((ref) {
  return ZodiacFortunePromptGenerator(ref.watch(dateFormatterProvider));
});

final todayPromptGeneratorProvider = Provider<FortunePromptGenerator>((ref) {
  return TodayFortunePromptGenerator(ref.watch(dateFormatterProvider));
});

final promptGeneratorsProvider = Provider<Map<FortuneType, FortunePromptGenerator>>((ref) {
  return {
    FortuneType.zodiacFortune: ref.watch(zodiacPromptGeneratorProvider),
    FortuneType.fortuneToday: ref.watch(todayPromptGeneratorProvider),
  };
});

final promptResolverProvider = Provider<PromptResolver>((ref) {
  return FortunePromptResolver(ref.watch(promptGeneratorsProvider));
});

final contentFormatterProvider = Provider<FortuneContentFormatter>((ref) {
  return FortuneContentFormatterImpl();
});

final fortuneRepositoryProvider = Provider<FortuneRepository>((ref) {
  return FortuneRepositoryImpl(
    networkClient: ref.watch(networkClientProvider),
    requestMapper: ref.watch(requestMapperProvider),
    responseMapper: ref.watch(responseMapperProvider),
    uuidGenerator: ref.watch(uuidGeneratorProvider),
    apiKey: ref.watch(apiKeyProvider),
    promptResolver: ref.watch(promptResolverProvider),
    contentFormatter: ref.watch(contentFormatterProvider),
  );
});

final getFortuneReadingUseCaseProvider = Provider<GetFortuneReadingUseCase>((ref) {
  return GetFortuneReadingUseCase(ref.watch(fortuneRepositoryProvider));
});