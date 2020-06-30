import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_header.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_metadata.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_stats.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_visualizer.dart';
import 'package:flutter/material.dart';

class MapExplorer extends StatefulWidget {
  final List<StateWiseDailyCount> dailyCounts;

  MapExplorer({this.dailyCounts});

  @override
  _MapExplorerState createState() => _MapExplorerState();
}

class _MapExplorerState extends State<MapExplorer> {
  MapView mapView;
  String selectedStatistics;
  String selectedState;
  String selectedDistrict;

  @override
  void initState() {
    super.initState();

    mapView = MapView.STATES;
    selectedState = 'TT';
    selectedDistrict = null;
    selectedStatistics = 'active';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          MapHeader(mapView: mapView, stateCode: selectedState),
          MapStats(
              dailyCount: widget.dailyCounts
                  .where((stateData) => stateData.name == selectedState)
                  .toList()
                  .first,
              onSelectStats: (String selected) {
                setState(() {
                  selectedStatistics = selected;
                });
              }),
          mapView == MapView.STATES
              ? SizedBox(height: 32)
              : SizedBox(height: 0),
          MapMetadata(
              mapView: mapView,
              stateCode: selectedState,
              districtName: selectedDistrict,
              statistics: selectedStatistics,
              stateMap: _getDailyCountMap(widget.dailyCounts),
              lastUpdated: widget.dailyCounts
                  .where((stateData) => stateData.name == selectedState)
                  .toList()
                  .first
                  .metadata
                  .lastUpdated,
              onBackPress: () {
                setState(() {
                  if (mapView == MapView.DISTRICTS) {
                    mapView = MapView.STATES;
                    selectedState = 'TT';
                    selectedDistrict = null;
                  }
                });
              }),
          mapView == MapView.STATES
              ? SizedBox(height: 32)
              : SizedBox(height: 0),
          MapVisualizer(
              mapView: mapView,
              stateMap: _getDailyCountMap(widget.dailyCounts),
              stateCode: selectedState,
              districtName: selectedDistrict,
              statistics: selectedStatistics,
              onRegionSelected: (String stateCode, String districtName) {
                setState(() {
                  if (mapView == MapView.STATES) {
                    mapView = MapView.DISTRICTS;
                  }
                  selectedState = stateCode;
                  selectedDistrict = districtName;
                });
              })
        ],
      ),
    );
  }

  Map<String, StateWiseDailyCount> _getDailyCountMap(
      List<StateWiseDailyCount> dailyCounts) {
    return Map.fromIterable(dailyCounts, key: (e) => e.name, value: (e) => e);
  }
}
