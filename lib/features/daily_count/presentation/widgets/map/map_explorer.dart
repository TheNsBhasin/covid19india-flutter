import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_daily_count.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_header.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/map/map_visualizer.dart';
import 'package:flutter/material.dart';

class MapExplorer extends StatelessWidget {
  final Map<MapCodes, StateDailyCount> dailyCounts;
  final MapCodes mapCode;

  MapExplorer({this.dailyCounts, this.mapCode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MapHeader(
            dailyCounts: dailyCounts,
            mapCode: mapCode,
          ),
          MapVisualizer(
            dailyCounts: dailyCounts,
            mapCode: mapCode,
          )
        ],
      ),
    );
  }
}
