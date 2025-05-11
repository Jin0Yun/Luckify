import 'package:luckify/data/dto/message_dto.dart';
import 'package:luckify/domain/entity/message_entity.dart';
import 'package:luckify/data/mapper/base_mapper.dart';
import 'package:luckify/domain/enum/message_sender.dart';
import 'package:uuid/uuid.dart';

class MessageMapper implements BaseMapper<MessageDTO, MessageEntity> {
  static final _uuid = Uuid();

  @override
  MessageDTO toDTO(MessageEntity entity) {
    return MessageDTO(
      role: entity.sender == MessageSender.user ? 'user' : 'assistant',
      content: entity.content,
    );
  }

  @override
  MessageEntity toEntity(MessageDTO dto) {
    return MessageEntity(
      id: _uuid.v4(),
      content: dto.content,
      sender: dto.role == 'user' ? MessageSender.user : MessageSender.assistant,
      timestamp: DateTime.now(),
    );
  }
}