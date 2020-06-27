import 'dart:convert';

import 'package:covid19india/core/error/exceptions.dart';
import 'package:covid19india/core/util/response_parser.dart';
import 'package:covid19india/features/time_series/data/datasources/time_series_local_data_source.dart';
import 'package:covid19india/features/time_series/data/models/state_wise_time_series_model.dart';
import 'package:covid19india/features/time_series/data/models/stats_model.dart';
import 'package:covid19india/features/time_series/data/models/time_series_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TimeSeriesLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = TimeSeriesLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastTimeSeries', () {
    final Map<String, dynamic> jsonMap =
        json.decode(fixture('cached_timeseries.json'));

    final tTimeSeriesModel = jsonMap["results"]
        .map((result) => StateWiseTimeSeriesModel.fromJson(result))
        .toList()
        .cast<StateWiseTimeSeriesModel>();

    test(
      'should return TimeSeries from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('cached_timeseries.json'));
        // act
        final result = await dataSource.getLastTimeSeries();
        // assert
        verify(mockSharedPreferences.getString(CACHED_TIME_SERIES));
        expect(result, equals(tTimeSeriesModel));
      },
    );

    test(
      'should throw a CacheException when there is not a cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastTimeSeries;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheTimeSeries', () {
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
      'should call SharedPreferences to cache the data',
      () async {
        // act
        dataSource.cacheTimeSeries(tTimeSeriesModel);
        // assert
        final expectedJsonString =
            json.encode(ResponseParser.timeSeriesToJson(tTimeSeriesModel));
        verify(mockSharedPreferences.setString(
          CACHED_TIME_SERIES,
          expectedJsonString,
        ));
      },
    );
  });
}
