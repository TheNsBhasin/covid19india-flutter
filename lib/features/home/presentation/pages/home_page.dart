import 'package:covid19india/core/bloc/bloc.dart';
import 'package:covid19india/core/common/widgets/footer.dart';
import 'package:covid19india/core/common/widgets/my_app_bar.dart';
import 'package:covid19india/core/entity/entity.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/level/daily_count_level_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_explorer_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/table/daily_count_table_widget.dart';
import 'package:covid19india/features/home/presentation/widgets/action_bar/action_bar_widget.dart';
import 'package:covid19india/features/home/presentation/widgets/search_bar.dart';
import 'package:covid19india/features/time_series/presentation/bloc/bloc.dart';
import 'package:covid19india/features/time_series/presentation/widgets/minigraph/time_series_minigraph_widget.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_explorer_widget.dart';
import 'package:covid19india/features/update_log/presentation/bloc/bloc.dart';
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyAppBarTitle(),
      ),
      body: HomePageBody(),
    );
  }
}

class HomePageBody extends StatelessWidget {
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
                  SearchBar(),
                  ActionBarWidget(),
                  DailyCountLevelWidget(),
                  TimeSeriesMiniGraphWidget(
                    mapCodes: MapCodes.TT,
                  ),
                  DailyCountTableWidget(),
                  MapExplorerWidget(
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

    final DateTime date = context.bloc<DateBloc>().state;

    context
        .bloc<DailyCountBloc>()
        .add(LoadDailyCount(forced: true, date: date));
    context.bloc<TimeSeriesBloc>().add(LoadTimeSeries(forced: true));
    context.bloc<UpdateLogBloc>().add(LoadUpdateLog(forced: true));
  }
}
