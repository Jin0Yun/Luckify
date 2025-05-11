import 'package:luckify/data/network/network_client_interface.dart';
import 'package:luckify/data/api/open_ai_chat_api.dart';
import 'package:luckify/data/dto/response_dto.dart';
import 'package:luckify/data/mapper/request_mapper.dart';
import 'package:luckify/data/mapper/response_mapper.dart';
import 'package:luckify/domain/entity/request_entity.dart';
import 'package:luckify/domain/entity/response_entity.dart';
import 'package:luckify/domain/repository/fortune_repository.dart';

class FortuneRepositoryImpl implements FortuneRepository {
  final NetworkClientInterface networkClient;
  final RequestMapper requestMapper;
  final ResponseMapper responseMapper;
  final String apiKey;

  const FortuneRepositoryImpl({
    required this.networkClient,
    required this.requestMapper,
    required this.responseMapper,
    required this.apiKey,
  });

  @override
  Future<ResponseEntity> fetchFortuneFromAPI(RequestEntity request) async {
    final api = OpenAIChatApi(
      request: requestMapper.toDTO(request),
      apiKey: apiKey,
    );

    final responseDTO = await networkClient.send<ResponseDTO>(
      api: api,
      fromJson: ResponseDTO.fromJson,
    );

    return responseMapper.toEntity(responseDTO);
  }
}