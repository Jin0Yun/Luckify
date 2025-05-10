import 'package:luckify/core/constants/api_constants.dart';
import 'package:luckify/data/dto/message_dto.dart';

class RequestDTO {
  final String model;
  final List<MessageDTO> messages;

  const RequestDTO({required this.model, required this.messages});

  factory RequestDTO.withDefaultModel({required List<MessageDTO> messages}) {
    return RequestDTO(model: ApiConstants.gpt4oMini, messages: messages);
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'messages': messages.map((msg) => msg.toJson()).toList(),
    };
  }
}