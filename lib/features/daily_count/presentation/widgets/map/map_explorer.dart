import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/entity/region.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_header.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_visualizer.dart';
import 'package:flutter/material.dart';

class MapExplorer extends StatefulWidget {
  final Map<String, StateWiseDailyCount> dailyCounts;

  final String mapCode;
  final String statistic;
  final Region regionHighlighted;

  final Function(String statistic) setStatistic;
  final Function(Region regionHighlighted) setRegionHighlighted;

  MapExplorer(
      {this.dailyCounts,
      this.mapCode,
      this.statistic,
      this.setStatistic,
      this.regionHighlighted,
      this.setRegionHighlighted});

  @override
  _MapExplorerState createState() => _MapExplorerState();
}

class _MapExplorerState extends State<MapExplorer> {
  MAP_VIEWS mapView;
  MAP_VIZS mapViz;

  @override
  void initState() {
    super.initState();

    mapView = (MAP_META[widget.mapCode]['map_type'] == MAP_TYPES.COUNTRY)
        ? MAP_VIEWS.STATES
        : MAP_VIEWS.DISTRICTS;
    mapViz = MAP_VIZS.CHOROPLETH;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MapHeader(
            dailyCounts: widget.dailyCounts,
            mapCode: widget.mapCode,
            statistic: widget.statistic,
            regionHighlighted: widget.regionHighlighted,
            mapView: mapView,
            mapViz: mapViz,
            setMapView: (MAP_VIEWS newMapView) {
              setState(() {
                mapView = newMapView;
              });
            },
            setMapViz: (MAP_VIZS newMapViz) {
              setState(() {
                mapViz = newMapViz;
              });
            },
            setStatistic: widget.setStatistic,
          ),
          MapVisualizer(
            dailyCounts: widget.dailyCounts,
            mapCode: widget.mapCode,
            statistic: widget.statistic,
            regionHighlighted: widget.regionHighlighted,
            setRegionHighlighted: widget.setRegionHighlighted,
            mapView: mapView,
            mapViz: mapViz,
          )
        ],
      ),
    );
  }
}
