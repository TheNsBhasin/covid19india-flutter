import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/level/daily_count_level_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/table/daily_count_table_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_explorer_widget.dart';
import 'package:covid19india/features/home/presentation/widgets/action_bar.dart';
import 'package:covid19india/features/home/presentation/widgets/search_bar.dart';
import 'package:covid19india/features/time_series/presentation/bloc/bloc.dart';
import 'package:covid19india/features/time_series/presentation/widgets/minigraph/time_series_minigraph_widget.dart';
import 'package:covid19india/injection_container.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
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
      body: SafeArea(
        child: RefreshIndicator(
          key: refreshKey,
          onRefresh: _refreshAll,
          child: SingleChildScrollView(
            child: buildBody(context),
          ),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        children: <Widget>[
          buildSearchBar(),
          buildActionBar(),
          DailyCountLevelWidget(),
          TimeSeriesMiniGraphWidget(),
          DailyCountTableWidget(),
          MapExplorerWidget()
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return SearchBar();
  }

  Widget buildActionBar() {
    return ActionBar();
  }

  Future<Null> _refreshAll() async {
    refreshKey.currentState?.show(atTop: false);
    sl<DailyCountBloc>()..add(GetDailyCountData(forced: true));
    sl<TimeSeriesBloc>()..add(GetTimeSeriesData(forced: true));
  }
}
