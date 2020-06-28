import 'package:covid19india/core/constants/constants.dart';
import 'package:flutter/material.dart';

class MapHeader extends StatelessWidget {
  final MapView mapView;
  final String stateCode;

  MapHeader({this.mapView, this.stateCode});

  @override
  Widget build(BuildContext context) {
    if (mapView == MapView.STATES) {
      return _buildStatesMapHeader();
    }

    return _buildDistrictsMapHeader();
  }

  Widget _buildStatesMapHeader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
          )
        ],
      ),
    );
  }

  Widget _buildDistrictsMapHeader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              Constants.STATE_CODE_MAP[stateCode] + ' Map',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Tap over a District for more details',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
