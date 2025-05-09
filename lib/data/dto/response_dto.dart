import 'package:luckify/data/dto/choice_dto.dart';
import 'package:luckify/data/dto/usage_dto.dart';

class ResponseDTO {
  final String id;
  final String object;
  final int created;
  final String model;
  final List<ChoiceDTO> choices;
  final UsageDTO usage;
  final String? systemFingerprint;

  const ResponseDTO({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
    required this.usage,
    this.systemFingerprint,
  });

  factory ResponseDTO.fromJson(Map<String, dynamic> json) {
    return ResponseDTO(
      id: json['id'] ?? '',
      object: json['object'] ?? '',
      created: json['created'] ?? 0,
      model: json['model'] ?? '',
      choices:
          (json['choices'] as List? ?? [])
              .map((choice) => ChoiceDTO.fromJson(choice))
              .toList(),
      usage: UsageDTO.fromJson(json['usage'] ?? {}),
      systemFingerprint: json['system_fingerprint'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'object': object,
      'created': created,
      'model': model,
      'choices': choices.map((choice) => choice.toJson()).toList(),
      'usage': usage.toJson(),
      if (systemFingerprint != null) 'system_fingerprint': systemFingerprint,
    };
  }
}