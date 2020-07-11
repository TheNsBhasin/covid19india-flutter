import 'package:covid19india/core/common/widgets/footer.dart';
import 'package:covid19india/core/common/widgets/measure_size.dart';
import 'package:covid19india/core/common/widgets/my_app_bar.dart';
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
import 'package:covid19india/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatePageArguments {
  final String stateCode;
  final String districtName;

  StatePageArguments({this.stateCode, this.districtName});
}

class StatePage extends StatefulWidget {
  static const routeName = '/state';

  final String stateCode;
  final String districtName;

  StatePage({this.stateCode, this.districtName}) : assert(stateCode != null);

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

  Map<String, String> regionHighlighted;

  Size mapSwitcherSize = Size(0, 0);

  @override
  void initState() {
    super.initState();

    _dailyCountBloc = sl<DailyCountBloc>();
    _timeSeriesBloc = sl<StateTimeSeriesBloc>();

    statistic = 'confirmed';

    regionHighlighted = {
      'stateCode': widget.stateCode,
      'districtName': widget.districtName,
    };
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
                    stateCode: widget.stateCode, cache: false))),
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
            stateCode: widget.stateCode,
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
                    DailyCountLevelWidget(stateCode: widget.stateCode),
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
            stateCode: widget.stateCode,
            setStatistic: (String newStatistic) {
              setState(() {
                statistic = newStatistic;
              });
            },
            regionHighlighted: regionHighlighted,
            setRegionHighlighted: (Map<String, String> newRegionHighlighted) {
              setState(() {
                regionHighlighted = newRegionHighlighted;
              });
            },
          ),
          StateMetaWidget(
            stateCode: widget.stateCode,
          ),
          DistrictTopWidget(
            stateCode: widget.stateCode,
            statistic: statistic,
          ),
          DeltaBarGraphWidget(
            stateCode: widget.stateCode,
            statistic: statistic,
            lookback: 6,
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
          forced: true, stateCode: widget.stateCode, cache: false));

    setState(() {});
  }
}
