import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/level/daily_count_level_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_explorer_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/table/daily_count_table_widget.dart';
import 'package:covid19india/features/home/presentation/widgets/action_bar/action_bar_widget.dart';
import 'package:covid19india/features/home/presentation/widgets/footer.dart';
import 'package:covid19india/features/home/presentation/widgets/search_bar.dart';
import 'package:covid19india/features/time_series/presentation/bloc/bloc.dart';
import 'package:covid19india/features/time_series/presentation/widgets/minigraph/time_series_minigraph_widget.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_explorer_widget.dart';
import 'package:covid19india/features/update_log/presentation/bloc/bloc.dart';
import 'package:covid19india/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();

    _dailyCountBloc = sl<DailyCountBloc>();
    _timeSeriesBloc = sl<TimeSeriesBloc>();
    _updateLogBloc = sl<UpdateLogBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
            text: TextSpan(
                text: 'COVID19',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[200]),
                children: [
              TextSpan(
                  text: 'IN',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent)),
              TextSpan(
                  text: 'D',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              TextSpan(
                  text: 'IA',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent)),
            ])),
      ),
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
            child: SingleChildScrollView(
              child: buildBody(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
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
                  ..add(GetDailyCountData(forced: true, date: date));
              });
            },
          ),
          DailyCountLevelWidget(),
          TimeSeriesMiniGraphWidget(
            date: date,
          ),
          DailyCountTableWidget(),
          MapExplorerWidget(),
          TimeSeriesExplorerWidget(
            date: date,
          ),
          Footer()
        ],
      ),
    );
  }

  Future<Null> _refreshAll() async {
    refreshKey.currentState?.show(atTop: false);
    _dailyCountBloc..add(GetDailyCountData(forced: true, date: date));
    _timeSeriesBloc..add(GetTimeSeriesData(forced: true));
    _updateLogBloc..add(GetUpdateLogData(forced: true));

    setState(() {});
  }
}
