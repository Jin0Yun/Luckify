import 'package:flutter_test/flutter_test.dart';
import 'package:luckify/core/exceptions/fortune_exception.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:luckify/domain/usecase/get_fortune_reading_usecase.dart';
import 'package:luckify/domain/repository/fortune_repository.dart';
import 'package:luckify/core/utils/uuid_generator.dart';
import 'package:luckify/presentation/formatters/fortune_content_formatter.dart';
import 'package:luckify/presentation/prompt/resolvers/prompt_resolver.dart';
import 'package:luckify/domain/enum/fortune_type.dart';
import 'package:luckify/domain/enum/message_sender.dart';
import '../../../mocks/get_fortune_reading_usecase_test.mocks.dart';
import '../../../builders/object_builders.dart';
import '../../core/constants/test_constants.dart';

@GenerateMocks([
  FortuneRepository,
  UuidGenerator,
  PromptResolver,
  FortuneContentFormatter,
])
void main() {
  group('GetFortuneReadingUseCase', () {
    late GetFortuneReadingUseCase useCase;
    late MockFortuneRepository mockRepository;
    late MockUuidGenerator mockUuidGenerator;
    late MockPromptResolver mockPromptResolver;
    late MockFortuneContentFormatter mockContentFormatter;

    setUp(() {
      mockRepository = MockFortuneRepository();
      mockUuidGenerator = MockUuidGenerator();
      mockPromptResolver = MockPromptResolver();
      mockContentFormatter = MockFortuneContentFormatter();

      useCase = GetFortuneReadingUseCase(
        repository: mockRepository,
        uuidGenerator: mockUuidGenerator,
        promptResolver: mockPromptResolver,
        contentFormatter: mockContentFormatter,
      );
    });

    void setupBasicMocks() {
      when(
        mockPromptResolver.resolvePrompt(any),
      ).thenReturn(TestConstants.promptText);

      var callCount = 0;
      when(mockUuidGenerator.generate()).thenAnswer((_) {
        callCount++;
        if (callCount == 1) {
          return TestConstants.testId;
        } else {
          return TestConstants.messageId;
        }
      });
    }

    test('execute should return formatted fortune for zodiac type', () async {
      // Given
      setupBasicMocks();
      final fortune = ObjectBuilders.fortune(type: FortuneType.zodiacFortune);
      final messages = [ObjectBuilders.message()];
      const userInput = TestConstants.zodiacSign;

      final responseEntity = ObjectBuilders.responseEntity(
        content: TestConstants.fortuneContent,
      );
      when(
        mockRepository.fetchFortuneFromAPI(any),
      ).thenAnswer((_) async => responseEntity);
      when(
        mockContentFormatter.format(TestConstants.fortuneContent, any),
      ).thenReturn(TestConstants.formattedZodiacContent);

      // When
      final result = await useCase.execute(
        fortune: fortune,
        messages: messages,
        userInput: userInput,
      );

      // Then
      expect(result.id, TestConstants.messageId);
      expect(result.content, TestConstants.formattedZodiacContent);
      expect(result.sender, MessageSender.assistant);
      expect(result.fortune, fortune);
      expect(result.userInput, userInput);

      verify(mockPromptResolver.resolvePrompt(any)).called(1);
      verify(mockUuidGenerator.generate()).called(2);
      verify(mockRepository.fetchFortuneFromAPI(any)).called(1);
      verify(
        mockContentFormatter.format(TestConstants.fortuneContent, any),
      ).called(1);
    });

    test('execute should return today fortune with default format', () async {
      // Given
      setupBasicMocks();
      final fortune = ObjectBuilders.fortune(type: FortuneType.fortuneToday);

      final responseEntity = ObjectBuilders.responseEntity(
        content: TestConstants.fortuneContent,
      );
      when(
        mockRepository.fetchFortuneFromAPI(any),
      ).thenAnswer((_) async => responseEntity);
      when(
        mockContentFormatter.format(TestConstants.fortuneContent, any),
      ).thenReturn(TestConstants.formattedTodayContent);

      // When
      final result = await useCase.execute(fortune: fortune, messages: []);

      // Then
      expect(result.id, TestConstants.messageId);
      expect(result.content, TestConstants.formattedTodayContent);
      expect(result.sender, MessageSender.assistant);
      expect(result.fortune, fortune);
      expect(result.userInput, isNull);
    });

    test('execute should use custom model when provided', () async {
      // Given
      setupBasicMocks();
      final fortune = ObjectBuilders.fortune(type: FortuneType.fortuneToday);
      const customModel = TestConstants.gptModel;

      final responseEntity = ObjectBuilders.responseEntity(
        model: customModel,
        content: TestConstants.fortuneContent,
      );
      when(
        mockRepository.fetchFortuneFromAPI(any),
      ).thenAnswer((_) async => responseEntity);
      when(
        mockContentFormatter.format(TestConstants.fortuneContent, any),
      ).thenReturn(TestConstants.formattedTodayContent);

      // When
      await useCase.execute(fortune: fortune, messages: [], model: customModel);

      // Then
      final captured =
          verify(mockRepository.fetchFortuneFromAPI(captureAny)).captured;
      final capturedRequest = captured.first;
      expect(capturedRequest.model, customModel);
    });

    test('execute should throw FortuneException when no choices', () async {
      // Given
      setupBasicMocks();
      when(
        mockRepository.fetchFortuneFromAPI(any),
      ).thenAnswer((_) async => ObjectBuilders.emptyResponseEntity());

      // When & Then
      expect(
            () => useCase.execute(fortune: ObjectBuilders.fortune(), messages: []),
        throwsA(
          isA<FortuneException>().having(
                (e) => e.type,
            'type',
            FortuneError.emptyChoices,
          ),
        ),
      );
    });

    test('execute should propagate exception when repository throws', () async {
      // Given
      setupBasicMocks();
      when(
        mockRepository.fetchFortuneFromAPI(any),
      ).thenThrow(Exception('Repository error'));

      // When & Then
      expect(
            () => useCase.execute(fortune: ObjectBuilders.fortune(), messages: []),
        throwsA(
          isA<FortuneException>().having(
                (e) => e.type,
            'type',
            FortuneError.unknown,
          ),
        ),
      );
    });
  });
}