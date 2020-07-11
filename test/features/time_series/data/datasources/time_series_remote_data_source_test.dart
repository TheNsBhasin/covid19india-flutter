import 'package:covid19india/core/constants/endpoints.dart';
import 'package:covid19india/core/error/exceptions.dart';
import 'package:covid19india/core/model/stats_model.dart';
import 'package:covid19india/features/time_series/data/datasources/time_series_remote_data_source.dart';
import 'package:covid19india/features/time_series/data/models/state_wise_time_series_model.dart';
import 'package:covid19india/features/time_series/data/models/time_series_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  TimeSeriesRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TimeSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixture('input_timeseries.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getTimeSeries', () {
    final tTimeSeriesModel = [
      StateWiseTimeSeriesModel(
        name: "AN",
        timeSeries: [
          TimeSeriesModel(
            date: DateTime.parse('2020-03-26'),
            total:
                StatsModel(confirmed: 1, recovered: 0, deceased: 0, tested: 0),
            delta:
                StatsModel(confirmed: 1, recovered: 0, deceased: 0, tested: 0),
          ),
          TimeSeriesModel(
            date: DateTime.parse('2020-03-27'),
            total:
                StatsModel(confirmed: 6, recovered: 0, deceased: 0, tested: 0),
            delta:
                StatsModel(confirmed: 5, recovered: 0, deceased: 0, tested: 0),
          )
        ],
      ),
      StateWiseTimeSeriesModel(
        name: "AP",
        timeSeries: [
          TimeSeriesModel(
            date: DateTime.parse('2020-03-12'),
            total:
                StatsModel(confirmed: 1, recovered: 0, deceased: 0, tested: 0),
            delta:
                StatsModel(confirmed: 1, recovered: 0, deceased: 0, tested: 0),
          ),
          TimeSeriesModel(
            date: DateTime.parse('2020-03-13'),
            total:
                StatsModel(confirmed: 1, recovered: 0, deceased: 0, tested: 0),
            delta:
                StatsModel(confirmed: 0, recovered: 0, deceased: 0, tested: 0),
          )
        ],
      )
    ];

    test(
      '''should perform a GET request on a URL being 
      the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getTimeSeries();
        // assert
        verify(mockHttpClient.get(
          Endpoints.TIME_SERIES,
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
        final result = await dataSource.getTimeSeries();
        // assert
        expect(result, equals(tTimeSeriesModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getTimeSeries;
        // assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
