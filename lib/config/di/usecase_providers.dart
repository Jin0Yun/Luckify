import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/config/di/core_providers.dart';
import 'package:luckify/config/di/repository_providers.dart';
import 'package:luckify/domain/enum/fortune_type.dart';
import 'package:luckify/domain/usecase/get_fortune_reading_usecase.dart';
import 'package:luckify/presentation/formatters/fortune_content_formatter.dart';
import 'package:luckify/presentation/formatters/fortune_content_formatter_impl.dart';
import 'package:luckify/presentation/prompt/generators/fortune_prompt_generator.dart';
import 'package:luckify/presentation/prompt/generators/today_fortune_prompt_generator.dart';
import 'package:luckify/presentation/prompt/generators/zodiac_fortune_prompt_generator.dart';
import 'package:luckify/presentation/prompt/resolvers/prompt_resolver.dart';

final zodiacPromptGeneratorProvider = Provider<FortunePromptGenerator>((ref) {
  return ZodiacFortunePromptGenerator(ref.watch(dateFormatterProvider));
});

final todayPromptGeneratorProvider = Provider<FortunePromptGenerator>((ref) {
  return TodayFortunePromptGenerator(ref.watch(dateFormatterProvider));
});

final promptGeneratorsProvider =
    Provider<Map<FortuneType, FortunePromptGenerator>>((ref) {
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

final getFortuneReadingUseCaseProvider = Provider<GetFortuneReadingUseCase>((
  ref,
) {
  return GetFortuneReadingUseCase(
    repository: ref.watch(fortuneRepositoryProvider),
    uuidGenerator: ref.watch(uuidGeneratorProvider),
    promptResolver: ref.watch(promptResolverProvider),
    contentFormatter: ref.watch(contentFormatterProvider),
  );
});