import 'package:covid19india/core/common/widgets/footer.dart';
import 'package:covid19india/core/common/widgets/my_app_bar.dart';
import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/entity/region.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/level/daily_count_level_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_explorer_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/table/daily_count_table_widget.dart';
import 'package:covid19india/features/home/presentation/bloc/page_bloc.dart';
import 'package:covid19india/features/home/presentation/widgets/action_bar/action_bar_widget.dart';
import 'package:covid19india/features/home/presentation/widgets/search_bar.dart';
import 'package:covid19india/features/time_series/presentation/bloc/time_series/bloc.dart';
import 'package:covid19india/features/time_series/presentation/widgets/minigraph/time_series_minigraph_widget.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_explorer_widget.dart';
import 'package:covid19india/features/update_log/presentation/bloc/bloc.dart';
import 'package:covid19india/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyAppBarTitle(),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<DailyCountBloc>(
              create: (_) => sl<DailyCountBloc>()
                ..add(GetDailyCountData(
                    date: context.bloc<HomePageBloc>().state.date))),
          BlocProvider<TimeSeriesBloc>(
              create: (_) => sl<TimeSeriesBloc>()..add(GetTimeSeriesData())),
          BlocProvider<UpdateLogBloc>(
              create: (_) => sl<UpdateLogBloc>()..add(GetUpdateLogData())),
        ],
        child: HomePageBody(),
      ),
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
                  MyActionBar(),
                  DailyCountLevelWidget(),
                  MyTimeSeriesMiniGraph(),
                  DailyCountTableWidget(),
                  MyMapExplorer(),
                  MyTimeSeriesExplorer(),
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

    final DateTime date = BlocProvider.of<HomePageBloc>(context).state.date;

    BlocProvider.of<DailyCountBloc>(context)
        .add(GetDailyCountData(forced: true, date: date, cache: true));

    BlocProvider.of<TimeSeriesBloc>(context)
        .add(GetTimeSeriesData(forced: true, cache: true));

    BlocProvider.of<UpdateLogBloc>(context).add(GetUpdateLogData(forced: true));
  }
}

class MyActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      condition: (previous, current) => previous.date != current.date,
      builder: (context, state) {
        return ActionBarWidget(
          date: state.date,
          setDate: (DateTime newDate) {
            BlocProvider.of<HomePageBloc>(context).add(DateChanged(
              date: newDate,
            ));

            BlocProvider.of<DailyCountBloc>(context).add(GetDailyCountData(
              forced: true,
              date: newDate,
              cache: true,
            ));
          },
        );
      },
    );
  }
}

class MyTimeSeriesMiniGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      condition: (previous, current) => previous.date != current.date,
      builder: (context, state) {
        return TimeSeriesMiniGraphWidget(
          date: state.date,
        );
      },
    );
  }
}

class MyMapExplorer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      condition: (previous, current) =>
          previous.statistic != current.statistic ||
          previous.regionHighlighted != current.regionHighlighted,
      builder: (context, state) {
        return MapExplorerWidget(
          statistic: state.statistic,
          setStatistic: (STATISTIC newStatistic) {
            BlocProvider.of<HomePageBloc>(context)
                .add(StatisticChanged(statistic: newStatistic));
          },
          regionHighlighted: state.regionHighlighted,
          setRegionHighlighted: (Region newRegionHighlighted) {
            BlocProvider.of<HomePageBloc>(context).add(RegionHighlightedChanged(
                regionHighlighted: newRegionHighlighted));
          },
        );
      },
    );
  }
}

class MyTimeSeriesExplorer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      condition: (previous, current) =>
          previous.date != current.date ||
          previous.regionHighlighted != current.regionHighlighted,
      builder: (context, state) {
        return TimeSeriesExplorerWidget(
          stateCode: 'TT',
          timelineDate: state.date,
          regionHighlighted: state.regionHighlighted,
          setRegionHighlighted: (Region newRegionHighlighted) {
            BlocProvider.of<HomePageBloc>(context).add(RegionHighlightedChanged(
                regionHighlighted: newRegionHighlighted));
          },
        );
      },
    );
  }
}
