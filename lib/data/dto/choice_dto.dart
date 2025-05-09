import 'package:luckify/data/dto/message_dto.dart';

class ChoiceDTO {
  final int index;
  final MessageDTO message;
  final dynamic logprobs;
  final String finishReason;

  const ChoiceDTO({
    required this.index,
    required this.message,
    this.logprobs,
    this.finishReason = '',
  });

  factory ChoiceDTO.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ChoiceDTO(index: 0, message: MessageDTO(role: 'assistant', content: ''));
    }
    return ChoiceDTO(
      index: json['index'] ?? 0,
      message: MessageDTO.fromJson(json['message']),
      logprobs: json['logprobs'],
      finishReason: json['finish_reason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'message': message.toJson(),
      if (logprobs != null) 'logprobs': logprobs,
      'finish_reason': finishReason,
    };
  }
}