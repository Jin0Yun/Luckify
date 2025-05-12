import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:luckify/config/di/core_providers.dart';
import 'package:luckify/config/di/network_providers.dart';
import 'package:luckify/data/mapper/choice_mapper.dart';
import 'package:luckify/data/mapper/message_mapper.dart';
import 'package:luckify/data/mapper/request_mapper.dart';
import 'package:luckify/data/mapper/response_mapper.dart';
import 'package:luckify/data/repository/fortune_repository_impl.dart';
import 'package:luckify/domain/repository/fortune_repository.dart';

final messageMapperProvider = Provider<MessageMapper>((ref) => MessageMapper());

final choiceMapperProvider = Provider<ChoiceMapper>((ref) {
  return ChoiceMapper(ref.watch(messageMapperProvider));
});

final requestMapperProvider = Provider<RequestMapper>((ref) {
  return RequestMapper(ref.watch(messageMapperProvider));
});

final responseMapperProvider = Provider<ResponseMapper>((ref) {
  return ResponseMapper(ref.watch(choiceMapperProvider));
});

final fortuneRepositoryProvider = Provider<FortuneRepository>((ref) {
  return FortuneRepositoryImpl(
    networkClient: ref.watch(networkClientProvider),
    requestMapper: ref.watch(requestMapperProvider),
    responseMapper: ref.watch(responseMapperProvider),
    apiKey: ref.watch(apiKeyProvider),
  );
});