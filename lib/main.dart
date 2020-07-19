import 'package:covid19india/core/bloc/bloc.dart';
import 'package:covid19india/core/bloc/simple_bloc_observer.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/home/presentation/pages/home_page.dart';
import 'package:covid19india/features/states/presentation/pages/state_page.dart';
import 'package:covid19india/features/time_series/presentation/bloc/bloc.dart';
import 'package:covid19india/features/update_log/presentation/bloc/bloc.dart';
import 'package:covid19india/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'core/entity/entity.dart';
import 'features/home/presentation/bloc/bloc.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  var appDir = await getApplicationDocumentsDirectory();
  var path = appDir.path;
  Hive.init(path);

  await Hive.openBox('states');
  await Hive.openBox('districts');

  Bloc.observer = SimpleBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final DateTime _now = DateTime.now();

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RouteBloc>(
            create: (context) => sl<RouteBloc>(),
          ),
          BlocProvider<TabBloc>(
            create: (context) => sl<TabBloc>(),
          ),
          BlocProvider<DateBloc>(
            create: (context) =>
                DateBloc(date: DateTime(_now.year, _now.month, _now.day)),
          ),
          BlocProvider<StatisticBloc>(
            create: (context) => sl<StatisticBloc>(),
          ),
          BlocProvider<RegionHighlightedBloc>(
            create: (context) => sl<RegionHighlightedBloc>(),
          ),
          BlocProvider<MapViewBloc>(
            create: (context) => sl<MapViewBloc>(),
          ),
          BlocProvider<MapVizBloc>(
            create: (context) => sl<MapVizBloc>(),
          ),
          BlocProvider<TimeSeriesChartBloc>(
            create: (context) => sl<TimeSeriesChartBloc>(),
          ),
          BlocProvider<DailyCountBloc>(
            create: (context) => sl<DailyCountBloc>(),
          ),
          BlocProvider<TimeSeriesBloc>(
            create: (context) => sl<TimeSeriesBloc>(),
          ),
          BlocProvider<UpdateLogBloc>(
            create: (context) => sl<UpdateLogBloc>(),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<DateBloc, DateTime>(
              listener: (context, date) {
                context.bloc<DailyCountBloc>().add(LoadDailyCount(date: date));
              },
            ),
            BlocListener<MapViewBloc, MapView>(
              listener: (context, mapView) {
                if (mapView == MapView.states) {
                  final Region regionHighlighted =
                      context.bloc<RegionHighlightedBloc>().state;

                  context.bloc<RegionHighlightedBloc>().add(
                      RegionHighlightedChanged(
                          regionHighlighted: Region(
                              stateCode: regionHighlighted.stateCode,
                              districtName: null)));
                }
              },
            ),
            BlocListener<RouteBloc, RouteState>(
              listener: (context, route) {
                print(route);

                if (route is HomeRoute) {
                  final Region regionHighlighted =
                      context.bloc<RegionHighlightedBloc>().state;

                  context.bloc<RegionHighlightedBloc>().add(
                      RegionHighlightedChanged(
                          regionHighlighted: Region(
                              stateCode: regionHighlighted.stateCode,
                              districtName: null)));
                } else if (route is StateRoute) {
                  context.bloc<RegionHighlightedBloc>().add(
                      RegionHighlightedChanged(
                          regionHighlighted: route.region));
                }
              },
            ),
          ],
          child: MaterialApp(
            title: 'COVID19 INDIA',
            theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity),
            darkTheme: ThemeData(
                brightness: Brightness.dark,
                primarySwatch: Colors.grey,
                accentColor: Colors.white),
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            initialRoute: HomePage.routeName,
            routes: {
              HomePage.routeName: (context) => HomePage(),
              StatePage.routeName: (context) => StatePage(
                    region:
                        (context.bloc<RouteBloc>().state as StateRoute).region,
                  ),
            },
          ),
        ),
      ),
    );
  }
}
