import 'package:covid19india/core/bloc/bloc.dart';
import 'package:covid19india/core/network/network_info.dart';
import 'package:covid19india/features/daily_count/data/datasources/daily_count_local_data_source.dart';
import 'package:covid19india/features/daily_count/data/datasources/daily_count_remote_data_source.dart';
import 'package:covid19india/features/daily_count/data/repositories/daily_count_repository_impl.dart';
import 'package:covid19india/features/daily_count/domain/repositories/daily_count_repository.dart';
import 'package:covid19india/features/daily_count/domain/usecases/get_daily_count.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/home/presentation/bloc/bloc.dart';
import 'package:covid19india/features/time_series/data/datasources/time_series_local_data_source.dart';
import 'package:covid19india/features/time_series/data/datasources/time_series_remote_data_source.dart';
import 'package:covid19india/features/time_series/data/repositories/time_series_repository_impl.dart';
import 'package:covid19india/features/time_series/domain/repositories/time_series_repository.dart';
import 'package:covid19india/features/time_series/domain/usecases/get_state_time_series.dart';
import 'package:covid19india/features/time_series/domain/usecases/get_time_series.dart';
import 'package:covid19india/features/time_series/presentation/bloc/bloc.dart';
import 'package:covid19india/features/update_log/data/datasources/update_log_local_data_source.dart';
import 'package:covid19india/features/update_log/data/datasources/update_log_remote_datasource.dart';
import 'package:covid19india/features/update_log/data/repositories/update_log_repository_impl.dart';
import 'package:covid19india/features/update_log/domain/repositories/update_log_repository.dart';
import 'package:covid19india/features/update_log/domain/usecases/get_last_viewed_timestamp.dart';
import 'package:covid19india/features/update_log/domain/usecases/get_update_logs.dart';
import 'package:covid19india/features/update_log/domain/usecases/store_last_viewed_timestamp.dart';
import 'package:covid19india/features/update_log/presentation/bloc/bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/entity/entity.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory<RouteBloc>(
    () => RouteBloc(),
  );

  sl.registerFactory<TabBloc>(
    () => TabBloc(),
  );

  sl.registerFactory<StatisticBloc>(
    () => StatisticBloc(statistic: Statistic.confirmed),
  );

  sl.registerFactory<RegionHighlightedBloc>(
    () => RegionHighlightedBloc(
        region: Region(stateCode: MapCodes.TT, districtName: null)),
  );

  sl.registerFactory<MapViewBloc>(
    () => MapViewBloc(mapView: MapView.states),
  );

  sl.registerFactory<MapVizBloc>(
    () => MapVizBloc(mapViz: MapViz.choropleth),
  );

  sl.registerFactory<TimeSeriesChartBloc>(
    () => TimeSeriesChartBloc(
        isLog: false,
        isUniform: true,
        chartType: TimeSeriesChartType.total,
        option: TimeSeriesOption.two_weeks),
  );

  sl.registerFactory<DailyCountBloc>(
    () => DailyCountBloc(
      dailyCount: sl(),
    ),
  );

  sl.registerFactory<TimeSeriesBloc>(
    () => TimeSeriesBloc(timeSeries: sl(), stateTimeSeries: sl()),
  );

  sl.registerFactory<UpdateLogBloc>(
    () => UpdateLogBloc(
        updateLogs: sl(),
        lastViewedTimestamp: sl(),
        storeLastViewedTimestamp: sl()),
  );

  // Use cases
  sl.registerLazySingleton<GetDailyCount>(() => GetDailyCount(sl()));
  sl.registerLazySingleton<GetTimeSeries>(() => GetTimeSeries(sl()));
  sl.registerLazySingleton<GetStateTimeSeries>(() => GetStateTimeSeries(sl()));
  sl.registerLazySingleton<GetUpdateLogs>(() => GetUpdateLogs(sl()));
  sl.registerLazySingleton<GetLastViewedTimestamp>(
      () => GetLastViewedTimestamp(sl()));
  sl.registerLazySingleton<StoreLastViewedTimestamp>(
      () => StoreLastViewedTimestamp(sl()));

  // Repository
  sl.registerLazySingleton<DailyCountRepository>(
    () => DailyCountRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<TimeSeriesRepository>(
    () => TimeSeriesRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<UpdateLogRepository>(
    () => UpdateLogRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<DailyCountRemoteDataSource>(
    () => DailyCountRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<DailyCountLocalDataSource>(
    () => DailyCountLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<TimeSeriesRemoteDataSource>(
    () => TimeSeriesRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<TimeSeriesLocalDataSource>(
    () => TimeSeriesLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<UpdateLogRemoteDataSource>(
    () => UpdateLogRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<UpdateLogLocalDataSource>(
    () => UpdateLogLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
