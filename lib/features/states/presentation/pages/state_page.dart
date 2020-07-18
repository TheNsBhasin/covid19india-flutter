import 'package:covid19india/core/bloc/bloc.dart';
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
import 'package:covid19india/features/time_series/presentation/bloc/bloc.dart';
import 'package:covid19india/features/time_series/presentation/widgets/bargraph/delta_bar_graph_widget.dart';
import 'package:covid19india/features/time_series/presentation/widgets/minigraph/time_series_minigraph_widget.dart';
import 'package:covid19india/features/time_series/presentation/widgets/timeseries/time_series_explorer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatePageArguments {
  final Region region;

  StatePageArguments({this.region});
}

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
        .bloc<RegionHighlightedBloc>()
        .add(RegionHighlightedChanged(regionHighlighted: widget.region));

    context
        .bloc<TimeSeriesBloc>()
        .add(UpdateTimeSeries(mapCode: widget.region.stateCode));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final Region regionHighlighted =
            context.bloc<RegionHighlightedBloc>().state;

        context.bloc<RegionHighlightedBloc>().add(RegionHighlightedChanged(
            regionHighlighted: Region(
                stateCode: regionHighlighted.stateCode, districtName: null)));

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: MyAppBarTitle(),
        ),
        body: StatePageBody(
          region: widget.region,
        ),
      ),
    );
  }
}

class StatePageBody extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  final Region region;
  final Size mapSwitcherSize = Size(0, 0);

  StatePageBody({this.region});

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
                    StateMetaWidget(
                      stateCode: region.stateCode,
                    ),
                    DistrictTopWidget(
                      stateCode: region.stateCode,
                    ),
                    DeltaBarGraphWidget(
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
