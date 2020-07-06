import 'package:covid19india/core/common/widgets/sort_arrow.dart';
import 'package:covid19india/core/common/widgets/sticky_headers_table.dart';
import 'package:covid19india/core/constants/constants.dart';
import 'package:covid19india/core/util/extensions.dart';
import 'package:covid19india/features/daily_count/domain/entities/district_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/state_wise_daily_count.dart';
import 'package:covid19india/features/daily_count/domain/entities/stats.dart';
import 'package:covid19india/features/daily_count/presentation/widgets/table/daily_count_table_top.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TableOption { STATES, DISTRICTS }

class DailyCountTable extends StatefulWidget {
  final Map<String, StateWiseDailyCount> stateWiseDailyCount;
  final Map<String, DistrictWiseDailyCount> districtWiseDailyCount;

  DailyCountTable({this.stateWiseDailyCount, this.districtWiseDailyCount});

  @override
  _DailyCountTableState createState() => _DailyCountTableState();
}

class _DailyCountTableState extends State<DailyCountTable> {
  TableOption tableOption;
  int sortColumnIndex;
  bool isAscending;
  bool perMillion;

  List<String> titleRow;
  List<String> titleColumn;

  _DailyCountTableState()
      : tableOption = TableOption.STATES,
        sortColumnIndex = 1,
        perMillion = false,
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
    print(titleRow.length);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DailyCountTableTop(
          setDistrict: (bool district) {
            setState(() {
              tableOption =
                  district ? TableOption.DISTRICTS : TableOption.STATES;
              titleRow = _getTitleRow();
            });
          },
          setPerMillion: (bool perMillion) {
            setState(() {
              perMillion = perMillion;
            });
          },
        ),
        Expanded(
          child: StickyHeadersTable(
            rowsLength: titleRow.length,
            columnsLength: titleColumn.length,
            legendCell: _buildLegendCell(
                onTap: () {
                  setState(() {
                    if (sortColumnIndex == 0) {
                      isAscending = !isAscending;
                    }
                    sortColumnIndex = 0;
                    titleRow = sortColumn(sortColumnIndex, isAscending);
                  });
                },
                child: _buildHeading(
                  label: tableOption == TableOption.STATES
                      ? "State/UT"
                      : "Districts",
                  numeric: false,
                  sorted: sortColumnIndex == 0,
                  ascending: isAscending,
                )),
            rowsTitleBuilder: (int rowIndex) {
              if (tableOption == TableOption.STATES) {
                return _buildRowTitle(
                    child: _buildTitle(
                        text: (titleRow[rowIndex] == "TT"
                            ? "Total"
                            : Constants.STATE_CODE_MAP[titleRow[rowIndex]])));
              } else {
                return _buildRowTitle(
                    child: _buildTitle(text: (titleRow[rowIndex])));
              }
            },
            columnsTitleBuilder: (int columnIndex) {
              return _buildColumnTitle(
                  onTap: () {
                    setState(() {
                      if (sortColumnIndex == columnIndex + 1) {
                        isAscending = !isAscending;
                      }

                      sortColumnIndex = columnIndex + 1;
                      titleRow = sortColumn(sortColumnIndex, isAscending);
                    });
                  },
                  child: _buildHeading(
                    label: titleColumn[columnIndex].capitalize(),
                    numeric: true,
                    sorted: sortColumnIndex == columnIndex + 1,
                    ascending: isAscending,
                  ));
            },
            contentCellBuilder: (int columnIndex, int rowIndex) {
              if (tableOption == TableOption.STATES) {
                String stateCode = titleRow[rowIndex];
                String statistics = titleColumn[columnIndex];

                return _buildContentCell(
                    child: _buildStats(
                        widget.stateWiseDailyCount[stateCode].delta,
                        widget.stateWiseDailyCount[stateCode].total,
                        statistics));
              } else {
                String districtName = titleRow[rowIndex];
                String statistics = titleColumn[columnIndex];

                return _buildContentCell(
                    child: _buildStats(
                        widget.districtWiseDailyCount[districtName].delta,
                        widget.districtWiseDailyCount[districtName].total,
                        statistics));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeading({
    String label,
    bool numeric,
    bool sorted,
    bool ascending,
  }) {
    return Row(
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

  Widget _buildStats(Stats delta, Stats total, String statistics) {
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
                  child: _getDeltaText(delta, statistics),
                ),
              ),
              SizedBox(height: 4),
              Center(
                child: Container(
                  child: _getTotalText(total, statistics),
                ),
              ),
              SizedBox(height: 4),
            ],
          ),
        ]);
  }

  Widget _buildLegendCell(
      {@required Widget child, @required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
        width: CellDimensions.base.stickyLegendWidth,
        height: CellDimensions.base.stickyLegendHeight,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: child,
        decoration: BoxDecoration(
          border: Border(bottom: Divider.createBorderSide(context, width: 1.0)),
        ),
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

  Widget _buildColumnTitle({@required Widget child, @required onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
        width: CellDimensions.base.contentCellWidth,
        height: CellDimensions.base.stickyLegendHeight,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: child,
        decoration: BoxDecoration(
          border: Border(bottom: Divider.createBorderSide(context, width: 1.0)),
        ),
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
    return Constants.TABLE_STATISTICS;
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
    if (tableOption == TableOption.STATES) {
      return _sortStateColumn(columnIndex, ascending);
    } else {
      return _sortDistrictColumn(columnIndex, ascending)
          .sublist(0, Constants.DISTRICT_TABLE_COUNT);
    }
  }

  List<String> _sortStateColumn(int columnIndex, bool ascending) {
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

  List<String> _sortDistrictColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => widget.districtWiseDailyCount[a].name
              .compareTo(widget.districtWiseDailyCount[b].name));
      } else {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => widget.districtWiseDailyCount[b].name
              .compareTo(widget.districtWiseDailyCount[a].name));
      }
    } else if (columnIndex == 1) {
      if (ascending) {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => widget.districtWiseDailyCount[a].total.confirmed
              .compareTo(widget.districtWiseDailyCount[b].total.confirmed));
      } else {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => widget.districtWiseDailyCount[b].total.confirmed
              .compareTo(widget.districtWiseDailyCount[a].total.confirmed));
      }
    } else if (columnIndex == 2) {
      if (ascending) {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => widget.districtWiseDailyCount[a].total.active
              .compareTo(widget.districtWiseDailyCount[b].total.active));
      } else {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => widget.districtWiseDailyCount[b].total.active
              .compareTo(widget.districtWiseDailyCount[a].total.active));
      }
    } else if (columnIndex == 3) {
      if (ascending) {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => widget.districtWiseDailyCount[a].total.recovered
              .compareTo(widget.districtWiseDailyCount[b].total.recovered));
      } else {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => widget.districtWiseDailyCount[b].total.recovered
              .compareTo(widget.districtWiseDailyCount[a].total.recovered));
      }
    } else if (columnIndex == 4) {
      if (ascending) {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => widget.districtWiseDailyCount[a].total.recovered
              .compareTo(widget.districtWiseDailyCount[b].total.recovered));
      } else {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => widget.districtWiseDailyCount[b].total.deceased
              .compareTo(widget.districtWiseDailyCount[a].total.deceased));
      }
    }

    return widget.districtWiseDailyCount.keys.toList();
  }
}
