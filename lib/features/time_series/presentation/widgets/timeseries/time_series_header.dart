import 'dart:convert';

import 'package:covid19india/core/entity/map_codes.dart';
import 'package:covid19india/core/entity/region.dart';
import 'package:covid19india/core/entity/time_series_chart_type.dart';
import 'package:covid19india/core/model/region_model.dart';
import 'package:flutter/material.dart';

class TimeSeriesHeader extends StatelessWidget {
  final TimeSeriesChartType chartType;
  final bool isUniform;
  final bool isLog;
  final Region selectedRegion;
  final List<Region> regions;

  final Null Function(TimeSeriesChartType chartType) setChartType;
  final Null Function(bool isUniform) setUniform;
  final Null Function(bool isLogarithmic) setLog;
  final Function(Region regionHighlighted) setRegionHighlighted;

  TimeSeriesHeader(
      {this.chartType,
      this.isUniform,
      this.isLog,
      this.regions,
      this.selectedRegion,
      this.setChartType,
      this.setUniform,
      this.setLog,
      this.setRegionHighlighted});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTitle(),
          SizedBox(
            height: 8.0,
          ),
          _buildStatisticsTypeSelector(),
          SizedBox(
            height: 8.0,
          ),
          _buildScaleModeSelector(),
          SizedBox(height: 8.0),
          _buildStatesDropdown(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Text(
          'Spread Trends',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildStatisticsTypeSelector() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: TimeSeriesChartType.values
            .map((e) => FlatButton(
                  color: (e == chartType)
                      ? Colors.orange.withAlpha(100)
                      : Colors.orange.withAlpha(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  onPressed: () {
                    this.setChartType(e);
                  },
                  child: Text(e.name,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange)),
                ))
            .toList());
  }

  Widget _buildScaleModeSelector() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Scale Modes",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Uniform",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ),
                Switch(
                  value: isUniform,
                  activeColor: Colors.grey,
                  onChanged: (bool value) {
                    setUniform(value);
                  },
                ),
              ],
            ),
            if (chartType == TimeSeriesChartType.total)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Logarithmic",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                  Switch(
                    value: isLog,
                    activeColor: Colors.grey,
                    onChanged: (bool value) {
                      setLog(value);
                    },
                  ),
                ],
              )
          ],
        )
      ],
    );
  }

  Widget _buildStatesDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 1, child: SizedBox.shrink()),
        Expanded(
          flex: 2,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: jsonEncode(RegionModel(
                      stateCode: selectedRegion.stateCode,
                      districtName: selectedRegion.districtName)
                  .toJson()),
              onChanged: (region) {
                setRegionHighlighted(
                    RegionModel.fromJson(jsonDecode(region)).toEntity());
              },
              isExpanded: true,
              items: regions
                  .map((region) => new DropdownMenuItem<String>(
                        value: jsonEncode(RegionModel(
                                stateCode: region.stateCode,
                                districtName: region.districtName)
                            .toJson()),
                        child: Text(
                            region.districtName != null
                                ? region.districtName
                                : region.stateCode.name,
                            softWrap: true,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ))
                  .toList(),
            ),
          ),
        ),
        Expanded(flex: 1, child: SizedBox.shrink()),
      ],
    );
  }
}
