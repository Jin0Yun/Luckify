import 'package:luckify/data/dto/choice_dto.dart';
import 'package:luckify/data/mapper/message_mapper.dart';
import 'package:luckify/domain/entity/choice_entity.dart';
import 'package:luckify/data/mapper/base_mapper.dart';

class ChoiceMapper implements BaseMapper<ChoiceDTO, ChoiceEntity> {
  final MessageMapper _messageDTOMapper;

  ChoiceMapper(this._messageDTOMapper);

  @override
  ChoiceDTO toDTO(ChoiceEntity entity) {
    return ChoiceDTO(
      index: entity.index,
      message: _messageDTOMapper.toDTO(entity.message),
    );
  }

  @override
  ChoiceEntity toEntity(ChoiceDTO dto) {
    return ChoiceEntity(
      index: dto.index,
      message: _messageDTOMapper.toEntity(dto.message),
    );
  }
}