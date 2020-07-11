import 'package:flutter/material.dart';

class StateMetaCard extends StatelessWidget {
  final String title;
  final String statistic;
  final String total;
  final String formula;
  final String description;
  final String date;
  final Color color;

  final GlobalKey _tooltip = new GlobalKey();

  StateMetaCard({
    this.title,
    this.statistic,
    this.total,
    this.formula,
    this.description,
    this.date,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: BoxConstraints(maxWidth: 160, minHeight: 260),
        decoration: BoxDecoration(
            color: color.withOpacity(0.25),
            borderRadius: BorderRadius.all(new Radius.circular(5.0))),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: color.withOpacity(0.9)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      if (_tooltip != null && _tooltip.currentState != null) {
                        final dynamic _tooltipState = _tooltip.currentState;
                        _tooltipState.ensureTooltipVisible();
                      }
                    },
                    child: Tooltip(
                      key: _tooltip,
                      message: formula,
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: Container(
                          child: Icon(
                            Icons.info,
                            size: 24,
                            color: color.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            if (statistic != null)
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  statistic,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 24, color: color),
                ),
              ),
            if (date != null)
              Container(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  date,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: color.withOpacity(0.9)),
                ),
              ),
            if (total != null)
              Container(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "India has $total CPM",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: color.withOpacity(0.9)),
                ),
              ),
            if (description != null)
              Container(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  description,
                  softWrap: true,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: color.withOpacity(0.9)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
