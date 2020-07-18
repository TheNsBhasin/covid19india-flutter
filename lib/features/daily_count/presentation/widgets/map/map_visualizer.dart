import 'dart:math';

import 'package:covid19india/core/bloc/bloc.dart';
import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/constants/maps.dart';
import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/core/entity/map_type.dart';
import 'package:covid19india/core/entity/map_view.dart';
import 'package:covid19india/core/entity/map_viz.dart';
import 'package:covid19india/core/entity/region.dart';
import 'package:covid19india/core/entity/statistic.dart';
import 'package:covid19india/core/scale/pow.dart';
import 'package:covid19india/core/util/util.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_daily_count.dart';
import 'package:covid19india/features/states/presentation/pages/state_page.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grizzly_scales/grizzly_scales.dart';
import 'package:path_drawing/path_drawing.dart';

class MapVisualizer extends StatelessWidget {
  final Map<MapCodes, StateDailyCount> dailyCounts;

  final MapCodes mapCode;

  MapVisualizer({
    this.dailyCounts,
    this.mapCode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapViewBloc, MapView>(builder: (context, mapView) {
      return BlocBuilder<MapVizBloc, MapViz>(builder: (context, mapViz) {
        return BlocBuilder<StatisticBloc, Statistic>(
            builder: (context, statistic) {
          final Size mapSize = _getMapSize(mapCode);

          final List<Shape> mapShape =
              _getShape(dailyCounts, mapView, mapViz, mapCode, statistic);

          final double width =
              min(mapSize.width, MediaQuery.of(context).size.width);
          final double height = mapSize.height * (width / mapSize.width);

          return Center(
              child: Container(
            constraints: BoxConstraints(maxWidth: width, maxHeight: height),
            child: MapPlot(
              mapShape: mapShape,
              mapCode: mapCode,
              mapSize: mapSize,
              mapView: mapView,
              statistic: statistic,
            ),
          ));
        });
      });
    });
  }

  Size _getMapSize(MapCodes mapCode) {
    return MAP_SIZE[mapCode.key];
  }

  List<Shape> _getShape(
    Map<MapCodes, StateDailyCount> dailyCounts,
    MapView mapView,
    MapViz mapViz,
    MapCodes mapCode,
    Statistic statistic,
  ) {
    if (mapCode.mapType == MapType.state) {
      return STATE_DATA[mapCode.key]
          .map((districtData) {
            String districtName = districtData['district'];
            String path = districtData['path'];

            final DistrictDailyCount districtDailyCount = dailyCounts[mapCode]
                .districts
                .firstWhere((districtData) => districtData.name == districtName,
                    orElse: () => null);

            return Shape.withPathString(
              path: path,
              region: Region(
                stateCode: mapCode,
                districtName: districtName,
              ),
              value: districtDailyCount != null
                  ? getStatisticValue(districtDailyCount.total, statistic)
                  : 0,
            );
          })
          .toList()
          .cast<Shape>();
    }

    if (mapView == MapView.states) {
      return COUNTRY_DATA.entries
          .map((stateData) {
            MapCodes stateCode = stateData.key.toMapCode();
            String path = stateData.value['path'];

            final StateDailyCount stateDailyCount = dailyCounts[stateCode];

            return Shape.withPathString(
              path: path,
              region: Region(
                districtName: null,
                stateCode: stateCode,
              ),
              value: stateDailyCount != null
                  ? getStatisticValue(stateDailyCount.total, statistic)
                  : 0,
            );
          })
          .toList()
          .cast<Shape>();
    }

    List<Shape> shapes = <Shape>[];

    COUNTRY_DATA.entries.forEach((stateData) {
      MapCodes stateCode = stateData.key.toMapCode();
      stateData.value['districts'].entries.forEach((districtData) {
        String districtName = districtData.value['district'];
        String path = districtData.value['path'];

        final DistrictDailyCount districtDailyCount = dailyCounts[stateCode]
                ?.districts
                ?.firstWhere(
                    (districtData) => districtData.name == districtName,
                    orElse: () => null) ??
            null;

        if (path != null) {
          shapes.add(Shape.withPathString(
            path: path,
            region: Region(
              districtName: districtName,
              stateCode: stateCode,
            ),
            value: districtDailyCount != null
                ? getStatisticValue(districtDailyCount.total, statistic)
                : 0,
          ));
        } else {
//          print(districtName);
        }
      });
    });

    return shapes;
  }
}

class MapPlot extends StatelessWidget {
  final List<Shape> mapShape;
  final MapCodes mapCode;
  final Size mapSize;
  final MapViz mapViz;
  final MapView mapView;
  final Statistic statistic;

  MapPlot({
    this.mapShape,
    this.mapCode,
    this.mapSize,
    this.mapViz,
    this.mapView,
    this.statistic,
  });

  @override
  Widget build(BuildContext context) {
    int maxValue = mapShape.map((e) => e.value).reduce(max);
    Scale mapScale = _getMapScale(mapViz, statistic, maxValue);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size size = Size(constraints.maxWidth, constraints.maxHeight);
        final fs = applyBoxFit(BoxFit.contain, mapSize, size);
        final r = Alignment.center.inscribe(fs.destination, Offset.zero & size);
        final matrix = Matrix4.translationValues(r.left, r.top, 0)
          ..scale(fs.destination.width / fs.source.width);

        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                context
                    .bloc<RegionHighlightedBloc>()
                    .add(RegionHighlightedChanged(
                        regionHighlighted: Region(
                      stateCode: mapCode,
                      districtName: null,
                    )));
              },
              child: Container(
                color: Colors.transparent,
                child: SizedBox.expand(),
              ),
            ),
            ...mapShape.map((shape) => RegionPlot(
                  shape: shape.transform(matrix),
                  statistic: statistic,
                  mapScale: mapScale,
                  mapCode: mapCode,
                )),
          ],
        );
      },
    );
  }

  Scale _getMapScale(MapViz mapViz, Statistic statistic, int maxValue) {
    if (mapViz == MapViz.bubbles) {
      return SqrtScale([0, max(maxValue, 1)], [0, 40]);
    } else {
      return LinearScale([0, max(1, maxValue)], [0.0, 1.0]);
    }
  }
}

class RegionPlot extends StatelessWidget {
  final Shape shape;
  final MapCodes mapCode;
  final Scale mapScale;
  final Statistic statistic;

  RegionPlot({this.shape, this.mapCode, this.mapScale, this.statistic});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return BlocBuilder<RegionHighlightedBloc, Region>(
      buildWhen: (previous, current) =>
          previous == shape.region || current == shape.region,
      builder: (context, regionHighlighted) {
        return ClipPath(
          clipBehavior: Clip.antiAlias,
          child: GestureDetector(
            onTap: () {
              context.bloc<RegionHighlightedBloc>().add(
                  RegionHighlightedChanged(regionHighlighted: shape.region));
            },
            onDoubleTap: () {
              if (mapCode != MapCodes.TT) {
                return;
              }

              Navigator.pushNamed(
                context,
                StatePage.routeName,
                arguments: StatePageArguments(region: shape.region),
              );
            },
            child: CustomPaint(
              child: SizedBox.expand(),
              painter: RegionPainter(
                shape: shape,
                strokeColor: STATS_COLOR[statistic],
                fillColor: _getGradient(shape, mapScale, statistic,
                    inverted: isDarkMode),
                highlightColor: STATS_HIGHLIGHT_COLOR[statistic],
                highlighted: regionHighlighted == shape.region,
              ),
            ),
          ),
          clipper: RegionClipper(shape),
        );
      },
    );
  }

  Color _getGradient(Shape shape, Scale mapScale, Statistic statistic,
      {inverted: false}) {
    int _startIndex = 0;
    int _endIndex = 1;

    if (inverted) {
      _startIndex = 1;
      _endIndex = 0;
    }

    return Color.lerp(
            STATS_GRADIENT_COLOR[statistic][_startIndex],
            STATS_GRADIENT_COLOR[statistic][_endIndex],
            mapScale.scale(shape.value))
        .withAlpha(50);
  }
}

class Shape extends Equatable {
  final Path path;
  final Region region;
  final int value;

  Shape({
    this.path,
    this.region,
    this.value,
  });

  factory Shape.withPathString({
    String path,
    Region region,
    int value,
  }) {
    return Shape(
      path: parseSvgPathData(path),
      region: region,
      value: value,
    );
  }

  Shape transform(Matrix4 matrix) => Shape(
        path: path.transform(matrix.storage),
        region: this.region,
        value: this.value,
      );

  @override
  List<Object> get props => [path, region, value];
}

class RegionPainter extends CustomPainter {
  final Shape shape;
  final Color fillColor;
  final Color strokeColor;
  final Color highlightColor;
  final bool highlighted;
  final Matrix4 matrix;
  final Paint _paint = Paint();

  RegionPainter(
      {this.shape,
      this.fillColor,
      this.strokeColor,
      this.highlightColor,
      this.highlighted,
      this.matrix});

  @override
  void paint(Canvas canvas, Size size) {
    _paint
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(shape.path, _paint);

    _paint
      ..color = highlighted
          ? highlightColor ?? strokeColor
          : strokeColor.withAlpha(50)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawPath(shape.path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class RegionClipper extends CustomClipper<Path> {
  final Shape shape;

  RegionClipper(this.shape);

  @override
  Path getClip(Size size) => shape.path;

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
