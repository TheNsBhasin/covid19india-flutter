import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map_metadata.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map_stats.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map_visualizer.dart';
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
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'India Map',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Tap over a state/UT for more details',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
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
          SizedBox(height: 32),
          MapMetadata(
              mapView: mapView,
              stateCode: selectedState,
              districtName: selectedDistrict,
              statistics: selectedStatistics,
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
          SizedBox(height: 32),
          MapVisualizer(
              mapView: mapView,
              dailyCounts: widget.dailyCounts,
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
}
