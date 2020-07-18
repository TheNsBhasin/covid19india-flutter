import 'package:covid19india/core/bloc/bloc.dart';
import 'package:covid19india/core/common/widgets/footer.dart';
import 'package:covid19india/core/common/widgets/measure_size.dart';
import 'package:covid19india/core/common/widgets/my_app_bar.dart';
import 'package:covid19india/core/common/widgets/not_found.dart';
import 'package:covid19india/core/entity/entity.dart';
import 'package:covid19india/core/entity/region.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/district/district_top_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/header/header_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/level/daily_count_level_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_explorer_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_switcher.dart';
import 'package:covid19india/features/states/presentation/bloc/bloc.dart';
import 'package:covid19india/features/states/presentation/widgets/meta/state_meta_widget.dart';
import 'package:covid19india/features/states/presentation/widgets/tab/tab_selector.dart';
import 'package:covid19india/features/time_series/presentation/bloc/bloc.dart';
import 'package:covid19india/features/time_series/presentation/widgets/bargraph/delta_bar_graph_widget.dart';
import 'package:covid19india/features/time_series/presentation/widgets/minigraph/time_series_minigraph_widget.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_explorer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatePage extends StatefulWidget {
  static const routeName = '/state';

  final Region region;

  StatePage({this.region});

  @override
  _StatePageState createState() => _StatePageState();
}

class _StatePageState extends State<StatePage> {
  @override
  void initState() {
    super.initState();

    context
        .bloc<TimeSeriesBloc>()
        .add(UpdateTimeSeries(mapCode: widget.region.stateCode));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.bloc<RouteBloc>().add(NavigateToHomePage());

        Navigator.pop(context);
        return true;
      },
      child: BlocProvider<TabBloc>(
        create: (context) => TabBloc(),
        child: BlocBuilder<TabBloc, StateTab>(
          builder: (context, activeTab) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: MyAppBarTitle(),
              ),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  switch (activeTab) {
                    case StateTab.map:
                      return MapTab(
                        region: widget.region,
                      );
                    case StateTab.meta:
                      return InfoTab(
                        region: widget.region,
                      );
                    case StateTab.bar:
                      return BarTab(
                        region: widget.region,
                      );
                    case StateTab.chart:
                      return ChartTab(
                        region: widget.region,
                      );
                    default:
                      return NotFound();
                  }
                },
              ),
              bottomNavigationBar: TabSelector(
                activeTab: activeTab,
                onTabSelected: (tab) =>
                    BlocProvider.of<TabBloc>(context).add(TabChanged(tab: tab)),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MapTab extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  final Region region;
  final Size mapSwitcherSize = Size(0, 0);

  MapTab({this.region});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        key: refreshKey,
        onRefresh: () => refreshData(context),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    HeaderWidget(
                      stateCode: region.stateCode,
                    ),
                    Stack(
                      children: [
                        MeasureSize(
                          onChange: (Size size) {
//                            this.setState(() {
//                              mapSwitcherSize = size;
//                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DailyCountLevelWidget(
                                stateCode: region.stateCode,
                              ),
                              TimeSeriesMiniGraphWidget(
                                mapCodes: region.stateCode,
                              ),
                            ],
                          ),
                        ),
                        MapSwitcher(
                          height: mapSwitcherSize.height,
                        ),
                      ],
                    ),
                    MapExplorerWidget(
                      stateCode: region.stateCode,
                    ),
                    Footer(),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> refreshData(BuildContext context) async {
    refreshKey.currentState?.show(atTop: false);

    final DateTime date = context.bloc<DateBloc>().state;

    context
        .bloc<DailyCountBloc>()
        .add(LoadDailyCount(forced: true, date: date));

    context
        .bloc<TimeSeriesBloc>()
        .add(UpdateTimeSeries(forced: true, mapCode: region.stateCode));
  }
}

class InfoTab extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  final Region region;
  final Size mapSwitcherSize = Size(0, 0);

  InfoTab({this.region});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        key: refreshKey,
        onRefresh: () => refreshData(context),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    HeaderWidget(
                      stateCode: region.stateCode,
                    ),
                    StateMetaWidget(
                      stateCode: region.stateCode,
                    ),
                    Footer(),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> refreshData(BuildContext context) async {
    refreshKey.currentState?.show(atTop: false);

    final DateTime date = context.bloc<DateBloc>().state;

    context
        .bloc<DailyCountBloc>()
        .add(LoadDailyCount(forced: true, date: date));

    context
        .bloc<TimeSeriesBloc>()
        .add(UpdateTimeSeries(forced: true, mapCode: region.stateCode));
  }
}

class BarTab extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  final Region region;
  final Size mapSwitcherSize = Size(0, 0);

  BarTab({this.region});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        key: refreshKey,
        onRefresh: () => refreshData(context),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    HeaderWidget(
                      stateCode: region.stateCode,
                    ),
                    DistrictTopWidget(
                      stateCode: region.stateCode,
                    ),
                    DeltaBarGraphWidget(
                      stateCode: region.stateCode,
                    ),
                    Footer(),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> refreshData(BuildContext context) async {
    refreshKey.currentState?.show(atTop: false);

    final DateTime date = context.bloc<DateBloc>().state;

    context
        .bloc<DailyCountBloc>()
        .add(LoadDailyCount(forced: true, date: date));

    context
        .bloc<TimeSeriesBloc>()
        .add(UpdateTimeSeries(forced: true, mapCode: region.stateCode));
  }
}

class ChartTab extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  final Region region;
  final Size mapSwitcherSize = Size(0, 0);

  ChartTab({this.region});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        key: refreshKey,
        onRefresh: () => refreshData(context),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    HeaderWidget(
                      stateCode: region.stateCode,
                    ),
                    TimeSeriesExplorerWidget(
                      stateCode: region.stateCode,
                    ),
                    Footer(),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> refreshData(BuildContext context) async {
    refreshKey.currentState?.show(atTop: false);

    final DateTime date = context.bloc<DateBloc>().state;

    context
        .bloc<DailyCountBloc>()
        .add(LoadDailyCount(forced: true, date: date));

    context
        .bloc<TimeSeriesBloc>()
        .add(UpdateTimeSeries(forced: true, mapCode: region.stateCode));
  }
}
