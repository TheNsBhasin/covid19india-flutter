import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/metadata.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/stats.dart';
import 'package:covid19india/features/daily_count/domain/usecases/get_daily_count.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/daily_count_event.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/daily_count_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetDailyCount extends Mock implements GetDailyCount {}

void main() {
  DailyCountBloc bloc;
  MockGetDailyCount mockGetDailyCount;

  setUp(() {
    mockGetDailyCount = MockGetDailyCount();

    bloc = DailyCountBloc(
      dailyCount: mockGetDailyCount,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetDailyCounts', () {
    final tDailyCount = [
      StateWiseDailyCount(
          name: "AN",
          total: Stats(
              confirmed: 48,
              recovered: 37,
              deceased: 0,
              tested: 12930,
              migrated: 0),
          delta: Stats(
              confirmed: 0, recovered: 0, deceased: 0, tested: 0, migrated: 0),
          metadata: Metadata(
              lastUpdated: "2020-06-21T19:36:22+05:30",
              notes: "",
              tested: {
                'last_updated': "2020-06-19",
                'source': "https://dhs.andaman.gov.in/NewEvents/300.pdf"
              },
              population: null),
          districts: [
            DistrictWiseDailyCount(
                name: "North and Middle Andaman",
                total: Stats(
                    confirmed: 1,
                    recovered: 1,
                    deceased: 0,
                    tested: 0,
                    migrated: 0),
                delta: Stats(
                    confirmed: 0,
                    recovered: 0,
                    deceased: 0,
                    tested: 0,
                    migrated: 0),
                metadata: null),
            DistrictWiseDailyCount(
                name: "South Andaman",
                total: Stats(
                    confirmed: 35,
                    recovered: 32,
                    deceased: 0,
                    tested: 0,
                    migrated: 0),
                delta: Stats(
                    confirmed: 0,
                    recovered: 0,
                    deceased: 0,
                    tested: 0,
                    migrated: 0),
                metadata: null),
            DistrictWiseDailyCount(
                name: "Unknown",
                total: Stats(
                    confirmed: 12,
                    recovered: 4,
                    deceased: 0,
                    tested: 0,
                    migrated: 0),
                delta: Stats(
                    confirmed: 0,
                    recovered: 0,
                    deceased: 0,
                    tested: 0,
                    migrated: 0),
                metadata: null),
          ]),
    ];

    test(
      'should get data from the DailyCount use case',
      () async {
        // arrange
        when(mockGetDailyCount(any))
            .thenAnswer((_) async => Right(tDailyCount));
        // act
        bloc.add(GetDailyCountData(forced: true));
        await untilCalled(mockGetDailyCount(any));
        // assert
        verify(mockGetDailyCount(Params(forced: true)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        // arrange
        when(mockGetDailyCount(any))
            .thenAnswer((_) async => Right(tDailyCount));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(dailyCounts: tDailyCount),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetDailyCountData(forced: true));
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        // arrange
        when(mockGetDailyCount(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetDailyCountData());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        // arrange
        when(mockGetDailyCount(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc, emitsInOrder(expected));
        // act
        bloc.add(GetDailyCountData());
      },
    );
  });
}
