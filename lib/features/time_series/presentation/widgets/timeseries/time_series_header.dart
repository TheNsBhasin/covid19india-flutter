import 'package:covid19india/core/constants/constants.dart';
import 'package:flutter/material.dart';

class TimeSeriesHeader extends StatelessWidget {
  final String statisticsType;
  final String stateCode;
  final bool isUniform;
  final bool isLogarithmic;
  final Null Function(String statisticsType) setStatisticsType;
  final Null Function(String statisticsType) setStateCode;
  final Null Function(bool isUniform) setUniform;
  final Null Function(bool isLogarithmic) setLogarithmic;

  TimeSeriesHeader({
    this.statisticsType,
    this.stateCode,
    this.isUniform,
    this.isLogarithmic,
    this.setStatisticsType,
    this.setStateCode,
    this.setUniform,
    this.setLogarithmic,
  });

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
      child: Text(
        'Spread Trends',
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _buildStatisticsTypeSelector() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: TIME_SERIES_CHART_TYPES.entries
            .map((e) => FlatButton(
                  color: (e.key == statisticsType)
                      ? Colors.orange.withAlpha(100)
                      : Colors.orange.withAlpha(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  onPressed: () {
                    this.setStatisticsType(e.key);
                  },
                  child: Text(e.value,
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
            if (statisticsType == 'total')
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
                    value: isLogarithmic,
                    activeColor: Colors.grey,
                    onChanged: (bool value) {
                      setLogarithmic(value);
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
              value: stateCode,
              onChanged: (stateCode) {
                setStateCode(stateCode);
              },
              isExpanded: true,
              items: STATE_CODE_MAP.entries
                  .map((e) => new DropdownMenuItem<String>(
                        value: e.key,
                        child: Text(e.value,
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
