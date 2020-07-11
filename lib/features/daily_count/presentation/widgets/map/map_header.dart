import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/core/util/util.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class MapHeader extends StatelessWidget {
  final Map<String, StateWiseDailyCount> dailyCounts;

  final String mapCode;
  final String statistic;
  final Map<String, String> regionHighlighted;

  final MAP_VIEWS mapView;
  final MAP_VIZS mapViz;

  final Function(String statistic) setStatistic;
  final Function(MAP_VIEWS mapView) setMapView;
  final Function(MAP_VIZS mapViz) setMapViz;

  MapHeader(
      {this.dailyCounts,
      this.mapCode,
      this.statistic,
      this.regionHighlighted,
      this.mapView,
      this.mapViz,
      this.setStatistic,
      this.setMapView,
      this.setMapViz});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    _getHighlightedRegionName(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: STATS_COLOR[statistic]),
                  ),
                ),
                if (regionHighlighted['stateCode'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                          text: NumberFormat.decimalPattern('en_IN')
                              .format(_getHighlightedRegionStats()),
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: STATS_COLOR[statistic]),
                          children: [
                            TextSpan(
                                text: "\n${statistic.capitalize()}",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: STATS_COLOR[statistic])),
                          ]),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Column(
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
                          color: (mapViz == MAP_VIZS.CHOROPLETH
                              ? STATS_COLOR[statistic].withOpacity(0.25)
                              : Colors.grey.withOpacity(0.125)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          onPressed: () => {
                            if (mapViz != MAP_VIZS.CHOROPLETH)
                              setMapViz(MAP_VIZS.CHOROPLETH)
                          },
                          child: FaIcon(
                            FontAwesomeIcons.map,
                            color: (mapViz == MAP_VIZS.CHOROPLETH
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
                          color: (mapViz == MAP_VIZS.BUBBLES
                              ? STATS_COLOR[statistic].withOpacity(0.25)
                              : Colors.grey.withOpacity(0.125)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          onPressed: () => {
                            if (mapViz != MAP_VIZS.BUBBLES)
                              setMapViz(MAP_VIZS.BUBBLES)
                          },
                          child: FaIcon(
                            FontAwesomeIcons.circle,
                            color: (mapViz == MAP_VIZS.BUBBLES
                                ? STATS_COLOR[statistic]
                                : Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 4.0),
                    if (MAP_META[mapCode]['map_type'] == MAP_TYPES.COUNTRY)
                      Expanded(
                        child: ButtonTheme(
                          minWidth: 48,
                          height: 48,
                          child: FlatButton(
                            color: (mapView == MAP_VIEWS.DISTRICTS
                                ? STATS_COLOR[statistic].withOpacity(0.25)
                                : Colors.grey.withOpacity(0.125)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            onPressed: () => setMapView(
                                mapView == MAP_VIEWS.DISTRICTS
                                    ? MAP_VIEWS.STATES
                                    : MAP_VIEWS.DISTRICTS),
                            child: FaIcon(
                              FontAwesomeIcons.building,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    if (MAP_META[mapCode]['map_type'] == MAP_TYPES.STATE)
                      Expanded(
                        child: ButtonTheme(
                          minWidth: 48,
                          height: 48,
                          child: FlatButton(
                            color: Colors.grey.withOpacity(0.125),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            onPressed: () => Navigator.of(context).pop(),
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
                            borderRadius: BorderRadius.circular(32.0),
                            onTap: () {
                              setStatistic(stats);
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
                                      : STATS_COLOR[stats].withOpacity(0.25),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String _getHighlightedRegionName() {
    if (regionHighlighted['districtName'] != null) {
      return regionHighlighted['districtName'];
    }

    return STATE_CODE_MAP[regionHighlighted['stateCode']];
  }

  int _getHighlightedRegionStats() {
    String stateCode = regionHighlighted['stateCode'];

    StateWiseDailyCount stateDailyCount = dailyCounts[stateCode];

    if (regionHighlighted['districtName'] != null) {
      var items = stateDailyCount.districts.where(
          (district) => district.name == regionHighlighted['districtName']);
      if (items.length > 0) {
        DistrictWiseDailyCount districtDailyCount = items.first;
        return getStatisticValue(districtDailyCount.total, statistic);
      } else {
        return 0;
      }
    }

    return getStatisticValue(stateDailyCount.total, statistic);
  }
}
