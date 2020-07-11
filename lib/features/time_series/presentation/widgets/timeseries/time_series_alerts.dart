import 'package:covid19india/core/common/widgets/alert_box.dart';
import 'package:flutter/material.dart';

class TimeSeriesAlerts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox.shrink(),
          ),
          SizedBox(
            width: 128,
            child: AlertBox(
                icon: Icon(
                  Icons.info,
                  size: 14,
                ),
                text: "Tested chart is independent of uniform scaling"),
          ),
        ],
      ),
    );
  }
}
