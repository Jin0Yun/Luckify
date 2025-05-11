import 'package:flutter_test/flutter_test.dart';
import 'package:luckify/data/dto/choice_dto.dart';
import 'package:luckify/data/dto/message_dto.dart';
import 'package:luckify/data/dto/response_dto.dart';
import 'package:luckify/data/mapper/choice_mapper.dart';
import 'package:luckify/data/mapper/message_mapper.dart';
import 'package:luckify/data/mapper/response_mapper.dart';
import 'package:luckify/domain/entity/choice_entity.dart';
import 'package:luckify/domain/entity/response_entity.dart';
import 'package:luckify/domain/enum/message_sender.dart';
import 'object_builders.dart';
import 'test_constants.dart';

void main() {
  late ResponseMapper responseMapper;
  late ChoiceMapper choiceMapper;
  late MessageMapper messageMapper;

  setUp(() {
    messageMapper = MessageMapper();
    choiceMapper = ChoiceMapper(messageMapper);
    responseMapper = ResponseMapper(choiceMapper);
  });

  group('ResponseMapper', () {
    test('toDTO should convert ResponseEntity to ResponseDTO correctly', () {
      // Given
      final messageEntity = ObjectBuilders.message(
        id: 'fortune-reading-id',
        content: '물고기자리는 이번 주 금전운이 좋습니다. 새로운 투자 기회에 관심을 가져보세요.',
        sender: MessageSender.assistant,
      );

      final choiceEntity = ChoiceEntity(index: 0, message: messageEntity);

      final responseEntity = ResponseEntity(
        id: 'response-id-1234',
        object: 'chat.completion',
        created: TestConstants.testDate,
        model: TestConstants.gptModel,
        choices: [choiceEntity],
      );

      // When
      final responseDTO = responseMapper.toDTO(responseEntity);

      // Then
      expect(responseDTO.id, 'response-id-1234');
      expect(responseDTO.object, 'chat.completion');
      expect(
        responseDTO.created,
        responseEntity.created.millisecondsSinceEpoch ~/ 1000,
      );
      expect(responseDTO.model, TestConstants.gptModel);
      expect(responseDTO.choices.length, 1);
      expect(responseDTO.choices[0].index, 0);
      expect(responseDTO.choices[0].message.role, 'assistant');
      expect(responseDTO.choices[0].message.content, messageEntity.content);
    });

    test('toEntity should convert ResponseDTO to ResponseEntity correctly', () {
      // Given
      final messageDTO = MessageDTO(
        role: 'assistant',
        content: '물고기자리는 대인관계에서 좋은 기운이 있을 것입니다. 새로운 만남이 있을 수 있으니 주변을 잘 살펴보세요.',
      );

      final choiceDTO = ChoiceDTO(index: 0, message: messageDTO);

      const createdTimestamp = 1747756800;

      final responseDTO = ResponseDTO(
        id: 'response-12345',
        object: 'chat.completion',
        created: createdTimestamp,
        model: TestConstants.gptModel,
        choices: [choiceDTO],
      );

      // When
      final responseEntity = responseMapper.toEntity(responseDTO);

      // Then
      expect(responseEntity.id, 'response-12345');
      expect(responseEntity.object, 'chat.completion');
      expect(
        responseEntity.created.millisecondsSinceEpoch,
        createdTimestamp * 1000,
      );
      expect(responseEntity.model, TestConstants.gptModel);
      expect(responseEntity.choices.length, 1);
      expect(responseEntity.choices[0].index, 0);
      expect(responseEntity.choices[0].message.sender, MessageSender.assistant);
      expect(responseEntity.choices[0].message.content, messageDTO.content);
    });

    test('round trip conversion should preserve data', () {
      // Given
      const createdTimestamp = 1746802800;

      final originalDTO = ResponseDTO(
        id: 'api-response-1234',
        object: 'chat.completion',
        created: createdTimestamp,
        model: TestConstants.gptModel,
        choices: [
          ChoiceDTO(
            index: 0,
            message: MessageDTO(
              role: 'assistant',
              content: '물고기자리의 이번 달 운세는 매우 좋습니다. 새로운 기회가 찾아올 것입니다.',
            ),
          ),
        ],
      );

      // When
      final entity = responseMapper.toEntity(originalDTO);
      final convertedDTO = responseMapper.toDTO(entity);

      // Then
      expect(convertedDTO.id, originalDTO.id);
      expect(convertedDTO.object, originalDTO.object);
      expect(convertedDTO.created, originalDTO.created);
      expect(convertedDTO.model, originalDTO.model);
      expect(convertedDTO.choices.length, originalDTO.choices.length);
      expect(convertedDTO.choices[0].index, originalDTO.choices[0].index);
      expect(
        convertedDTO.choices[0].message.role,
        originalDTO.choices[0].message.role,
      );
      expect(
        convertedDTO.choices[0].message.content,
        originalDTO.choices[0].message.content,
      );
    });
  });
}