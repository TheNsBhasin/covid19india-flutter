import 'package:covid19india/core/common/widgets/footer.dart';
import 'package:covid19india/core/common/widgets/measure_size.dart';
import 'package:covid19india/core/common/widgets/my_app_bar.dart';
import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/entity/region.dart';
import 'package:covid19india/features/daily_count/presentation/bloc/bloc.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/district/district_top_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/level/daily_count_level_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_explorer_widget.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_switcher.dart';
import 'package:covid19india/features/states/presentation/bloc/page_bloc.dart';
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

class StatePage extends StatelessWidget {
  static const routeName = '/state';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyAppBarTitle(),
      ),
      body: BlocBuilder<StatePageBloc, StatePageState>(
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (_) => sl<DailyCountBloc>()
                    ..add(GetDailyCountData(date: state.date))),
              BlocProvider(
                  create: (_) => sl<StateTimeSeriesBloc>()
                    ..add(GetTimeSeriesData(
                        stateCode: state.region.stateCode, cache: true))),
            ],
            child: StatePageBody(),
          );
        },
      ),
    );
  }
}

class StatePageBody extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

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
                    MyHeader(),
                    MySwitcher(),
                    MyMapExplorer(),
                    MyStateMeta(),
                    MyDistrictTop(),
                    MyDeltaBarGraph(),
                    MyTimeSeriesExplorer(),
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

    final StatePageState state = context.bloc<StatePageBloc>().state;

    BlocProvider.of<DailyCountBloc>(context)
        .add(GetDailyCountData(forced: true, date: state.date));

    BlocProvider.of<StateTimeSeriesBloc>(context).add(GetTimeSeriesData(
        forced: true, stateCode: state.region.stateCode, cache: true));
  }
}

class MyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatePageBloc, StatePageState>(
      condition: (previous, current) =>
          previous.statistic != current.statistic ||
          previous.region.stateCode != current.region.stateCode,
      builder: (context, state) {
        return HeaderWidget(
          stateCode: state.region.stateCode,
          statistic: state.statistic,
        );
      },
    );
  }
}

class MySwitcher extends StatelessWidget {
  final Size mapSwitcherSize = Size(0, 0);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatePageBloc, StatePageState>(
      condition: (previous, current) =>
          previous.statistic != current.statistic ||
          previous.region.stateCode != current.region.stateCode,
      builder: (context, state) {
        return Stack(
          children: [
            MeasureSize(
              onChange: (Size size) {
//                this.setState(() {
//                  mapSwitcherSize = size;
//                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DailyCountLevelWidget(stateCode: state.region.stateCode),
                  StateTimeSeriesMiniGraphWidget(date: state.date),
                ],
              ),
            ),
            MapSwitcher(
              height: mapSwitcherSize.height,
              statistic: state.statistic,
              setStatistic: (STATISTIC newStatistic) {
                BlocProvider.of<StatePageBloc>(context)
                    .add(StatisticChanged(statistic: newStatistic));
              },
            )
          ],
        );
      },
    );
  }
}

class MyMapExplorer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatePageBloc, StatePageState>(
      condition: (previous, current) =>
          previous.statistic != current.statistic ||
          previous.region.stateCode != current.region.stateCode ||
          previous.regionHighlighted != current.regionHighlighted,
      builder: (context, state) {
        return MapExplorerWidget(
          statistic: state.statistic,
          stateCode: state.region.stateCode,
          setStatistic: (STATISTIC newStatistic) {
            BlocProvider.of<StatePageBloc>(context)
                .add(StatisticChanged(statistic: newStatistic));
          },
          regionHighlighted: state.regionHighlighted,
          setRegionHighlighted: (Region newRegionHighlighted) {
            BlocProvider.of<StatePageBloc>(context).add(
                RegionHighlightedChanged(
                    regionHighlighted: newRegionHighlighted));
          },
        );
      },
    );
  }
}

class MyStateMeta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatePageBloc, StatePageState>(
      condition: (previous, current) =>
          previous.region.stateCode != current.region.stateCode,
      builder: (context, state) {
        return StateMetaWidget(
          stateCode: state.region.stateCode,
        );
      },
    );
  }
}

class MyDistrictTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatePageBloc, StatePageState>(
      condition: (previous, current) =>
          previous.region.stateCode != current.region.stateCode ||
          previous.statistic != current.statistic,
      builder: (context, state) {
        return DistrictTopWidget(
          stateCode: state.region.stateCode,
          statistic: state.statistic,
        );
      },
    );
  }
}

class MyDeltaBarGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatePageBloc, StatePageState>(
      condition: (previous, current) =>
          previous.region.stateCode != current.region.stateCode ||
          previous.statistic != current.statistic,
      builder: (context, state) {
        return DeltaBarGraphWidget(
          stateCode: state.region.stateCode,
          statistic: state.statistic,
        );
      },
    );
  }
}

class MyTimeSeriesExplorer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatePageBloc, StatePageState>(
      condition: (previous, current) =>
          previous.region.stateCode != current.region.stateCode ||
          previous.regionHighlighted != current.regionHighlighted ||
          previous.date != current.date,
      builder: (context, state) {
        return TimeSeriesExplorerWidget(
          stateCode: state.region.stateCode,
          timelineDate: state.date,
          regionHighlighted: state.regionHighlighted,
          setRegionHighlighted: (Region newRegionHighlighted) {
            BlocProvider.of<StatePageBloc>(context).add(
                RegionHighlightedChanged(
                    regionHighlighted: newRegionHighlighted));
          },
        );
      },
    );
  }
}
