import 'package:luckify/data/dto/request_dto.dart';
import 'package:luckify/data/mapper/base_mapper.dart';
import 'package:luckify/data/mapper/message_mapper.dart';
import 'package:luckify/domain/entity/request_entity.dart';

class RequestMapper implements BaseMapper<RequestDTO, RequestEntity> {
  final MessageMapper _messageMapper;

  RequestMapper(this._messageMapper);

  @override
  RequestDTO toDTO(RequestEntity entity) {
    return RequestDTO(
      model: entity.model,
      messages: entity.messages
          .map((msg) => _messageMapper.toDTO(msg))
          .toList(),
    );
  }

  @override
  RequestEntity toEntity(RequestDTO dto) {
    return RequestEntity(
      model: dto.model,
      messages: dto.messages
          .map((msg) => _messageMapper.toEntity(msg))
          .toList(),
    );
  }
}