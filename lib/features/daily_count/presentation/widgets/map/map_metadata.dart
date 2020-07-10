import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/util/formatter.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/stats.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MapMetadata extends StatelessWidget {
  final MapView mapView;
  final String stateCode;
  final String districtName;
  final String statistics;
  final Map<String, StateWiseDailyCount> stateMap;
  final String lastUpdated;
  final Null Function() onBackPress;

  MapMetadata(
      {this.mapView,
      this.stateCode = 'TT',
      this.districtName,
      this.statistics,
      this.stateMap,
      this.lastUpdated,
      this.onBackPress});

  @override
  Widget build(BuildContext context) {
    if (mapView == MapView.STATES) {
      return _buildStatesMapMetadata(context);
    }
    return _buildDistrictsMapMetadata(context);
  }

  Widget _buildStatesMapMetadata(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(Constants.STATE_CODE_MAP[stateCode],
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Constants.STATS_COLOR[statistics])),
              ),
            ),
            if (lastUpdated != null && lastUpdated != '')
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('Last updated',
                      style: TextStyle(
                          fontSize: 12,
                          color: Constants.STATS_COLOR[statistics])),
                  Text(
                      Formatter.formatDuration(new DateTime.now()
                              .difference(DateTime.parse(lastUpdated))) +
                          " ago",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Constants.STATS_COLOR[statistics])),
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _buildDistrictsMapMetadata(context) {
    DistrictWiseDailyCount selectedDistrict = districtName != null
        ? _getDistrictByName(districtName)
        : _getMaxCaseDistrict(stateCode);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(selectedDistrict.name,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Constants.STATS_COLOR[statistics])),
                ),
                SizedBox(height: 8),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                      NumberFormat.decimalPattern('en_IN').format(
                          _getStatistics(selectedDistrict.total, statistics)),
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Constants.STATS_COLOR[statistics])),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(statistics,
                      style: TextStyle(
                          fontSize: 14,
                          color: Constants.STATS_COLOR[statistics])),
                ),
                SizedBox(height: 4),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(height: 4),
                ButtonTheme(
                  minWidth: 35,
                  height: 30,
                  child: FlatButton(
                    color: Colors.orange.withAlpha(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    onPressed: () {},
                    child: Text('Visit state page',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange)),
                  ),
                ),
                ButtonTheme(
                  minWidth: 35,
                  height: 30,
                  child: FlatButton(
                    color: Colors.orange.withAlpha(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    onPressed: () => onBackPress(),
                    child: Text('Back',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange)),
                  ),
                ),
                SizedBox(height: 4),
              ],
            )
          ],
        ),
      ),
    );
  }

  DistrictWiseDailyCount _getMaxCaseDistrict(String stateCode) {
    DistrictWiseDailyCount maxCaseDistrict;
    stateMap[stateCode].districts.forEach((district) {
      if (maxCaseDistrict == null ||
          _getStatistics(district.total, statistics) >
              _getStatistics(maxCaseDistrict.total, statistics)) {
        maxCaseDistrict = district;
      }
    });

    return maxCaseDistrict;
  }

  DistrictWiseDailyCount _getDistrictByName(String districtName) {
    return stateMap[stateCode]
        .districts
        .where((district) => district.name == districtName)
        ?.first;
  }

  int _getStatistics(Stats data, statistics) {
    if (statistics == 'confirmed') {
      return data.confirmed;
    } else if (statistics == 'active') {
      return data.active;
    } else if (statistics == 'recovered') {
      return data.recovered;
    } else if (statistics == 'deceased') {
      return data.deceased;
    } else if (statistics == 'tested') {
      return data.tested;
    }

    return data.confirmed;
  }
}
