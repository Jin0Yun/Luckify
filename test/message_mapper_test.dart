import 'package:flutter_test/flutter_test.dart';
import 'package:luckify/data/dto/message_dto.dart';
import 'package:luckify/data/mapper/message_mapper.dart';
import 'package:luckify/domain/entity/message_entity.dart';
import 'package:luckify/domain/enum/message_sender.dart';

void main() {
  late MessageMapper messageMapper;

  setUp(() {
    messageMapper = MessageMapper();
  });

  group('MessageMapper', () {
    test('toDTO should convert MessageEntity to MessageDTO correctly', () {
      // Given
      final entity = MessageEntity(
        id: 'test-id',
        content: '물고기자리',
        sender: MessageSender.user,
        timestamp: DateTime(2025, 5, 10),
      );

      // When
      final dto = messageMapper.toDTO(entity);

      // Then
      expect(dto.role, 'user');
      expect(dto.content, '물고기자리');
    });

    test('toDTO should set role to "assistant" when sender is assistant', () {
      // Given
      final entity = MessageEntity(
        id: 'test-id',
        content: '물고기자리의 운세를 알려드리겠습니다. 이번 주는 대인관계에 좋은 기운이 있습니다.',
        sender: MessageSender.assistant,
        timestamp: DateTime(2025, 5, 10),
      );

      // When
      final dto = messageMapper.toDTO(entity);

      // Then
      expect(dto.role, 'assistant');
      expect(dto.content, '물고기자리의 운세를 알려드리겠습니다. 이번 주는 대인관계에 좋은 기운이 있습니다.');
    });

    test('toEntity should convert MessageDTO to MessageEntity correctly', () {
      // Given
      final dto = MessageDTO(role: 'user', content: '물고기자리의 운세를 알려주세요');

      // When
      final entity = messageMapper.toEntity(dto);

      // Then
      expect(entity.id.isNotEmpty, true);
      expect(entity.content, '물고기자리의 운세를 알려주세요');
      expect(entity.sender, MessageSender.user);
      expect(entity.timestamp.isBefore(DateTime.now()), true);
    });

    test(
      'toEntity should set sender to MessageSender.assistant when role is "assistant"',
      () {
        // Given
        final dto = MessageDTO(
          role: 'assistant',
          content: '물고기자리는 이번 주 금전운이 좋습니다. 새로운 기회가 올 것입니다.',
        );

        // When
        final entity = messageMapper.toEntity(dto);

        // Then
        expect(entity.sender, MessageSender.assistant);
        expect(entity.content, '물고기자리는 이번 주 금전운이 좋습니다. 새로운 기회가 올 것입니다.');
      },
    );

    test('round trip conversion should preserve data', () {
      // Given
      final originalDTO = MessageDTO(
        role: 'assistant',
        content: '물고기자리의 운세입니다. 이번 주는 대인관계에서 좋은 기운이 있을 것입니다.',
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