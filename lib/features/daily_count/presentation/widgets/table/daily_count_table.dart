import 'package:covid19india/core/common/widgets/sort_arrow.dart';
import 'package:covid19india/core/common/widgets/sticky_headers_table.dart';
import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/stats.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyCountTable extends StatefulWidget {
  final Map<String, StateWiseDailyCount> stateWiseDailyCount;

  DailyCountTable({this.stateWiseDailyCount});

  @override
  _DailyCountTableState createState() => _DailyCountTableState();
}

class _DailyCountTableState extends State<DailyCountTable> {
  int sortColumnIndex;
  bool isAscending;

  List<String> titleRow;
  List<String> titleColumn;

  _DailyCountTableState()
      : sortColumnIndex = 1,
        isAscending = false,
        titleRow = <String>[],
        titleColumn = <String>[];

  @override
  void initState() {
    super.initState();

    titleRow = _getTitleRow();
    titleColumn = _getTitleColumn();
  }

  @override
  Widget build(BuildContext context) {
    return StickyHeadersTable(
      rowsLength: titleRow.length,
      columnsLength: titleColumn.length,
      legendCell: _buildLegendCell(
          child: _buildHeading(
        label: "State/UT",
        numeric: false,
        onSort: () {
          setState(() {
            if (sortColumnIndex == 0) {
              isAscending = !isAscending;
            }
            sortColumnIndex = 0;
            titleRow = sortColumn(sortColumnIndex, isAscending);
          });
        },
        sorted: sortColumnIndex == 0,
        ascending: isAscending,
      )),
      rowsTitleBuilder: (int rowIndex) {
        return _buildRowTitle(
            child: _buildTitle(
                text: (titleRow[rowIndex] == "TT"
                    ? "Total"
                    : Constants.STATE_CODE_MAP[titleRow[rowIndex]])));
      },
      columnsTitleBuilder: (int columnIndex) {
        return _buildColumnTitle(
            child: _buildHeading(
          label: titleColumn[columnIndex].capitalize(),
          numeric: true,
          onSort: () {
            setState(() {
              if (sortColumnIndex == columnIndex + 1) {
                isAscending = !isAscending;
              }

              sortColumnIndex = columnIndex + 1;
              titleRow = sortColumn(sortColumnIndex, isAscending);
            });
          },
          sorted: sortColumnIndex == columnIndex + 1,
          ascending: isAscending,
        ));
      },
      contentCellBuilder: (int columnIndex, int rowIndex) {
        String stateCode = titleRow[rowIndex];
        String statistics = titleColumn[columnIndex];

        return _buildContentCell(
            child:
                _buildStats(widget.stateWiseDailyCount[stateCode], statistics));
      },
    );
  }

  Widget _buildHeading({
    String label,
    bool numeric,
    VoidCallback onSort,
    bool sorted,
    bool ascending,
  }) {
    return GestureDetector(
      onTap: onSort,
      child: Row(
        mainAxisAlignment:
            numeric ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: (Theme.of(context).brightness == Brightness.light)
                  ? Colors.black87
                  : Colors.white70,
            ),
          )),
          if (sorted) _buildSortArrow(ascending: ascending),
        ],
      ),
    );
  }

  Widget _buildSortArrow({ascending}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: SortArrow(down: !ascending),
    );
  }

  Widget _buildTitle({String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: (Theme.of(context).brightness == Brightness.light)
                      ? Colors.black87
                      : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStats(StateWiseDailyCount stateData, String statistics) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 4),
              Center(
                child: Container(
                  child: _getDeltaText(stateData.delta, statistics),
                ),
              ),
              SizedBox(height: 4),
              Center(
                child: Container(
                  child: _getTotalText(stateData.total, statistics),
                ),
              ),
              SizedBox(height: 4),
            ],
          ),
        ]);
  }

  Widget _buildLegendCell({@required Widget child}) {
    return Container(
      width: CellDimensions.base.stickyLegendWidth,
      height: CellDimensions.base.stickyLegendHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: child,
      decoration: BoxDecoration(
        border: Border(bottom: Divider.createBorderSide(context, width: 1.0)),
      ),
    );
  }

  Widget _buildRowTitle({@required Widget child}) {
    return Container(
      width: CellDimensions.base.stickyLegendWidth,
      height: CellDimensions.base.contentCellHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
      child: child,
      decoration: BoxDecoration(
        border: Border(bottom: Divider.createBorderSide(context, width: 1.0)),
      ),
    );
  }

  Widget _buildColumnTitle({@required Widget child}) {
    return Container(
      width: CellDimensions.base.contentCellWidth,
      height: CellDimensions.base.stickyLegendHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: child,
      decoration: BoxDecoration(
        border: Border(bottom: Divider.createBorderSide(context, width: 1.0)),
      ),
    );
  }

  Widget _buildContentCell({@required Widget child}) {
    return Container(
      width: CellDimensions.base.contentCellWidth,
      height: CellDimensions.base.contentCellHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
      child: child,
      decoration: BoxDecoration(
        border: Border(bottom: Divider.createBorderSide(context, width: 1.0)),
      ),
    );
  }

  _getDeltaText(Stats delta, statistics) {
    int value = _getStatistics(delta, statistics);

    return Text(
      (value < 0 ? "↓" : "↑") +
          NumberFormat.decimalPattern('en_IN').format(value),
      style: TextStyle(
          fontSize: 12,
          color: value > 0
              ? Constants.STATS_COLOR[statistics]
              : Colors.transparent),
    );
  }

  _getTotalText(Stats total, statistics) {
    int value = _getStatistics(total, statistics);

    return Text(
      NumberFormat.decimalPattern('en_IN').format(value),
      style: TextStyle(
        fontSize: 12,
        color: (Theme.of(context).brightness == Brightness.light)
            ? Colors.black87
            : Colors.white70,
      ),
    );
  }

  List<String> _getTitleColumn() {
    return Constants.PRIMARY_STATISTICS;
  }

  List<String> _getTitleRow() {
    return sortColumn(sortColumnIndex, isAscending);
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

  List<String> sortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => widget.stateWiseDailyCount[a].name
                  .compareTo(widget.stateWiseDailyCount[b].name))
              ..add('TT');
      } else {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => widget.stateWiseDailyCount[b].name
                  .compareTo(widget.stateWiseDailyCount[a].name))
              ..add('TT');
      }
    } else if (columnIndex == 1) {
      if (ascending) {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => widget.stateWiseDailyCount[a].total.confirmed
                  .compareTo(widget.stateWiseDailyCount[b].total.confirmed))
              ..add('TT');
      } else {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => widget.stateWiseDailyCount[b].total.confirmed
                  .compareTo(widget.stateWiseDailyCount[a].total.confirmed))
              ..add('TT');
      }
    } else if (columnIndex == 2) {
      if (ascending) {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => widget.stateWiseDailyCount[a].total.active
                  .compareTo(widget.stateWiseDailyCount[b].total.active))
              ..add('TT');
      } else {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => widget.stateWiseDailyCount[b].total.active
                  .compareTo(widget.stateWiseDailyCount[a].total.active))
              ..add('TT');
      }
    } else if (columnIndex == 3) {
      if (ascending) {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => widget.stateWiseDailyCount[a].total.recovered
                  .compareTo(widget.stateWiseDailyCount[b].total.recovered))
              ..add('TT');
      } else {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => widget.stateWiseDailyCount[b].total.recovered
                  .compareTo(widget.stateWiseDailyCount[a].total.recovered))
              ..add('TT');
      }
    } else if (columnIndex == 4) {
      if (ascending) {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => widget.stateWiseDailyCount[a].total.recovered
                  .compareTo(widget.stateWiseDailyCount[b].total.recovered))
              ..add('TT');
      } else {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => widget.stateWiseDailyCount[b].total.deceased
                  .compareTo(widget.stateWiseDailyCount[a].total.deceased))
              ..add('TT');
      }
    }

    return widget.stateWiseDailyCount.keys.toList();
  }
}
