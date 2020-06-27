import 'dart:math';

import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapVisualizer extends StatefulWidget {
  final List<StateWiseDailyCount> dailyCounts;
  final String statistics;
  final String region;
  final Null Function(String region) onRegionSelected;

  MapVisualizer(
      {this.dailyCounts, this.statistics, this.region, this.onRegionSelected});

  @override
  _MapVisualizerState createState() => _MapVisualizerState();
}

class _MapVisualizerState extends State<MapVisualizer> {
  int maxCases;
  Map<String, StateWiseDailyCount> stateMap;

  @override
  void initState() {
    super.initState();

    maxCases = _getMaxCases();
    stateMap = _getDailyCountMap();
  }

  @override
  void didUpdateWidget(MapVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);

    maxCases = _getMaxCases();
    stateMap = _getDailyCountMap();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            child: _buildMap(widget.region)));
  }

  Widget _buildMap(String region) {
    if (region == 'TT') {
      return Stack(
        children: [
          ...Constants.STATE_CODES.map((e) => _buildRegion(e)).toList(),
          _buildBorder(region)
        ],
      );
    }

    return Stack(
      children: [_buildDistrict(region), _buildBorder(region)],
    );
  }

  Widget _buildRegion(String region) {
    return GestureDetector(
        onTap: () => widget.onRegionSelected(region),
        child: SvgPicture.asset(
          Constants.REGION_ASSET[region],
          color: _getGradient(region),
          semanticsLabel: Constants.STATE_CODE_MAP[region],
        ));
  }

  Widget _buildDistrict(String region) {
    return GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: () => widget.onRegionSelected(region),
        child: SvgPicture.asset(
          Constants.DISTRICT_ASSET[region],
          color: _getGradient(region),
          semanticsLabel: Constants.STATE_CODE_MAP[region],
        ));
  }

  Widget _buildBorder(String region) {
    return SvgPicture.asset(
      Constants.BORDER_ASSET[region],
      color: Constants.STATS_COLOR[widget.statistics],
      semanticsLabel: 'India',
    );
  }

  _getGradient(String region) {
    int regionCases = _getStatistics(stateMap[region].total, widget.statistics);

    return Color.lerp(
        Constants.STATS_GRADIENT_COLOR[widget.statistics][0],
        Constants.STATS_GRADIENT_COLOR[widget.statistics][1],
        (regionCases / maxCases));
  }

  Map<String, StateWiseDailyCount> _getDailyCountMap() {
    return Map.fromIterable(widget.dailyCounts,
        key: (e) => e.name, value: (e) => e);
  }

  int _getMaxCases() {
    int maxCases = 1;
    widget.dailyCounts
        .where((stateData) => stateData.name != 'TT')
        .forEach((stateData) {
      maxCases =
          max(maxCases, _getStatistics(stateData.total, widget.statistics));
    });
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

class CustomStack extends Stack {
  CustomStack({children}) : super(children: children);

  @override
  CustomRenderStack createRenderObject(BuildContext context) {
    return CustomRenderStack(
      alignment: alignment,
      textDirection: textDirection ?? Directionality.of(context),
      fit: fit,
      overflow: overflow,
    );
  }
}

class CustomRenderStack extends RenderStack {
  CustomRenderStack({alignment, textDirection, fit, overflow})
      : super(alignment: alignment, textDirection: textDirection, fit: fit);

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    var stackHit = false;

    final children = getChildrenAsList();

    for (var child in children) {
      final StackParentData childParentData = child.parentData;

      final childHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );

      if (childHit) stackHit = true;
    }

    return stackHit;
  }
}
