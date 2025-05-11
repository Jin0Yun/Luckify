import 'package:flutter_test/flutter_test.dart';
import 'package:luckify/data/dto/message_dto.dart';
import 'package:luckify/data/mapper/message_mapper.dart';
import 'package:luckify/domain/enum/message_sender.dart';
import 'object_builders.dart';
import 'test_constants.dart';

void main() {
  late MessageMapper messageMapper;

  setUp(() {
    messageMapper = MessageMapper();
  });

  group('MessageMapper', () {
    test('toDTO should convert MessageEntity to MessageDTO correctly', () {
      // Given
      final entity = ObjectBuilders.message(
        content: TestConstants.zodiacSign,
        sender: MessageSender.user,
      );

      // When
      final dto = messageMapper.toDTO(entity);

      // Then
      expect(dto.role, 'user');
      expect(dto.content, TestConstants.zodiacSign);
    });

    test('toDTO should set role to "assistant" when sender is assistant', () {
      // Given
      final entity = ObjectBuilders.message(
        content: TestConstants.fortuneContent,
        sender: MessageSender.assistant,
      );

      // When
      final dto = messageMapper.toDTO(entity);

      // Then
      expect(dto.role, 'assistant');
      expect(dto.content, TestConstants.fortuneContent);
    });

    test('toEntity should convert MessageDTO to MessageEntity correctly', () {
      // Given
      final dto = MessageDTO(role: 'user', content: TestConstants.zodiacSign);

      // When
      final entity = messageMapper.toEntity(dto);

      // Then
      expect(entity.id, isNotEmpty);
      expect(entity.content, TestConstants.zodiacSign);
      expect(entity.sender, MessageSender.user);
      expect(entity.timestamp, isA<DateTime>());
    });

    test('toEntity should set sender to MessageSender.assistant when role is "assistant"', () {
      // Given
      final dto = MessageDTO(role: 'assistant', content: TestConstants.fortuneContent);

      // When
      final entity = messageMapper.toEntity(dto);

      // Then
      expect(entity.id, isNotEmpty);
      expect(entity.content, TestConstants.fortuneContent);
      expect(entity.sender, MessageSender.assistant);
      expect(entity.timestamp, isA<DateTime>());
    });

    test('round trip conversion should preserve data', () {
      // Given
      final originalDTO = MessageDTO(
        role: 'assistant',
        content: TestConstants.fortuneContent,
      );

      // When
      final entity = messageMapper.toEntity(originalDTO);
      final convertedDTO = messageMapper.toDTO(entity);

      // Then
      expect(convertedDTO.role, originalDTO.role);
      expect(convertedDTO.content, originalDTO.content);
    });
  });
}