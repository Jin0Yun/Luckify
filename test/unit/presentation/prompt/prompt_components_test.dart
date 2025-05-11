import 'package:flutter_test/flutter_test.dart';
import 'package:luckify/core/utils/date_formatter.dart';
import 'package:luckify/presentation/formatters/fortune_content_formatter.dart';
import 'package:luckify/presentation/formatters/fortune_content_formatterImpl.dart';
import 'package:luckify/presentation/prompt/generators/today_fortune_prompt_generator.dart';
import 'package:luckify/presentation/prompt/generators/zodiac_fortune_prompt_generator.dart';
import 'package:luckify/presentation/prompt/generators/fortune_prompt_generator.dart';
import 'package:luckify/domain/enum/fortune_type.dart';
import 'package:luckify/presentation/prompt/resolvers/prompt_resolver.dart';
import '../../../builders/object_builders.dart';
import '../../core/constants/test_constants.dart';

void main() {
  group('TodayFortunePromptGenerator', () {
    late TodayFortunePromptGenerator generator;
    late DateFormatter dateFormatter;

    setUp(() {
      dateFormatter = KoreanDateFormatter();
      generator = TodayFortunePromptGenerator(dateFormatter);
    });

    test('generatePrompt should create today fortune prompt', () {
      // Given & When
      final prompt = generator.generatePrompt();

      // Then
      expect(prompt, contains('오늘'));
      expect(prompt, contains('의 운세를 알려주세요'));
      expect(prompt, contains('금전운, 사랑운, 건강운, 행운의 컬러'));
      expect(prompt, contains('# 금전운'));
      expect(prompt, contains('# 사랑운'));
      expect(prompt, contains('# 건강운'));
      expect(prompt, contains('# 행운의 컬러'));
      expect(prompt, contains('주의사항:'));
      expect(prompt, contains('별자리명과 날짜 범위, 오늘 날짜, 오늘의 운세라는 멘트 작성하지 마세요!'));
    });

    test('generatePrompt should ignore userInput parameter', () {
      // Given & When
      final prompt = generator.generatePrompt(userInput: TestConstants.zodiacSign);

      // Then
      expect(prompt, contains('오늘'));
      expect(prompt, isNot(contains(TestConstants.zodiacSign)));
    });
  });

  group('ZodiacFortunePromptGenerator', () {
    late ZodiacFortunePromptGenerator generator;
    late DateFormatter dateFormatter;

    setUp(() {
      dateFormatter = KoreanDateFormatter();
      generator = ZodiacFortunePromptGenerator(dateFormatter);
    });

    test('generatePrompt should create zodiac fortune prompt', () {
      // Given
      const zodiacSign = TestConstants.zodiacSign;

      // When
      final prompt = generator.generatePrompt(userInput: zodiacSign);

      // Then
      expect(prompt, contains(zodiacSign));
      expect(prompt, contains('의 오늘'));
      expect(prompt, contains('운세를 알려주세요'));
      expect(prompt, contains('금전운, 사랑운, 건강운, 행운의 컬러'));
      expect(prompt, contains('# 금전운'));
      expect(prompt, contains('# 사랑운'));
      expect(prompt, contains('# 건강운'));
      expect(prompt, contains('# 행운의 컬러'));
      expect(prompt, contains('주의사항:'));
    });

    test('generatePrompt should throw exception when userInput is null', () {
      // Given & When & Then
      expect(
            () => generator.generatePrompt(userInput: null),
        throwsA(isA<ArgumentError>().having(
              (e) => e.message,
          'message',
          '별자리 운세에는 별자리 입력이 필요합니다.',
        )),
      );
    });

    test('generatePrompt should throw exception when userInput is empty', () {
      // Given & When & Then
      expect(
            () => generator.generatePrompt(userInput: ''),
        throwsA(isA<ArgumentError>().having(
              (e) => e.message,
          'message',
          '별자리 운세에는 별자리 입력이 필요합니다.',
        )),
      );
    });
  });

  group('FortuneContentFormatterImpl', () {
    late FortuneContentFormatter formatter;

    setUp(() {
      formatter = FortuneContentFormatterImpl();
    });

    test('format should return original content when fortune is null', () {
      // Given
      final request = ObjectBuilders.request(fortune: null);
      const content = '운세 내용';

      // When
      final result = formatter.format(content, request);

      // Then
      expect(result, content);
    });

    test('format should include userInput when userInput exists', () {
      // Given
      final fortune = ObjectBuilders.fortune(type: FortuneType.zodiacFortune);
      final request = ObjectBuilders.request(
        fortune: fortune,
        userInput: TestConstants.zodiacSign,
      );
      const content = '금전운이 좋습니다.';

      // When
      final result = formatter.format(content, request);

      // Then
      expect(result, '🌟 ${TestConstants.zodiacSign}의 운세 🌟\n\n$content');
    });

    test('format should use default format when userInput is null', () {
      // Given
      final fortune = ObjectBuilders.fortune(type: FortuneType.zodiacFortune);
      final request = ObjectBuilders.request(
        fortune: fortune,
        userInput: null,
      );
      const content = '금전운이 좋습니다.';

      // When
      final result = formatter.format(content, request);

      // Then
      expect(result, '✨ 오늘의 운세 ✨\n\n$content');
    });

    test('format should use default format for today fortune', () {
      // Given
      final fortune = ObjectBuilders.fortune(
        id: 2,
        name: '오늘의 운세',
        type: FortuneType.fortuneToday,
      );
      final request = ObjectBuilders.request(fortune: fortune);
      const content = '좋은 하루가 될 것입니다.';

      // When
      final result = formatter.format(content, request);

      // Then
      expect(result, '✨ 오늘의 운세 ✨\n\n$content');
    });
  });

  group('FortunePromptResolver', () {
    late FortunePromptResolver resolver;
    late DateFormatter dateFormatter;

    setUp(() {
      dateFormatter = KoreanDateFormatter();
      final zodiacGenerator = ZodiacFortunePromptGenerator(dateFormatter);
      final todayGenerator = TodayFortunePromptGenerator(dateFormatter);

      resolver = FortunePromptResolver({
        FortuneType.zodiacFortune: zodiacGenerator,
        FortuneType.fortuneToday: todayGenerator,
      });
    });

    test('resolvePrompt should select zodiac fortune prompt', () {
      // Given
      final fortune = ObjectBuilders.fortune(type: FortuneType.zodiacFortune);
      final request = ObjectBuilders.request(
        fortune: fortune,
        userInput: TestConstants.zodiacSign,
      );

      // When
      final result = resolver.resolvePrompt(request);

      // Then
      expect(result, contains(TestConstants.zodiacSign));
      expect(result, contains('의 오늘'));
      expect(result, contains('운세를 알려주세요'));
    });

    test('resolvePrompt should select today fortune prompt', () {
      // Given
      final fortune = ObjectBuilders.fortune(
        id: 2,
        name: '오늘의 운세',
        type: FortuneType.fortuneToday,
      );
      final request = ObjectBuilders.request(fortune: fortune);

      // When
      final result = resolver.resolvePrompt(request);

      // Then
      expect(result, contains('오늘'));
      expect(result, contains('의 운세를 알려주세요'));
      expect(result, contains('금전운, 사랑운, 건강운, 행운의 컬러'));
    });

    test('resolvePrompt should throw exception when fortune is null', () {
      // Given
      final request = ObjectBuilders.request(fortune: null);

      // When & Then
      expect(
            () => resolver.resolvePrompt(request),
        throwsA(
          isA<ArgumentError>().having(
                (e) => e.message,
            'message',
            'Fortune type is required',
          ),
        ),
      );
    });

    test('resolvePrompt should throw exception for unsupported fortune type', () {
      // Given
      const Map<FortuneType, FortunePromptGenerator> limitedGenerators = {};
      final resolverWithLimitedTypes = FortunePromptResolver(limitedGenerators);

      final fortune = ObjectBuilders.fortune(type: FortuneType.fortuneToday);
      final request = ObjectBuilders.request(fortune: fortune);

      // When & Then
      expect(
            () => resolverWithLimitedTypes.resolvePrompt(request),
        throwsA(
          isA<ArgumentError>().having(
                (e) => e.message,
            'message',
            contains('Unsupported fortune type'),
          ),
        ),
      );
    });
  });
}