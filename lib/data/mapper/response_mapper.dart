import 'package:luckify/data/dto/choice_dto.dart';
import 'package:luckify/data/dto/response_dto.dart';
import 'package:luckify/data/mapper/base_mapper.dart';
import 'package:luckify/data/mapper/message_mapper.dart';
import 'package:luckify/domain/entity/response_entity.dart';
import 'package:luckify/domain/entity/choice_entity.dart';

class ResponseMapper implements BaseMapper<ResponseDTO, ResponseEntity> {
  final MessageMapper _messageMapper;

  ResponseMapper(this._messageMapper);

  @override
  ResponseDTO toDTO(ResponseEntity entity) {
    final choiceDTOs =
        entity.choices
            .map(
              (choice) => ChoiceDTO(
                index: choice.index,
                message: _messageMapper.toDTO(choice.message),
              ),
            )
            .toList();

    return ResponseDTO(
      id: entity.id,
      object: entity.object,
      created: entity.created.millisecondsSinceEpoch ~/ 1000,
      model: entity.model,
      choices: choiceDTOs,
    );
  }

  @override
  ResponseEntity toEntity(ResponseDTO dto) {
    final choiceEntities =
        dto.choices
            .map(
              (choice) => ChoiceEntity(
                index: choice.index,
                message: _messageMapper.toEntity(choice.message),
              ),
            )
            .toList();

    return ResponseEntity(
      id: dto.id,
      object: dto.object,
      created: DateTime.fromMillisecondsSinceEpoch(dto.created * 1000),
      model: dto.model,
      choices: choiceEntities,
    );
  }
}