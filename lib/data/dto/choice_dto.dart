import 'package:luckify/data/dto/message_dto.dart';

class ChoiceDTO {
  final int index;
  final MessageDTO message;

  const ChoiceDTO({required this.index, required this.message});

  factory ChoiceDTO.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ChoiceDTO(
        index: 0,
        message: MessageDTO(role: 'assistant', content: ''),
      );
    }
    return ChoiceDTO(
      index: json['index'] ?? 0,
      message: MessageDTO.fromJson(json['message']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'index': index, 'message': message.toJson()};
  }
}
