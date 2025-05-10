import 'package:luckify/core/constants/api_constants.dart';
import 'package:luckify/domain/entity/fortune_entity.dart';
import 'package:luckify/domain/entity/fortune_message_entity.dart';
import 'package:luckify/domain/entity/message_entity.dart';
import 'package:luckify/domain/entity/request_entity.dart';
import 'package:luckify/domain/repository/fortune_repository.dart';

class GetFortuneReadingUseCase {
  final FortuneRepository _repository;

  GetFortuneReadingUseCase(this._repository);

  Future<FortuneMessageEntity> execute({
    required FortuneEntity fortune,
    required List<MessageEntity> messages,
    String? userInput,
    String model = ApiConstants.gpt4oMini,
  }) async {
    final request = RequestEntity(
      model: model,
      messages: messages,
      fortune: fortune,
      userInput: userInput,
    );

    return await _repository.getFortuneReading(request);
  }
}