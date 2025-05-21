import 'package:luckify/core/exceptions/fortune_exception.dart';
import 'package:luckify/core/exceptions/network_error.dart';
import 'package:luckify/core/logger/logger.dart';
import 'package:luckify/data/network/network_client_interface.dart';
import 'package:luckify/data/api/open_ai_chat_api.dart';
import 'package:luckify/data/dto/response_dto.dart';
import 'package:luckify/data/mapper/request_mapper.dart';
import 'package:luckify/data/mapper/response_mapper.dart';
import 'package:luckify/data/repository/base_repository.dart';
import 'package:luckify/domain/entity/request_entity.dart';
import 'package:luckify/domain/entity/response_entity.dart';
import 'package:luckify/domain/repository/fortune_repository.dart';

class FortuneRepositoryImpl extends BaseRepository
    implements FortuneRepository {
  final NetworkClientInterface networkClient;
  final RequestMapper requestMapper;
  final ResponseMapper responseMapper;
  final String apiKey;

  FortuneRepositoryImpl({
    required this.networkClient,
    required this.requestMapper,
    required this.responseMapper,
    required this.apiKey,
    super.logger,
  }) : super(tag: 'Fortune');

  FortuneException _mapNetworkException(NetworkException e) {
    switch (e.type) {
      case NetworkError.unauthorized:
      case NetworkError.notFound:
      case NetworkError.serverError:
        return FortuneException(FortuneError.apiError, e);
      case NetworkError.parsingFailed:
        return FortuneException(FortuneError.parsingError, e);
      case NetworkError.invalidURL:
      case NetworkError.badRequest:
        return FortuneException(FortuneError.invalidResponse, e);
      default:
        return FortuneException(FortuneError.networkError, e);
    }
  }

  @override
  Future<ResponseEntity> fetchFortuneFromAPI(RequestEntity request) {
    return executeWithLogging(() async {
      try {
        final api = OpenAIChatApi(
          request: requestMapper.toDTO(request),
          apiKey: apiKey,
        );

        final responseDTO = await networkClient.send<ResponseDTO>(
          api: api,
          fromJson: ResponseDTO.fromJson,
        );

        return responseMapper.toEntity(responseDTO);
      } on FortuneException {
        rethrow;
      } on NetworkException catch (e) {
        throw _mapNetworkException(e);
      } catch (e) {
        throw FortuneException(FortuneError.unknown, e is Exception ? e : null);
      }
    }, '운세 API 요청');
  }
}