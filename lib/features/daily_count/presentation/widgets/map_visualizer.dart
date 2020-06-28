import 'dart:math';

import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/constants/map_paths.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_drawing/path_drawing.dart';

class MapVisualizer extends StatefulWidget {
  final MapView mapView;
  final List<StateWiseDailyCount> dailyCounts;
  final String statistics;
  final String stateCode;
  final String districtName;
  final Null Function(String stateCode, String districtName) onRegionSelected;

  MapVisualizer(
      {this.mapView,
      this.dailyCounts,
      this.statistics,
      this.stateCode,
      this.districtName,
      this.onRegionSelected});

  @override
  _MapVisualizerState createState() => _MapVisualizerState();
}

class _MapVisualizerState extends State<MapVisualizer> {
  int maxCases;
  Map<String, StateWiseDailyCount> stateMap;

  @override
  void initState() {
    super.initState();

    stateMap = _getDailyCountMap();
    maxCases =
        _getMaxCases(widget.mapView, widget.stateCode, widget.districtName);
  }

  @override
  void didUpdateWidget(MapVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);

    stateMap = _getDailyCountMap();
    maxCases =
        _getMaxCases(widget.mapView, widget.stateCode, widget.districtName);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            child: _buildMap(
                widget.mapView, widget.stateCode, widget.districtName)));
  }

  Widget _buildMap(MapView mapView, String stateCode, String districtName) {
    return CustomPaint(
      painter: MapPainter(
          mapView: mapView,
          mapSize: _getMapSize(stateCode),
          shapes: _getShape(mapView, stateCode, districtName),
          strokeColor: Constants.STATS_COLOR[widget.statistics]),
      child: SizedBox.expand(),
    );
  }

  Size _getMapSize(String stateCode) {
    return MapPaths.MAP_SIZE[stateCode];
  }

  List<Shape> _getShape(
      MapView mapView, String stateCode, String districtName) {
    if (mapView == MapView.STATES) {
      return MapPaths.statePaths.entries
          .map((e) => Shape(
              path: e.value,
              label: e.key,
              color: _getGradient(mapView, e.key, null),
              onTap: () {
                widget.onRegionSelected(e.key, null);
              }))
          .toList();
    }

    return MapPaths.districtPaths[stateCode]
        .asMap()
        .entries
        .map((e) => Shape(
            path: e.value,
            label: MapPaths.DISTRICT_DATA[stateCode][e.key]['district'],
            color: _getGradient(mapView, stateCode,
                MapPaths.DISTRICT_DATA[stateCode][e.key]['district']),
            onTap: () {
              String district =
                  MapPaths.DISTRICT_DATA[stateCode][e.key]['district'];

              widget.onRegionSelected(stateCode, district);
            }))
        .toList();
  }

  _getGradient(MapView mapView, String stateCode, String districtName) {
    int regionCases = 1;
    if (mapView == MapView.STATES) {
      regionCases = max(regionCases,
          _getStatistics(stateMap[stateCode].total, widget.statistics));
    } else {
      List results = stateMap[stateCode]
          .districts
          .where((e) => e.name == districtName)
          .toList();

      if (results.length > 0) {
        regionCases = max(regionCases,
            _getStatistics(results.first.total, widget.statistics));
      }
    }

    return Color.lerp(
        Constants.STATS_GRADIENT_COLOR[widget.statistics][0],
        Constants.STATS_GRADIENT_COLOR[widget.statistics][1],
        (regionCases / maxCases));
  }

  Map<String, StateWiseDailyCount> _getDailyCountMap() {
    return Map.fromIterable(widget.dailyCounts,
        key: (e) => e.name, value: (e) => e);
  }

  int _getMaxCases(MapView mapView, String stateCode, String districtName) {
    int maxCases = 1;

    if (mapView == MapView.STATES) {
      widget.dailyCounts
          .where((stateData) => stateData.name != 'TT')
          .forEach((stateData) {
        maxCases =
            max(maxCases, _getStatistics(stateData.total, widget.statistics));
      });
    } else {
      stateMap[stateCode].districts.forEach((districtData) {
        maxCases = max(
            maxCases, _getStatistics(districtData.total, widget.statistics));
      });
    }

    return maxCases;
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

class Shape {
  Path _transformedPath;

  final Path _path;
  final String label;
  final Color color;
  final Null Function() onTap;

  Shape({String path, this.label, this.color, this.onTap})
      : _path = parseSvgPathData(path);

  void transform(Matrix4 matrix) =>
      _transformedPath = _path.transform(matrix.storage);
}

class MapPainter extends CustomPainter {
  final MapView mapView;
  final List<Shape> shapes;
  final Color strokeColor;
  final Paint _paint = Paint();
  final Size mapSize;
  Size _size = Size.zero;

  MapPainter(
      {this.mapView,
      this.mapSize,
      this.shapes,
      this.strokeColor: Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    if (size != _size) {
      _size = size;
      final fs = applyBoxFit(BoxFit.contain, mapSize, size);
      final r = Alignment.center.inscribe(fs.destination, Offset.zero & size);
      final matrix = Matrix4.translationValues(r.left, r.top, 0)
        ..scale(fs.destination.width / fs.source.width);
      shapes.forEach((shape) {
        shape.transform(matrix);
      });
    }

    canvas..clipRect(Offset.zero & size);

    shapes.forEach((shape) {
      final path = shape._transformedPath;

      _paint
        ..color = shape.color
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, _paint);

      _paint
        ..color = strokeColor
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, _paint);
    });
  }

  @override
  bool hitTest(Offset position) {
    shapes.forEach((shape) {
      if (shape._transformedPath.contains(position)) {
        shape.onTap();
      }
    });
    return false;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}