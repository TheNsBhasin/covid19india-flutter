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
  String selectedStatistics;
  String selectedRegion;

  @override
  void initState() {
    super.initState();

    selectedRegion = 'TT';
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
                  .where((stateData) => stateData.name == selectedRegion)
                  .toList()
                  .first,
              onSelectStats: (String selected) {
                setState(() {
                  selectedStatistics = selected;
                });
              }),
          SizedBox(height: 32),
          MapMetadata(
            region: selectedRegion,
            statistics: selectedStatistics,
            lastUpdated: widget.dailyCounts
                .where((stateData) => stateData.name == selectedRegion)
                .toList()
                .first
                .metadata
                .lastUpdated,
            onBackPress: () {
              setState(() {
                selectedRegion = 'TT';
              });
            }
          ),
          SizedBox(height: 32),
          MapVisualizer(
              dailyCounts: widget.dailyCounts,
              region: selectedRegion,
              statistics: selectedStatistics,
              onRegionSelected: (String region) {
                print(region);
                setState(() {
                  selectedRegion = region;
                });
              })
        ],
      ),
    );
  }
}
