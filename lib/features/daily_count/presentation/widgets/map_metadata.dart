import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/core/util/formatter.dart';
import 'package:flutter/material.dart';

class MapMetadata extends StatelessWidget {
  final String region;
  final String statistics;
  final String lastUpdated;
  final Null Function() onBackPress;

  MapMetadata(
      {this.region = 'TT',
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
            Text(Constants.STATE_CODE_MAP[region],
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Constants.STATS_COLOR[statistics])),
            region == 'TT'
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
                      color: Constants.STATS_GRADIENT_COLOR[statistics][0],
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
