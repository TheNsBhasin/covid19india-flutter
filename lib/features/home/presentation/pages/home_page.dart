import 'package:covid19india/core/common/widgets/footer.dart';
import 'package:covid19india/core/common/widgets/my_app_bar.dart';
import 'package:covid19india/core/entity/region.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/level/daily_count_level_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_explorer_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/table/daily_count_table_widget.dart';
import 'package:covid19india/features/home/presentation/widgets/action_bar/action_bar_widget.dart';
import 'package:covid19india/features/home/presentation/widgets/search_bar.dart';
import 'package:covid19india/features/time_series/presentation/bloc/time_series/bloc.dart';
import 'package:covid19india/features/time_series/presentation/widgets/minigraph/time_series_minigraph_widget.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_explorer_widget.dart';
import 'package:covid19india/features/update_log/presentation/bloc/bloc.dart';
import 'package:covid19india/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  DailyCountBloc _dailyCountBloc;
  TimeSeriesBloc _timeSeriesBloc;
  UpdateLogBloc _updateLogBloc;

  DateTime date = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  String statistic;

  Region regionHighlighted;

  @override
  void initState() {
    super.initState();

    _dailyCountBloc = sl<DailyCountBloc>();
    _timeSeriesBloc = sl<TimeSeriesBloc>();
    _updateLogBloc = sl<UpdateLogBloc>();

    statistic = 'confirmed';

    regionHighlighted = new Region(
      stateCode: 'TT',
      districtName: null,
    );
  }

  @override
  void dispose() {
    super.dispose();

    _dailyCountBloc.close();
    _timeSeriesBloc.close();
    _updateLogBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) =>
                  _dailyCountBloc..add(GetDailyCountData(date: date))),
          BlocProvider(
              create: (_) => _timeSeriesBloc..add(GetTimeSeriesData())),
          BlocProvider(create: (_) => _updateLogBloc..add(GetUpdateLogData())),
        ],
        child: SafeArea(
          child: RefreshIndicator(
            key: refreshKey,
            onRefresh: _refreshAll,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: buildBody(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SearchBar(),
          ActionBarWidget(
            date: date,
            setDate: (DateTime newDate) {
              setState(() {
                date = newDate;
                _dailyCountBloc
                  ..add(
                      GetDailyCountData(forced: true, date: date, cache: true));
              });
            },
          ),
          DailyCountLevelWidget(),
          TimeSeriesMiniGraphWidget(
            date: date,
          ),
          DailyCountTableWidget(),
          MapExplorerWidget(
            statistic: statistic,
            setStatistic: (String newStatistic) {
              setState(() {
                statistic = newStatistic;
              });
            },
            regionHighlighted: regionHighlighted,
            setRegionHighlighted: (Region newRegionHighlighted) {
              setState(() {
                regionHighlighted = newRegionHighlighted;
              });
            },
          ),
          TimeSeriesExplorerWidget(
            stateCode: 'TT',
            timelineDate: date,
            regionHighlighted: regionHighlighted,
            setRegionHighlighted: (Region newRegionHighlighted) {
              print(newRegionHighlighted);
              setState(() {
                regionHighlighted = newRegionHighlighted;
              });
            },
          ),
          Footer()
        ],
      ),
    );
  }

  Future<Null> _refreshAll() async {
    refreshKey.currentState?.show(atTop: false);
    _dailyCountBloc
      ..add(GetDailyCountData(forced: true, date: date, cache: true));
    _timeSeriesBloc..add(GetTimeSeriesData(forced: true));
    _updateLogBloc..add(GetUpdateLogData(forced: true));

    setState(() {});
  }
}
