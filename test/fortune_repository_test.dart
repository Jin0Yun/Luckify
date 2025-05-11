import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:luckify/data/repository/fortune_repository_impl.dart';
import 'package:luckify/data/network/network_client_interface.dart';
import 'package:luckify/data/mapper/request_mapper.dart';
import 'package:luckify/data/mapper/response_mapper.dart';
import 'package:luckify/domain/enum/fortune_type.dart';
import 'package:luckify/data/dto/response_dto.dart';
import 'fortune_repository_test.mocks.dart';
import 'object_builders.dart';
import 'test_constants.dart';

@GenerateMocks([NetworkClientInterface, RequestMapper, ResponseMapper])
void main() {
  group('FortuneRepositoryImpl', () {
    late FortuneRepositoryImpl repository;
    late MockNetworkClientInterface mockNetworkClient;
    late MockRequestMapper mockRequestMapper;
    late MockResponseMapper mockResponseMapper;

    setUp(() {
      mockNetworkClient = MockNetworkClientInterface();
      mockRequestMapper = MockRequestMapper();
      mockResponseMapper = MockResponseMapper();
      repository = FortuneRepositoryImpl(
        networkClient: mockNetworkClient,
        requestMapper: mockRequestMapper,
        responseMapper: mockResponseMapper,
        apiKey: TestConstants.apiKey,
      );
    });

    test('fetchFortuneFromAPI should return response entity', () async {
      // Given
      final request = ObjectBuilders.request(
        fortune: ObjectBuilders.fortune(type: FortuneType.fortuneToday),
      );

      final requestDTO = ObjectBuilders.requestDTO();
      final responseDTO = ObjectBuilders.responseDTO();
      final expectedResult = ObjectBuilders.responseEntity();

      when(mockRequestMapper.toDTO(any)).thenReturn(requestDTO);
      when(
        mockNetworkClient.send<ResponseDTO>(
          api: anyNamed('api'),
          fromJson: anyNamed('fromJson'),
        ),
      ).thenAnswer((_) async => responseDTO);
      when(mockResponseMapper.toEntity(any)).thenReturn(expectedResult);

      // When
      final result = await repository.fetchFortuneFromAPI(request);

      // Then
      expect(result, expectedResult);
      verify(mockRequestMapper.toDTO(request)).called(1);
      verify(
        mockNetworkClient.send<ResponseDTO>(
          api: anyNamed('api'),
          fromJson: anyNamed('fromJson'),
        ),
      ).called(1);
      verify(mockResponseMapper.toEntity(any)).called(1);
    });

    test(
      'fetchFortuneFromAPI should propagate exception when network fails',
      () async {
        // Given
        final request = ObjectBuilders.request();
        when(
          mockRequestMapper.toDTO(any),
        ).thenReturn(ObjectBuilders.requestDTO());
        when(
          mockNetworkClient.send<ResponseDTO>(
            api: anyNamed('api'),
            fromJson: anyNamed('fromJson'),
          ),
        ).thenThrow(Exception('Network error'));

        // When & Then
        expect(() => repository.fetchFortuneFromAPI(request), throwsException);
      },
    );

    test(
      'fetchFortuneFromAPI should propagate exception when mapper fails',
      () async {
        // Given
        final request = ObjectBuilders.request();
        when(mockRequestMapper.toDTO(any)).thenThrow(Exception('Mapper error'));

        // When & Then
        expect(() => repository.fetchFortuneFromAPI(request), throwsException);
      },
    );
  });
}