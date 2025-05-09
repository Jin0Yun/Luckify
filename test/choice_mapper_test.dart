import 'package:flutter_test/flutter_test.dart';
import 'package:luckify/data/dto/choice_dto.dart';
import 'package:luckify/data/dto/message_dto.dart';
import 'package:luckify/data/mapper/choice_mapper.dart';
import 'package:luckify/data/mapper/message_mapper.dart';
import 'package:luckify/domain/entity/choice_entity.dart';
import 'package:luckify/domain/entity/message_entity.dart';
import 'package:luckify/domain/enum/message_sender.dart';

void main() {
  late ChoiceMapper choiceMapper;
  late MessageMapper messageMapper;

  setUp(() {
    messageMapper = MessageMapper();
    choiceMapper = ChoiceMapper(messageMapper);
  });

  group('ChoiceMapper', () {
    test('toDTO should convert ChoiceEntity to ChoiceDTO correctly', () {
      // Given
      final messageEntity = MessageEntity(
        id: 'test-id',
        content: '물고기자리의 운세입니다. 이번 주는 대인관계에서 좋은 기운이 있을 것입니다.',
        sender: MessageSender.assistant,
        timestamp: DateTime(2025, 5, 10),
      );

      final choiceEntity = ChoiceEntity(index: 0, message: messageEntity);

      // When
      final choiceDTO = choiceMapper.toDTO(choiceEntity);

      // Then
      expect(choiceDTO.index, 0);
      expect(choiceDTO.message.role, 'assistant');
      expect(
        choiceDTO.message.content,
        '물고기자리의 운세입니다. 이번 주는 대인관계에서 좋은 기운이 있을 것입니다.',
      );
    });

    test('toEntity should convert ChoiceDTO to ChoiceEntity correctly', () {
      // Given
      final messageDTO = MessageDTO(role: 'user', content: '물고기자리');

      final choiceDTO = ChoiceDTO(index: 1, message: messageDTO);

      // When
      final choiceEntity = choiceMapper.toEntity(choiceDTO);

      // Then
      expect(choiceEntity.index, 1);
      expect(choiceEntity.message.content, '물고기자리');
      expect(choiceEntity.message.sender, MessageSender.user);
      expect(choiceEntity.message.id.isNotEmpty, true);
    });

    test('round trip conversion should preserve data', () {
      // Given
      final originalDTO = ChoiceDTO(
        index: 2,
        message: MessageDTO(
          role: 'assistant',
          content: '물고기자리의 운세입니다. 이번 주는 대인관계에서 좋은 기운이 있을 것입니다.',
        ),
      );

      // When
      final entity = choiceMapper.toEntity(originalDTO);
      final convertedDTO = choiceMapper.toDTO(entity);

      // Then
      expect(convertedDTO.index, originalDTO.index);
      expect(convertedDTO.message.role, originalDTO.message.role);
      expect(convertedDTO.message.content, originalDTO.message.content);
    });
  });
}