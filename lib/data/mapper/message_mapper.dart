import 'package:luckify/data/dto/message_dto.dart';
import 'package:luckify/data/mapper/base_mapper.dart';
import 'package:luckify/domain/entity/message_entity.dart';
import 'package:luckify/domain/enum/message_role.dart';

class MessageMapper implements BaseMapper<MessageDTO, MessageEntity> {
  final String Function() generateId;

  MessageMapper(this.generateId);

  @override
  MessageDTO toDTO(MessageEntity entity) {
    return MessageDTO(
      role: entity.sender.name,
      content: entity.content,
    );
  }

  @override
  MessageEntity toEntity(MessageDTO dto) {
    return MessageEntity(
      id: generateId(),
      content: dto.content,
      sender: MessageRole.fromString(dto.role),
      timestamp: DateTime.now(),
    );
  }
}