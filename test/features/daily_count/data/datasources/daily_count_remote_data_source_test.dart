import 'package:covid19india/core/constants/endpoints.dart';
import 'package:covid19india/core/error/exceptions.dart';
import 'package:covid19india/features/daily_count/data/datasources/daily_count_remote_data_source.dart';
import 'package:covid19india/features/daily_count/data/models/district_wise_daily_count_model.dart';
import 'package:covid19india/features/daily_count/data/models/metadata_model.dart';
import 'package:covid19india/features/daily_count/data/models/state_wise_daily_count_model.dart';
import 'package:covid19india/features/daily_count/data/models/stats_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  DailyCountRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = DailyCountRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixture('dailycount.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getDailyCounts', () {
    final tDailyCountModel = [
      StateWiseDailyCountModel(
          name: "AN",
          total: StatsModel(
              confirmed: 48, recovered: 37, deceased: 0, tested: 12930),
          delta: StatsModel(confirmed: 0, recovered: 0, deceased: 0, tested: 0),
          metadata: MetadataModel(
              lastUpdated: "2020-06-21T19:36:22+05:30",
              notes: "",
              tested: {
                'last_updated': "2020-06-19",
                'source': "https://dhs.andaman.gov.in/NewEvents/300.pdf"
              }),
          districts: [
            DistrictWiseDailyCountModel(
                name: "North and Middle Andaman",
                total: StatsModel(
                    confirmed: 1, recovered: 1, deceased: 0, tested: 0),
                delta: StatsModel(
                    confirmed: 0, recovered: 0, deceased: 0, tested: 0)),
            DistrictWiseDailyCountModel(
                name: "South Andaman",
                total: StatsModel(
                    confirmed: 35, recovered: 32, deceased: 0, tested: 0),
                delta: StatsModel(
                    confirmed: 0, recovered: 0, deceased: 0, tested: 0)),
            DistrictWiseDailyCountModel(
                name: "Unknown",
                total: StatsModel(
                    confirmed: 12, recovered: 4, deceased: 0, tested: 0),
                delta: StatsModel(
                    confirmed: 0, recovered: 0, deceased: 0, tested: 0)),
          ]),
    ];

    test(
      '''should perform a GET request on a URL being 
      the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getDailyCount();
        // assert
        verify(mockHttpClient.get(
          Endpoints.DAILY_COUNTS,
          headers: {
            'Content-Type': 'application/json',
          },
        ));
      },
    );

    test(
      'should return DailyCounts when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getDailyCount();
        // assert
        expect(result, equals(tDailyCountModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getDailyCount;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
