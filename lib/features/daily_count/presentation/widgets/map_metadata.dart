import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/util/formatter.dart';
import 'package:flutter/material.dart';

class MapMetadata extends StatelessWidget {
  final MapView mapView;
  final String stateCode;
  final String districtName;
  final String statistics;
  final String lastUpdated;
  final Null Function() onBackPress;

  MapMetadata(
      {this.mapView,
      this.stateCode = 'TT',
      this.districtName,
      this.statistics,
      this.lastUpdated,
      this.onBackPress});

  @override
  Widget build(BuildContext context) {
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Constants.STATS_COLOR[statistics])),
              ),
            ),
            mapView == MapView.STATES
                ? Column(
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
                : ButtonTheme(
                    minWidth: 35,
                    height: 30,
                    child: RaisedButton(
                      color: Constants.STATS_COLOR[statistics].withAlpha(80),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      onPressed: () => onBackPress(),
                      child: Text('Back',
                          style: TextStyle(
                              fontSize: 14,
                              color: Constants.STATS_COLOR[statistics])),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
