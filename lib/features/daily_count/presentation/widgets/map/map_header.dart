import 'package:covid19india/core/bloc/bloc.dart';
import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/core/entity/map_type.dart';
import 'package:covid19india/core/entity/map_view.dart';
import 'package:covid19india/core/entity/map_viz.dart';
import 'package:covid19india/core/entity/region.dart';
import 'package:covid19india/core/entity/statistic.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/core/util/util.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_daily_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class MapHeader extends StatelessWidget {
  final Map<MapCodes, StateDailyCount> dailyCounts;

  final MapCodes mapCode;

  MapHeader({
    this.dailyCounts,
    this.mapCode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: BlocBuilder<StatisticBloc, Statistic>(
        builder: (context, statistic) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BlocBuilder<RegionHighlightedBloc, Region>(
                  builder: (context, regionHighlighted) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            _getRegionName(regionHighlighted),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: STATS_COLOR[statistic]),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                                text: NumberFormat.decimalPattern('en_IN')
                                    .format(_getRegionStats(
                                        regionHighlighted, statistic)),
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: STATS_COLOR[statistic]),
                                children: [
                                  TextSpan(
                                      text: "\n${statistic.name.capitalize()}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: STATS_COLOR[statistic])),
                                ]),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<MapViewBloc, MapView>(
                  builder: (context, mapView) {
                    return BlocBuilder<MapVizBloc, MapViz>(
                      builder: (context, mapViz) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 4.0),
                                Expanded(
                                  child: ButtonTheme(
                                    minWidth: 48,
                                    height: 48,
                                    child: FlatButton(
                                      color: (mapViz == MapViz.choropleth
                                          ? STATS_COLOR[statistic]
                                              .withOpacity(0.25)
                                          : Colors.grey.withOpacity(0.125)),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      onPressed: () => {
                                        if (mapViz != MapViz.choropleth)
                                          context.bloc<MapVizBloc>().add(
                                              MapVizChanged(
                                                  mapViz: MapViz.choropleth))
                                      },
                                      child: FaIcon(
                                        FontAwesomeIcons.map,
                                        color: (mapViz == MapViz.choropleth
                                            ? STATS_COLOR[statistic]
                                            : Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.0),
                                Expanded(
                                  child: ButtonTheme(
                                    minWidth: 48,
                                    height: 48,
                                    child: FlatButton(
                                      color: (mapViz == MapViz.bubbles
                                          ? STATS_COLOR[statistic]
                                              .withOpacity(0.25)
                                          : Colors.grey.withOpacity(0.125)),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      onPressed: () => {
                                        if (mapViz != MapViz.bubbles)
                                          context.bloc<MapVizBloc>().add(
                                              MapVizChanged(
                                                  mapViz: MapViz.bubbles))
                                      },
                                      child: FaIcon(
                                        FontAwesomeIcons.circle,
                                        color: (mapViz == MapViz.bubbles
                                            ? STATS_COLOR[statistic]
                                            : Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.0),
                                if (mapCode.mapType == MapType.country)
                                  Expanded(
                                    child: ButtonTheme(
                                      minWidth: 48,
                                      height: 48,
                                      child: FlatButton(
                                        color: (mapView == MapView.districts
                                            ? STATS_COLOR[statistic]
                                                .withOpacity(0.25)
                                            : Colors.grey.withOpacity(0.125)),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        onPressed: () => context
                                            .bloc<MapViewBloc>()
                                            .add(MapViewChanged(
                                                mapView:
                                                    mapView == MapView.districts
                                                        ? MapView.states
                                                        : MapView.districts)),
                                        child: FaIcon(
                                          FontAwesomeIcons.building,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (mapCode.mapType == MapType.state)
                                  Expanded(
                                    child: ButtonTheme(
                                      minWidth: 48,
                                      height: 48,
                                      child: FlatButton(
                                        color: Colors.grey.withOpacity(0.125),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: FaIcon(
                                          FontAwesomeIcons.arrowLeft,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                SizedBox(width: 4.0),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ...PRIMARY_STATISTICS.map((stats) => Expanded(
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                        onTap: () {
                                          context.bloc<StatisticBloc>().add(
                                              StatisticChanged(
                                                  statistic: stats));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 16.0),
                                          child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: new BoxDecoration(
                                              color: (statistic == stats)
                                                  ? STATS_COLOR[stats]
                                                  : STATS_COLOR[stats]
                                                      .withOpacity(0.25),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                              ],
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

  String _getRegionName(Region region) {
    if (region.districtName != null) {
      return region.districtName;
    }

    return region.stateCode.name;
  }

  int _getRegionStats(Region region, Statistic statistic) {
    MapCodes stateCode = region.stateCode;

    StateDailyCount stateDailyCount = dailyCounts[stateCode];

    if (region.districtName != null) {
      var items = stateDailyCount.districts
          .where((district) => district.name == region.districtName);
      if (items.length > 0) {
        DistrictDailyCount districtDailyCount = items.first;
        return getStatisticValue(districtDailyCount.total, statistic);
      } else {
        return 0;
      }
    }

    return getStatisticValue(stateDailyCount.total, statistic);
  }
}
