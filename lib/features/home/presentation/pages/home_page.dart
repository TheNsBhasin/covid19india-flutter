import 'package:covid19india/core/bloc/bloc.dart';
import 'package:covid19india/core/common/widgets/footer.dart';
import 'package:covid19india/core/common/widgets/my_app_bar.dart';
import 'package:covid19india/core/common/widgets/not_found.dart';
import 'package:covid19india/core/entity/entity.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/header/header_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/level/daily_count_level_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_explorer_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/table/daily_count_table_widget.dart';
import 'package:covid19india/features/home/presentation/bloc/bloc.dart';
import 'package:covid19india/features/home/presentation/widgets/search/search_bar.dart';
import 'package:covid19india/features/home/presentation/widgets/tab/tab_selector.dart';
import 'package:covid19india/features/states/presentation/pages/state_page.dart';
import 'package:covid19india/features/time_series/presentation/bloc/bloc.dart';
import 'package:covid19india/features/time_series/presentation/widgets/minigraph/time_series_minigraph_widget.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_explorer_widget.dart';
import 'package:covid19india/features/update_log/presentation/bloc/bloc.dart';
import 'package:covid19india/features/update_log/presentation/widgets/updates/updates_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    final DateTime date = context.bloc<DateBloc>().state;

    context.bloc<DailyCountBloc>().add(LoadDailyCount(date: date));
    context.bloc<TimeSeriesBloc>().add(LoadTimeSeries());
    context.bloc<UpdateLogBloc>().add(LoadUpdateLog());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, HomeTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: MyAppBarTitle(),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              switch (activeTab) {
                case HomeTab.table:
                  return TableTab();
                case HomeTab.map:
                  return MapTab();
                case HomeTab.chart:
                  return ChartTab();
                case HomeTab.notification:
                  return NotificationTab();
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
    );
  }
}

class TableTab extends StatelessWidget {
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new RefreshIndicator(
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
                    stateCode: MapCodes.TT,
                  ),
                  DailyCountLevelWidget(),
                  TimeSeriesMiniGraphWidget(
                    mapCodes: MapCodes.TT,
                  ),
                  DailyCountTableWidget(),
                  Footer()
                ],
              ),
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
    context.bloc<TimeSeriesBloc>().add(LoadTimeSeries(forced: true));
  }
}

class MapTab extends StatelessWidget {
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new RefreshIndicator(
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
                    stateCode: MapCodes.TT,
                  ),
                  MapExplorerWidget(
                    stateCode: MapCodes.TT,
                  ),
                  Footer()
                ],
              ),
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
  }
}

class ChartTab extends StatelessWidget {
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new RefreshIndicator(
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
                    stateCode: MapCodes.TT,
                  ),
                  TimeSeriesExplorerWidget(
                    stateCode: MapCodes.TT,
                  ),
                  Footer()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> refreshData(BuildContext context) async {
    refreshKey.currentState?.show(atTop: false);

    context.bloc<TimeSeriesBloc>().add(LoadTimeSeries(forced: true));
  }
}

class NotificationTab extends StatelessWidget {
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new RefreshIndicator(
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
                  SearchBar(
                    navigate: (Region region) {
                      context
                          .bloc<RouteBloc>()
                          .add(NavigateToStatePage(region: region));

                      Navigator.pushNamed(context, StatePage.routeName);
                    },
                  ),
                  UpdatesWidget(),
                  Footer()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> refreshData(BuildContext context) async {
    refreshKey.currentState?.show(atTop: false);

    context.bloc<UpdateLogBloc>().add(LoadUpdateLog(forced: true));
  }
}
