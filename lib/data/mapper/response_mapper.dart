import 'package:luckify/data/dto/response_dto.dart';
import 'package:luckify/data/mapper/base_mapper.dart';
import 'package:luckify/data/mapper/choice_mapper.dart';
import 'package:luckify/domain/entity/response_entity.dart';

class ResponseMapper implements BaseMapper<ResponseDTO, ResponseEntity> {
  final ChoiceMapper _choiceMapper;

  ResponseMapper(this._choiceMapper);

  @override
  ResponseDTO toDTO(ResponseEntity entity) {
    return ResponseDTO(
      id: entity.id,
      object: entity.object,
      created: entity.created.millisecondsSinceEpoch ~/ 1000,
      model: entity.model,
      choices: entity.choices.map((choice) => _choiceMapper.toDTO(choice)).toList(),
    );
  }

  @override
  ResponseEntity toEntity(ResponseDTO dto) {
    return ResponseEntity(
      id: dto.id,
      object: dto.object,
      created: DateTime.fromMillisecondsSinceEpoch(dto.created * 1000),
      model: dto.model,
      choices: dto.choices.map((choice) => _choiceMapper.toEntity(choice)).toList(),
    );
  }
}