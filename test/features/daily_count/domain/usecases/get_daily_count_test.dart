import 'package:covid19india/features/daily_count/domain/entities/district_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/metadata.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/stats.dart';
import 'package:covid19india/features/daily_count/domain/repositories/daily_count_repository.dart';
import 'package:covid19india/features/daily_count/domain/usecases/get_daily_count.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDailyCountRepository extends Mock implements DailyCountRepository {}

void main() {
  GetDailyCount usecase;
  MockDailyCountRepository mockDailyCountRepository;

  setUp(() {
    mockDailyCountRepository = MockDailyCountRepository();
    usecase = GetDailyCount(mockDailyCountRepository);
  });

  final tDailyCount = [
    StateWiseDailyCount(
        name: "AN",
        total: Stats(confirmed: 48, recovered: 37, deceased: 0, tested: 12930),
        delta: Stats(confirmed: 0, recovered: 0, deceased: 0, tested: 0),
        metadata: Metadata(
            lastUpdated: "2020-06-21T19:36:22+05:30",
            notes: "",
            tested: {
              'last_updated': "2020-06-19",
              'source': "https://dhs.andaman.gov.in/NewEvents/300.pdf"
            }),
        districts: [
          DistrictWiseDailyCount(
              name: "North and Middle Andaman",
              total: Stats(confirmed: 1, recovered: 1, deceased: 0, tested: 0),
              delta: Stats(confirmed: 0, recovered: 0, deceased: 0, tested: 0)),
          DistrictWiseDailyCount(
              name: "South Andaman",
              total:
                  Stats(confirmed: 35, recovered: 32, deceased: 0, tested: 0),
              delta: Stats(confirmed: 0, recovered: 0, deceased: 0, tested: 0)),
          DistrictWiseDailyCount(
              name: "Unknown",
              total: Stats(confirmed: 12, recovered: 4, deceased: 0, tested: 0),
              delta: Stats(confirmed: 0, recovered: 0, deceased: 0, tested: 0)),
        ]),
  ];

  test('Should get daily counts from repository', () async {
    // arrange
    when(mockDailyCountRepository.getDailyCount(forced: true))
        .thenAnswer((_) async => Right(tDailyCount));

    // act
    final result = await usecase(Params(forced: true));

    // assert
    expect(result, Right(tDailyCount));
    verify(mockDailyCountRepository.getDailyCount(forced: true));
    verifyNoMoreInteractions(mockDailyCountRepository);
  });
}
