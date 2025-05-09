import 'package:flutter_test/flutter_test.dart';
import 'package:luckify/data/dto/message_dto.dart';
import 'package:luckify/data/dto/request_dto.dart';
import 'package:luckify/data/mapper/message_mapper.dart';
import 'package:luckify/data/mapper/request_mapper.dart';
import 'package:luckify/domain/entity/message_entity.dart';
import 'package:luckify/domain/entity/request_entity.dart';
import 'package:luckify/domain/enum/message_sender.dart';

void main() {
  late RequestMapper requestMapper;
  late MessageMapper messageMapper;

  setUp(() {
    messageMapper = MessageMapper();
    requestMapper = RequestMapper(messageMapper);
  });

  group('RequestMapper', () {
    test('toDTO should convert RequestEntity to RequestDTO correctly', () {
      // Given
      final messageEntity1 = MessageEntity(
        id: 'assistant-message-id',
        content: '별자리를 입력해주세요',
        sender: MessageSender.assistant,
        timestamp: DateTime(2025, 5, 10),
      );

      final messageEntity2 = MessageEntity(
        id: 'user-message-id',
        content: '물고기자리',
        sender: MessageSender.user,
        timestamp: DateTime(2025, 5, 10),
      );

      final requestEntity = RequestEntity(
        model: 'gpt-4o-mini',
        messages: [messageEntity1, messageEntity2],
      );

      // When
      final requestDTO = requestMapper.toDTO(requestEntity);

      // Then
      expect(requestDTO.model, 'gpt-4o-mini');
      expect(requestDTO.messages.length, 2);
      expect(requestDTO.messages[0].role, 'assistant');
      expect(requestDTO.messages[0].content, '별자리를 입력해주세요');
      expect(requestDTO.messages[1].role, 'user');
      expect(requestDTO.messages[1].content, '물고기자리');
    });

    test('toEntity should convert RequestDTO to RequestEntity correctly', () {
      // Given
      final messageDTO1 = MessageDTO(role: 'user', content: '물고기자리');

      final messageDTO2 = MessageDTO(
        role: 'assistant',
        content: '물고기자리의 운세를 확인해볼게요.',
      );

      final requestDTO = RequestDTO(
        model: 'gpt-4o-mini',
        messages: [messageDTO1, messageDTO2],
      );

      // When
      final requestEntity = requestMapper.toEntity(requestDTO);

      // Then
      expect(requestEntity.model, 'gpt-4o-mini');
      expect(requestEntity.messages.length, 2);
      expect(requestEntity.messages[0].content, '물고기자리');
      expect(requestEntity.messages[0].sender, MessageSender.user);
      expect(requestEntity.messages[1].content, '물고기자리의 운세를 확인해볼게요.');
      expect(requestEntity.messages[1].sender, MessageSender.assistant);
    });

    test('round trip conversion should preserve data', () {
      // Given
      final originalDTO = RequestDTO(
        model: 'gpt-4o-mini',
        messages: [
          MessageDTO(role: 'user', content: '물고기자리 운세 알려줘'),
          MessageDTO(role: 'assistant', content: '물고기자리 운세를 알려드리겠습니다.'),
        ],
      );

      // When
      final entity = requestMapper.toEntity(originalDTO);
      final convertedDTO = requestMapper.toDTO(entity);

      // Then
      expect(convertedDTO.model, originalDTO.model);
      expect(convertedDTO.messages.length, originalDTO.messages.length);
      expect(convertedDTO.messages[0].role, originalDTO.messages[0].role);
      expect(convertedDTO.messages[0].content, originalDTO.messages[0].content);
      expect(convertedDTO.messages[1].role, originalDTO.messages[1].role);
      expect(convertedDTO.messages[1].content, originalDTO.messages[1].content);
    });
  });
}