import 'package:luckify/data/dto/response_dto.dart';
import 'package:luckify/data/mapper/base_mapper.dart';
import 'package:luckify/data/mapper/choice_mapper.dart';
import 'package:luckify/domain/entity/response_entity.dart';

class ResponseMapper implements BaseMapper<ResponseDTO, ResponseEntity> {
  final ChoiceMapper _choiceMapper;

  ResponseMapper(this._choiceMapper);

  @override
  ResponseDTO toDTO(ResponseEntity entity) {
    throw UnimplementedError('Converting ResponseEntity to ResponseDTO is not supported');
  }

  @override
  ResponseEntity toEntity(ResponseDTO dto) {
    return ResponseEntity(
      id: dto.id,
      object: dto.object,
      created: DateTime.fromMillisecondsSinceEpoch(dto.created * 1000),
      model: dto.model,
      choices: dto.choices
          .map((choice) => _choiceMapper.toEntity(choice))
          .toList(),
    );
  }
}