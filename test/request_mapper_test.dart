import 'package:flutter_test/flutter_test.dart';
import 'package:luckify/data/dto/message_dto.dart';
import 'package:luckify/data/dto/request_dto.dart';
import 'package:luckify/data/mapper/message_mapper.dart';
import 'package:luckify/data/mapper/request_mapper.dart';
import 'package:luckify/domain/enum/message_sender.dart';
import 'object_builders.dart';
import 'test_constants.dart';

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
      final messageEntity1 = ObjectBuilders.message(
        id: 'assistant-message-id',
        content: '별자리를 입력해주세요',
        sender: MessageSender.assistant,
      );

      final messageEntity2 = ObjectBuilders.message(
        id: 'user-message-id',
        content: TestConstants.zodiacSign,
        sender: MessageSender.user,
      );

      final requestEntity = ObjectBuilders.request(
        model: TestConstants.gptModel,
        messages: [messageEntity1, messageEntity2],
      );

      // When
      final requestDTO = requestMapper.toDTO(requestEntity);

      // Then
      expect(requestDTO.model, TestConstants.gptModel);
      expect(requestDTO.messages.length, 2);
      expect(requestDTO.messages[0].role, 'assistant');
      expect(requestDTO.messages[0].content, '별자리를 입력해주세요');
      expect(requestDTO.messages[1].role, 'user');
      expect(requestDTO.messages[1].content, TestConstants.zodiacSign);
    });

    test('toEntity should convert RequestDTO to RequestEntity correctly', () {
      // Given
      final messageDTO1 = MessageDTO(role: 'user', content: TestConstants.zodiacSign);

      final messageDTO2 = MessageDTO(
        role: 'assistant',
        content: '물고기자리의 운세를 확인해볼게요.',
      );

      final requestDTO = RequestDTO(
        model: TestConstants.gptModel,
        messages: [messageDTO1, messageDTO2],
      );

      // When
      final requestEntity = requestMapper.toEntity(requestDTO);

      // Then
      expect(requestEntity.model, TestConstants.gptModel);
      expect(requestEntity.messages.length, 2);
      expect(requestEntity.messages[0].content, TestConstants.zodiacSign);
      expect(requestEntity.messages[0].sender, MessageSender.user);
      expect(requestEntity.messages[1].content, '물고기자리의 운세를 확인해볼게요.');
      expect(requestEntity.messages[1].sender, MessageSender.assistant);
    });

    test('round trip conversion should preserve data', () {
      // Given
      final originalDTO = RequestDTO(
        model: TestConstants.gptModel,
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
      for (int i = 0; i < originalDTO.messages.length; i++) {
        expect(convertedDTO.messages[i].role, originalDTO.messages[i].role);
        expect(convertedDTO.messages[i].content, originalDTO.messages[i].content);
      }
    });
  });
}