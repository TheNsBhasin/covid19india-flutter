import 'dart:convert';

import 'package:covid19india/core/util/response_parser.dart';
import 'package:covid19india/features/daily_count/data/models/district_wise_daily_count_model.dart';
import 'package:covid19india/features/daily_count/data/models/metadata_model.dart';
import 'package:covid19india/features/daily_count/data/models/state_wise_daily_count_model.dart';
import 'package:covid19india/features/daily_count/data/models/stats_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
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
    'should be a subclass of DailyCount entity',
    () async {
      // assert
      expect(tDailyCountModel, isA<List<StateWiseDailyCountModel>>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model from the JSON',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = ResponseParser.jsonToDailyCounts(
            json.decode(fixture('dailycount.json')));

        // act
        final results = jsonMap["results"]
            .map((result) => StateWiseDailyCountModel.fromJson(result))
            .toList()
            .cast<StateWiseDailyCountModel>();

        // assert
        expect(results, tDailyCountModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = {
          "results": tDailyCountModel.map((result) => result.toJson()).toList()
        };

        // assert
        final expectedMap = {
          "results": [
            {
              "name": "AN",
              "districts": [
                {
                  "name": "North and Middle Andaman",
                  "total": {
                    "confirmed": 1,
                    "recovered": 1,
                    "deceased": 0,
                    "tested": 0
                  },
                  "delta": {
                    "confirmed": 0,
                    "recovered": 0,
                    "deceased": 0,
                    "tested": 0
                  }
                },
                {
                  "name": "South Andaman",
                  "total": {
                    "confirmed": 35,
                    "recovered": 32,
                    "deceased": 0,
                    "tested": 0
                  },
                  "delta": {
                    "confirmed": 0,
                    "recovered": 0,
                    "deceased": 0,
                    "tested": 0
                  }
                },
                {
                  "name": "Unknown",
                  "total": {
                    "confirmed": 12,
                    "recovered": 4,
                    "deceased": 0,
                    "tested": 0
                  },
                  "delta": {
                    "confirmed": 0,
                    "recovered": 0,
                    "deceased": 0,
                    "tested": 0
                  }
                }
              ],
              "metadata": {
                "last_updated": "2020-06-21T19:36:22+05:30",
                "notes": "",
                "tested": {
                  "last_updated": "2020-06-19",
                  "source": "https://dhs.andaman.gov.in/NewEvents/300.pdf"
                }
              },
              "total": {
                "confirmed": 48,
                "recovered": 37,
                "deceased": 0,
                "tested": 12930
              },
              "delta": {
                "confirmed": 0,
                "recovered": 0,
                "deceased": 0,
                "tested": 0
              }
            }
          ]
        };
        expect(result, expectedMap);
      },
    );
  });
}
