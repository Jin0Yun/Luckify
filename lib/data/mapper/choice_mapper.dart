import 'package:luckify/data/dto/choice_dto.dart';
import 'package:luckify/data/mapper/base_mapper.dart';
import 'package:luckify/data/mapper/message_mapper.dart';
import 'package:luckify/domain/entity/choice_entity.dart';

class ChoiceMapper implements BaseMapper<ChoiceDTO, ChoiceEntity> {
  final MessageMapper _messageMapper;

  ChoiceMapper(this._messageMapper);

  @override
  ChoiceDTO toDTO(ChoiceEntity entity) {
    return ChoiceDTO(
      index: entity.index,
      message: _messageMapper.toDTO(entity.message),
    );
  }

  @override
  ChoiceEntity toEntity(ChoiceDTO dto) {
    return ChoiceEntity(
      index: dto.index,
      message: _messageMapper.toEntity(dto.message),
    );
  }
}