import 'dart:math';

import 'package:covid19india/core/common/widgets/positioned_tap_detector.dart';
import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/constants/maps.dart';
import 'package:covid19india/core/entity/region.dart';
import 'package:covid19india/core/scale/pow.dart';
import 'package:covid19india/core/util/util.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/states/presentation/pages/state_page.dart';
import 'package:flutter/material.dart';
import 'package:grizzly_scales/grizzly_scales.dart';
import 'package:path_drawing/path_drawing.dart';

class MapVisualizer extends StatelessWidget {
  final Map<String, StateWiseDailyCount> dailyCounts;

  final String mapCode;
  final String statistic;
  final Region regionHighlighted;

  final MAP_VIEWS mapView;
  final MAP_VIZS mapViz;

  final Function(Region regionHighlighted) setRegionHighlighted;

  MapVisualizer(
      {this.dailyCounts,
      this.mapCode,
      this.statistic,
      this.regionHighlighted,
      this.setRegionHighlighted,
      this.mapView,
      this.mapViz});

  @override
  Widget build(BuildContext context) {
    final int statisticMax = _getStatisticMax(dailyCounts, mapView, statistic);

    final Scale mapScale = _getMapScale(mapViz, statistic, statisticMax);

    final Size mapSize = _getMapSize(mapCode);

    final List<Shape> mapShape = _getShape(context, dailyCounts, mapScale,
        mapView, mapCode, statistic, regionHighlighted);

    final double width = min(mapSize.width, MediaQuery.of(context).size.width);
    final double height = mapSize.height * (width / mapSize.width);

    return Center(
        child: Container(
      width: width,
      height: height,
      child: _buildMap(context, mapShape, mapSize, mapView, statistic),
    ));
  }

  Widget _buildMap(BuildContext context, List<Shape> mapShape, Size mapSize,
      MAP_VIEWS mapView, String statistic) {
    return PositionedTapDetector(
      onTap: (TapPosition pos) {
        RenderBox box = context.findRenderObject();
        final offset = box.globalToLocal(pos.global);
        final index = mapShape
            .lastIndexWhere((shape) => shape._transformedPath.contains(offset));
        if (index != -1) {
          mapShape[index].onTap();
          return;
        }

        setRegionHighlighted(new Region(
          stateCode: mapCode,
          districtName: null,
        ));
      },
      onDoubleTap: (TapPosition pos) {
        RenderBox box = context.findRenderObject();
        final offset = box.globalToLocal(pos.global);
        final index = mapShape
            .lastIndexWhere((shape) => shape._transformedPath.contains(offset));
        if (index != -1) {
          Navigator.pushNamed(
            context,
            StatePage.routeName,
            arguments: StatePageArguments(region: mapShape[index].region),
          );
          return;
        }
      },
      child: CustomPaint(
        painter: MapPainter(
          mapView: mapView,
          mapSize: mapSize,
          shapes: mapShape,
          strokeColor: STATS_COLOR[statistic],
        ),
        child: SizedBox.expand(),
      ),
    );
  }

  int _getStatisticMax(Map<String, StateWiseDailyCount> dailyCounts,
      MAP_VIEWS mapView, String statistic) {
    List<String> stateCodes = dailyCounts.keys
        .where((stateCode) =>
            stateCode != 'TT' && MAP_META.keys.contains(stateCode))
        .toList();

    if (mapView == MAP_VIEWS.STATES) {
      int maxStats = 0;
      stateCodes.forEach((stateCode) {
        maxStats = max(maxStats,
            getStatisticValue(dailyCounts[stateCode].total, statistic));
      });

      return maxStats;
    } else if (mapView == MAP_VIEWS.DISTRICTS) {
      int maxStats = 0;
      stateCodes.forEach((stateCode) {
        dailyCounts[stateCode].districts.forEach((districtData) {
          maxStats =
              max(maxStats, getStatisticValue(districtData.total, statistic));
        });
      });

      return maxStats;
    }

    return 0;
  }

  Scale _getMapScale(MAP_VIZS mapViz, String statistic, int statisticMax) {
    if (mapViz == MAP_VIZS.BUBBLES) {
      return SqrtScale([0, max(statisticMax, 1)], [0, 40]);
    } else {
      return LinearScale([0, max(1, statisticMax)], [0.0, 1.0]);
    }
  }

  Size _getMapSize(String mapCode) {
    if (mapView == MAP_VIEWS.STATES) {
      return MAP_SIZE['TT'];
    }

    return MAP_SIZE[mapCode];
  }

  List<Shape> _getShape(
      BuildContext context,
      Map<String, StateWiseDailyCount> dailyCounts,
      Scale mapScale,
      MAP_VIEWS mapView,
      String mapCode,
      String statistic,
      Region regionHighlighted) {
    if (MAP_META[mapCode]['map_type'] == MAP_TYPES.STATE) {
      return STATE_DATA[mapCode]
          .map((districtData) {
            String districtName = districtData['district'];
            String path = districtData['path'];

            return Shape(
                path: path,
                region: new Region(stateCode: mapCode, districtName: null),
                color: _getGradient(context, dailyCounts, mapScale, mapCode,
                    districtName, statistic),
                highlightColor: STATS_HIGHLIGHT_COLOR[statistic],
                highlighted: regionHighlighted.districtName == districtName,
                onTap: () {
                  setRegionHighlighted(new Region(
                      stateCode: mapCode, districtName: districtName));
                });
          })
          .toList()
          .cast<Shape>();
    }

    if (mapView == MAP_VIEWS.STATES) {
      return COUNTRY_DATA.entries
          .map((stateData) {
            String stateCode = stateData.key;
            String path = stateData.value['path'];

            return Shape(
                path: path,
                region: new Region(districtName: null, stateCode: stateCode),
                color: _getGradient(
                    context, dailyCounts, mapScale, stateCode, null, statistic),
                highlightColor: STATS_HIGHLIGHT_COLOR[statistic],
                highlighted: regionHighlighted.stateCode == stateCode,
                onTap: () {
                  setRegionHighlighted(
                      new Region(stateCode: stateCode, districtName: null));
                });
          })
          .toList()
          .cast<Shape>();
    }

    List<Shape> shapes = <Shape>[];

    COUNTRY_DATA.entries.forEach((stateData) {
      String stateCode = stateData.key;

      stateData.value['districts'].entries.forEach((districtData) {
        String districtName = districtData.value['district'];
        String path = districtData.value['path'];

        if (path != null) {
          shapes.add(Shape(
              path: path,
              region:
                  new Region(districtName: districtName, stateCode: stateCode),
              color: _getGradient(context, dailyCounts, mapScale, stateCode,
                  districtName, statistic),
              highlightColor: STATS_HIGHLIGHT_COLOR[statistic],
              highlighted: regionHighlighted.districtName == districtName,
              onTap: () {
                setRegionHighlighted(new Region(
                    stateCode: stateCode, districtName: districtName));
              }));
        } else {
//          print(districtName);
        }
      });
    });

    return shapes;
  }

  Color _getGradient(
      BuildContext context,
      Map<String, StateWiseDailyCount> dailyCounts,
      Scale mapScale,
      String mapCode,
      String districtName,
      String statistic) {
    StateWiseDailyCount stateDailyCount = dailyCounts[mapCode];

    int stats = getStatisticValue(stateDailyCount.total, statistic);

    if (districtName != null) {
      if (stateDailyCount.districts
              .where((district) => district.name == districtName)
              .length >
          0) {
        DistrictWiseDailyCount districtDailyCount = stateDailyCount.districts
            .where((district) => district.name == districtName)
            .first;

        stats = getStatisticValue(districtDailyCount.total, statistic);
      } else {
        stats = 0;
      }
    }

    int _startIndex = 0;
    int _endIndex = 1;

    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
      _startIndex = 1;
      _endIndex = 0;
    }

    try {
      return stats == 0
          ? Colors.transparent
          : Color.lerp(
                  STATS_GRADIENT_COLOR[statistic][_startIndex],
                  STATS_GRADIENT_COLOR[statistic][_endIndex],
                  mapScale.scale(stats))
              .withAlpha(50);
    } catch (e) {
      print('${e.toString()}: $mapCode $districtName');
    }

    return Colors.transparent;
  }
}

class Shape {
  Path _transformedPath;

  final Path _path;
  final Region region;
  final Color color;
  final Color highlightColor;
  final bool highlighted;
  final VoidCallback onTap;

  Shape(
      {String path,
      this.region,
      this.color,
      this.highlightColor,
      this.highlighted,
      this.onTap})
      : _path = parseSvgPathData(path);

  void transform(Matrix4 matrix) =>
      _transformedPath = _path.transform(matrix.storage);
}

class MapPainter extends CustomPainter {
  final MAP_VIEWS mapView;
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
        ..color = shape.highlighted
            ? shape.highlightColor ?? strokeColor
            : strokeColor.withAlpha(50)
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, _paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
