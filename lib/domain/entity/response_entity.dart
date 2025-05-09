import 'package:luckify/domain/entity/choice_entity.dart';

class ResponseEntity {
  final String id;
  final String object;
  final DateTime created;
  final String model;
  final List<ChoiceEntity> choices;

  const ResponseEntity({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.choices,
  });
}