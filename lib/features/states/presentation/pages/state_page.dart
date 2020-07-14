import 'package:covid19india/core/common/widgets/footer.dart';
import 'package:covid19india/core/common/widgets/measure_size.dart';
import 'package:covid19india/core/common/widgets/my_app_bar.dart';
import 'package:covid19india/core/entity/region.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/district/district_top_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/level/daily_count_level_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_explorer_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_switcher.dart';
import 'package:covid19india/features/states/presentation/widgets/header/header_widget.dart';
import 'package:covid19india/features/states/presentation/widgets/meta/state_meta_widget.dart';
import 'package:covid19india/features/time_series/presentation/bloc/state_time_series/bloc.dart';
import 'package:covid19india/features/time_series/presentation/widgets/bargraph/delta_bar_graph_widget.dart';
import 'package:covid19india/features/time_series/presentation/widgets/minigraph/state_time_series_minigraph_widget.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_explorer_widget.dart';
import 'package:covid19india/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatePageArguments {
  final Region region;

  StatePageArguments({this.region});
}

class StatePage extends StatefulWidget {
  static const routeName = '/state';

  final Region region;

  StatePage({this.region}) : assert(region != null);

  @override
  _StatePageState createState() => _StatePageState();
}

class _StatePageState extends State<StatePage> {
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  DailyCountBloc _dailyCountBloc;
  StateTimeSeriesBloc _timeSeriesBloc;

  DateTime date = new DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

  String statistic;

  Region regionHighlighted;

  Size mapSwitcherSize = Size(0, 0);

  @override
  void initState() {
    super.initState();

    _dailyCountBloc = sl<DailyCountBloc>();
    _timeSeriesBloc = sl<StateTimeSeriesBloc>();

    statistic = 'confirmed';

    regionHighlighted = widget.region;
  }

  @override
  void dispose() {
    super.dispose();

    _dailyCountBloc.close();
    _timeSeriesBloc.close();
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
              create: (_) => _timeSeriesBloc
                ..add(GetTimeSeriesData(
                    stateCode: widget.region.stateCode, cache: false))),
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
          HeaderWidget(
            stateCode: widget.region.stateCode,
            statistic: statistic,
          ),
          Stack(
            children: [
              MeasureSize(
                onChange: (Size size) {
                  this.setState(() {
                    mapSwitcherSize = size;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DailyCountLevelWidget(stateCode: widget.region.stateCode),
                    StateTimeSeriesMiniGraphWidget(date: date),
                  ],
                ),
              ),
              MapSwitcher(
                height: mapSwitcherSize.height,
                statistic: statistic,
                setStatistic: (String newStatistic) {
                  setState(() {
                    statistic = newStatistic;
                  });
                },
              )
            ],
          ),
          MapExplorerWidget(
            statistic: statistic,
            stateCode: widget.region.stateCode,
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
          StateMetaWidget(
            stateCode: widget.region.stateCode,
          ),
          DistrictTopWidget(
            stateCode: widget.region.stateCode,
            statistic: statistic,
          ),
          DeltaBarGraphWidget(
            stateCode: widget.region.stateCode,
            statistic: statistic,
          ),
          TimeSeriesExplorerWidget(
            stateCode: widget.region.stateCode,
            timelineDate: date,
            regionHighlighted: regionHighlighted,
            setRegionHighlighted: (Region newRegionHighlighted) {
              print(newRegionHighlighted);
              setState(() {
                regionHighlighted = newRegionHighlighted;
              });
            },
          ),
          Footer(),
        ],
      ),
    );
  }

  Future<Null> _refreshAll() async {
    refreshKey.currentState?.show(atTop: false);
    _dailyCountBloc..add(GetDailyCountData(forced: true, date: date));
    _timeSeriesBloc
      ..add(GetTimeSeriesData(
          forced: true, stateCode: widget.region.stateCode, cache: false));

    setState(() {});
  }
}
