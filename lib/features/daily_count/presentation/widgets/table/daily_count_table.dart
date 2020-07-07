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

class SortData {
  final int columnIndex;
  final bool ascending;
  final bool delta;

  SortData({this.columnIndex, this.ascending, this.delta});
}

class DailyCountTable extends StatefulWidget {
  final Map<String, StateWiseDailyCount> stateWiseDailyCount;
  final Map<String, DistrictWiseDailyCount> districtWiseDailyCount;

  DailyCountTable({this.stateWiseDailyCount, this.districtWiseDailyCount});

  @override
  _DailyCountTableState createState() => _DailyCountTableState();
}

class _DailyCountTableState extends State<DailyCountTable> {
  TableOption tableOption;
  SortData sortData;
  bool perMillion;

  List<String> titleRow;
  List<String> titleColumn;

  _DailyCountTableState()
      : tableOption = TableOption.STATES,
        sortData = new SortData(
          columnIndex: 1,
          ascending: false,
          delta: false,
        ),
        perMillion = false,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DailyCountTableTop(
          district: tableOption == TableOption.DISTRICTS,
          perMillion: perMillion,
          setDistrict: () {
            setState(() {
              tableOption = (tableOption == TableOption.DISTRICTS)
                  ? TableOption.STATES
                  : TableOption.DISTRICTS;
              titleRow = _getTitleRow();
            });
          },
          setPerMillion: () {
            setState(() {
              perMillion = !perMillion;
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
                    if (sortData.columnIndex == 0) {
                      sortData = new SortData(
                          columnIndex: sortData.columnIndex,
                          ascending: !sortData.ascending,
                          delta: sortData.delta);
                    } else {
                      sortData = new SortData(
                          columnIndex: 0,
                          ascending: sortData.ascending,
                          delta: sortData.delta);
                    }

                    titleRow = sortColumn(sortData);
                  });
                },
                child: _buildHeading(
                  label: tableOption == TableOption.STATES
                      ? "State/UT"
                      : "Districts",
                  numeric: false,
                  sorted: sortData.columnIndex == 0,
                  ascending: sortData.ascending,
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
                      if (sortData.columnIndex == columnIndex + 1) {
                        sortData = new SortData(
                            columnIndex: sortData.columnIndex,
                            ascending: !sortData.ascending,
                            delta: sortData.delta);
                      } else {
                        sortData = new SortData(
                            columnIndex: columnIndex + 1,
                            ascending: sortData.ascending,
                            delta: sortData.delta);
                      }

                      titleRow = sortColumn(sortData);
                    });
                  },
                  onLongPress: () {
                    setState(() {
                      sortData = new SortData(
                          columnIndex: sortData.columnIndex,
                          ascending: sortData.ascending,
                          delta: !sortData.delta);

                      titleRow = sortColumn(sortData);
                    });
                  },
                  child: _buildHeading(
                      label: titleColumn[columnIndex].capitalize(),
                      numeric: true,
                      sorted: sortData.columnIndex == columnIndex + 1,
                      ascending: sortData.ascending,
                      arrowColor: _arrowColor(
                          statistic: titleColumn[columnIndex],
                          delta: sortData.delta)));
            },
            contentCellBuilder: (int columnIndex, int rowIndex) {
              if (tableOption == TableOption.STATES) {
                String stateCode = titleRow[rowIndex];
                String statistics = titleColumn[columnIndex];

                return _buildContentCell(
                    child: _buildStats(
                        widget.stateWiseDailyCount[stateCode], statistics));
              } else {
                String districtName = titleRow[rowIndex];
                String statistics = titleColumn[columnIndex];

                return _buildContentCell(
                    child: _buildStats(
                        widget.districtWiseDailyCount[districtName],
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
    Color arrowColor,
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
        if (sorted) _buildSortArrow(ascending: ascending, color: arrowColor),
      ],
    );
  }

  Widget _buildSortArrow({bool ascending, Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: SortArrow(down: !ascending, color: color),
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

  Widget _buildStats(dynamic data, String statistics) {
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
                  child: _getDeltaText(data, statistics),
                ),
              ),
              SizedBox(height: 4),
              Center(
                child: Container(
                  child: _getTotalText(data, statistics),
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

  Widget _buildColumnTitle(
      {@required Widget child,
      @required onTap,
      @required VoidCallback onLongPress}) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
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

  _getDeltaText(dynamic data, statistics) {
    int value =
        _getStatistics(data, 'delta', statistics, perMillion: perMillion);

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

  _getTotalText(dynamic data, statistics) {
    int value =
        _getStatistics(data, 'total', statistics, perMillion: perMillion);

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

  Color _arrowColor({String statistic, bool delta}) {
    if (delta) {
      return Constants.STATS_COLOR[statistic];
    }

    return (Theme.of(context).brightness == Brightness.light)
        ? Colors.black87
        : Colors.white70;
  }

  List<String> _getTitleColumn() {
    return Constants.TABLE_STATISTICS;
  }

  List<String> _getTitleRow() {
    return sortColumn(sortData);
  }

  int _getStatistics(dynamic data, String type, String statistic,
      {perMillion: false}) {
    int count = _getStatisticValue(_getStatisticType(data, type), statistic);

    if (perMillion && data.metadata.population == null) {
      return 0;
    }

    return perMillion ? (1000000 * count) ~/ data.metadata.population : count;
  }

  int _getStatisticValue(Stats data, String statistics) {
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

  Stats _getStatisticType(dynamic data, String type) {
    if (type == 'delta') {
      return data.delta;
    } else {
      return data.total;
    }
  }

  List<String> sortColumn(SortData sortData) {
    if (tableOption == TableOption.STATES) {
      return _sortStateColumn(sortData);
    } else {
      return _sortDistrictColumn(sortData)
          .sublist(0, Constants.DISTRICT_TABLE_COUNT);
    }
  }

  List<String> _sortStateColumn(SortData sortData) {
    if (sortData.columnIndex == 0) {
      if (sortData.ascending) {
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
    } else if (sortData.columnIndex == 1) {
      if (sortData.ascending) {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => _getStatistics(widget.stateWiseDailyCount[a],
                      sortData.delta ? 'delta' : 'total', 'confirmed',
                      perMillion: perMillion)
                  .compareTo(_getStatistics(widget.stateWiseDailyCount[b],
                      sortData.delta ? 'delta' : 'total', 'confirmed',
                      perMillion: perMillion)))
              ..add('TT');
      } else {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => _getStatistics(widget.stateWiseDailyCount[b],
                      sortData.delta ? 'delta' : 'total', 'confirmed',
                      perMillion: perMillion)
                  .compareTo(_getStatistics(widget.stateWiseDailyCount[a],
                      sortData.delta ? 'delta' : 'total', 'confirmed',
                      perMillion: perMillion)))
              ..add('TT');
      }
    } else if (sortData.columnIndex == 2) {
      if (sortData.ascending) {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => _getStatistics(widget.stateWiseDailyCount[a],
                      sortData.delta ? 'delta' : 'total', 'active',
                      perMillion: perMillion)
                  .compareTo(_getStatistics(widget.stateWiseDailyCount[b],
                      sortData.delta ? 'delta' : 'total', 'active',
                      perMillion: perMillion)))
              ..add('TT');
      } else {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => _getStatistics(widget.stateWiseDailyCount[b],
                      sortData.delta ? 'delta' : 'total', 'active',
                      perMillion: perMillion)
                  .compareTo(_getStatistics(widget.stateWiseDailyCount[a],
                      sortData.delta ? 'delta' : 'total', 'active',
                      perMillion: perMillion)))
              ..add('TT');
      }
    } else if (sortData.columnIndex == 3) {
      if (sortData.ascending) {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => _getStatistics(widget.stateWiseDailyCount[a],
                      sortData.delta ? 'delta' : 'total', 'recovered',
                      perMillion: perMillion)
                  .compareTo(_getStatistics(widget.stateWiseDailyCount[b],
                      sortData.delta ? 'delta' : 'total', 'recovered',
                      perMillion: perMillion)))
              ..add('TT');
      } else {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => _getStatistics(widget.stateWiseDailyCount[b],
                      sortData.delta ? 'delta' : 'total', 'recovered',
                      perMillion: perMillion)
                  .compareTo(_getStatistics(widget.stateWiseDailyCount[a],
                      sortData.delta ? 'delta' : 'total', 'recovered',
                      perMillion: perMillion)))
              ..add('TT');
      }
    } else if (sortData.columnIndex == 4) {
      if (sortData.ascending) {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => _getStatistics(widget.stateWiseDailyCount[a],
                      sortData.delta ? 'delta' : 'total', 'deceased',
                      perMillion: perMillion)
                  .compareTo(_getStatistics(widget.stateWiseDailyCount[b],
                      sortData.delta ? 'delta' : 'total', 'deceased',
                      perMillion: perMillion)))
              ..add('TT');
      } else {
        return widget.stateWiseDailyCount.keys
            .toList()
            .where((stateCode) => stateCode != 'TT')
            .toList()
              ..sort((a, b) => _getStatistics(widget.stateWiseDailyCount[b],
                      sortData.delta ? 'delta' : 'total', 'deceased',
                      perMillion: perMillion)
                  .compareTo(_getStatistics(widget.stateWiseDailyCount[a],
                      sortData.delta ? 'delta' : 'total', 'deceased',
                      perMillion: perMillion)))
              ..add('TT');
      }
    }

    return widget.stateWiseDailyCount.keys.toList();
  }

  List<String> _sortDistrictColumn(SortData sortData) {
    if (sortData.columnIndex == 0) {
      if (sortData.ascending) {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => widget.districtWiseDailyCount[a].name
              .compareTo(widget.districtWiseDailyCount[b].name));
      } else {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => widget.districtWiseDailyCount[b].name
              .compareTo(widget.districtWiseDailyCount[a].name));
      }
    } else if (sortData.columnIndex == 1) {
      if (sortData.ascending) {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => _getStatistics(widget.districtWiseDailyCount[a],
                  sortData.delta ? 'delta' : 'total', 'confirmed',
                  perMillion: perMillion)
              .compareTo(_getStatistics(widget.districtWiseDailyCount[b],
                  sortData.delta ? 'delta' : 'total', 'confirmed',
                  perMillion: perMillion)));
      } else {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => _getStatistics(widget.districtWiseDailyCount[b],
                  sortData.delta ? 'delta' : 'total', 'confirmed',
                  perMillion: perMillion)
              .compareTo(_getStatistics(widget.districtWiseDailyCount[a],
                  sortData.delta ? 'delta' : 'total', 'confirmed',
                  perMillion: perMillion)));
      }
    } else if (sortData.columnIndex == 2) {
      if (sortData.ascending) {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => _getStatistics(widget.districtWiseDailyCount[a],
                  sortData.delta ? 'delta' : 'total', 'active',
                  perMillion: perMillion)
              .compareTo(_getStatistics(widget.districtWiseDailyCount[b],
                  sortData.delta ? 'delta' : 'total', 'active',
                  perMillion: perMillion)));
      } else {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => _getStatistics(widget.districtWiseDailyCount[b],
                  sortData.delta ? 'delta' : 'total', 'active',
                  perMillion: perMillion)
              .compareTo(_getStatistics(widget.districtWiseDailyCount[a],
                  sortData.delta ? 'delta' : 'total', 'active',
                  perMillion: perMillion)));
      }
    } else if (sortData.columnIndex == 3) {
      if (sortData.ascending) {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => _getStatistics(widget.districtWiseDailyCount[a],
                  sortData.delta ? 'delta' : 'total', 'recovered',
                  perMillion: perMillion)
              .compareTo(_getStatistics(widget.districtWiseDailyCount[b],
                  sortData.delta ? 'delta' : 'total', 'recovered',
                  perMillion: perMillion)));
      } else {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => _getStatistics(widget.districtWiseDailyCount[b],
                  sortData.delta ? 'delta' : 'total', 'recovered',
                  perMillion: perMillion)
              .compareTo(_getStatistics(widget.districtWiseDailyCount[a],
                  sortData.delta ? 'delta' : 'total', 'recovered',
                  perMillion: perMillion)));
      }
    } else if (sortData.columnIndex == 4) {
      if (sortData.ascending) {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => _getStatistics(widget.districtWiseDailyCount[a],
                  sortData.delta ? 'delta' : 'total', 'deceased',
                  perMillion: perMillion)
              .compareTo(_getStatistics(widget.districtWiseDailyCount[b],
                  sortData.delta ? 'delta' : 'total', 'deceased',
                  perMillion: perMillion)));
      } else {
        return widget.districtWiseDailyCount.keys.toList()
          ..sort((a, b) => _getStatistics(widget.districtWiseDailyCount[b],
                  sortData.delta ? 'delta' : 'total', 'deceased',
                  perMillion: perMillion)
              .compareTo(_getStatistics(widget.districtWiseDailyCount[a],
                  sortData.delta ? 'delta' : 'total', 'deceased',
                  perMillion: perMillion)));
      }
    }

    return widget.districtWiseDailyCount.keys.toList();
  }
}
