import 'dart:convert';

import 'package:covid19india/core/error/exceptions.dart';
import 'package:covid19india/core/util/response_parser.dart';
import 'package:covid19india/features/daily_count/data/datasources/daily_count_local_data_source.dart';
import 'package:covid19india/features/daily_count/data/models/district_wise_daily_count_model.dart';
import 'package:covid19india/features/daily_count/data/models/metadata_model.dart';
import 'package:covid19india/features/daily_count/data/models/state_wise_daily_count_model.dart';
import 'package:covid19india/features/daily_count/data/models/stats_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  DailyCountLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = DailyCountLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastDailyCount', () {
    final Map<String, dynamic> jsonMap =
        json.decode(fixture('cached_data.json'));

    final tDailyCountModel = jsonMap["results"]
        .map((result) => StateWiseDailyCountModel.fromJson(result))
        .toList()
        .cast<StateWiseDailyCountModel>();

    test(
      'should return DailyCount from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('cached_data.json'));
        // act
        final result = await dataSource.getLastDailyCount();
        // assert
        verify(mockSharedPreferences.getString(CACHED_DAILY_COUNTS));
        expect(result, equals(tDailyCountModel));
      },
    );

    test(
      'should throw a CacheExeption when there is not a cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastDailyCount;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheDailyCounts', () {
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
      'should call SharedPreferences to cache the data',
      () async {
        // act
        dataSource.cacheDailyCount(tDailyCountModel);
        // assert
        final expectedJsonString =
            json.encode(ResponseParser.dailyCountsToJson(tDailyCountModel));
        verify(mockSharedPreferences.setString(
          CACHED_DAILY_COUNTS,
          expectedJsonString,
        ));
      },
    );
  });
}
