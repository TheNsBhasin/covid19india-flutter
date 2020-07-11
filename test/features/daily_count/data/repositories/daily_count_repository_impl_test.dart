import 'package:covid19india/core/error/exceptions.dart';
import 'package:covid19india/core/error/failures.dart';
import 'package:covid19india/core/model/stats_model.dart';
import 'package:covid19india/core/network/network_info.dart';
import 'package:covid19india/features/daily_count/data/datasources/daily_count_local_data_source.dart';
import 'package:covid19india/features/daily_count/data/datasources/daily_count_remote_data_source.dart';
import 'package:covid19india/features/daily_count/data/models/district_wise_daily_count_model.dart';
import 'package:covid19india/features/daily_count/data/models/metadata_model.dart';
import 'package:covid19india/features/daily_count/data/models/state_wise_daily_count_model.dart';
import 'package:covid19india/features/daily_count/data/repositories/daily_count_repository_impl.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements DailyCountRemoteDataSource {}

class MockLocalDataSource extends Mock implements DailyCountLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  DailyCountRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = DailyCountRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getDailyCount', () {
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

    final List<StateWiseDailyCount> tDailyCount = tDailyCountModel;

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getDailyCount(forced: true);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getDailyCount(DateTime.now()))
              .thenAnswer((_) async => tDailyCountModel);
          // act
          final result = await repository.getDailyCount(forced: true);
          // assert
          verify(mockRemoteDataSource.getDailyCount(DateTime.now()));
          expect(result, equals(Right(tDailyCount)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getDailyCount(DateTime.now()))
              .thenAnswer((_) async => tDailyCountModel);
          // act
          await repository.getDailyCount(forced: true);
          // assert
          verify(mockRemoteDataSource.getDailyCount(DateTime.now()));
          verify(mockLocalDataSource.cacheDailyCount(tDailyCountModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getDailyCount(DateTime.now()))
              .thenThrow(ServerException());
          // act
          final result = await repository.getDailyCount(forced: true);
          // assert
          verify(mockRemoteDataSource.getDailyCount(DateTime.now()));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastDailyCount())
              .thenAnswer((_) async => tDailyCountModel);
          // act
          final result = await repository.getDailyCount(forced: true);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastDailyCount());
          expect(result, equals(Right(tDailyCount)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastDailyCount())
              .thenThrow(CacheException());
          // act
          final result = await repository.getDailyCount(forced: true);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastDailyCount());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
